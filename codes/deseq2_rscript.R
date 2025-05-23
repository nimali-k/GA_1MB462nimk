if (!requireNamespace("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")} if (!requireNamespace("DESeq2", quietly = TRUE)) {
  BiocManager::install("DESeq2")
}
if (!requireNamespace("apeglm", quietly = TRUE)) {
  BiocManager::install("apeglm")
}
if (!requireNamespace("pheatmap", quietly = TRUE)) {
  BiocManager::install("pheatmap")
}
library("DESeq2") library("pheatmap") library("ggplot2") library(apeglm) library(ggrepel) library(dplyr) library(stringr)
# Load data
counts_data <- read.delim("counts.txt", comment.char = "#", stringsAsFactors = FALSE)
# Columns: Geneid, Chr, Start, End, Strand, Length, Control_1, Control_2, Control_3, Heat_treated_.._1, ..., Heat_treated_..3 Remove 
# columns: Chr, Start, End, Strand, Length
cts <- counts_data[, c(1, 7:ncol(counts_data))]
# Set gene IDs as row names
rownames(cts) <- cts$Geneid cts <- cts[ , -1]
# Create metadata object
coldata <- data.frame(
  row.names = colnames(cts),
  condition = factor(c("control", "control", "control",
                       "heat_treated", "heat_treated", "heat_treated")) )
# Construct DESeq2 dataset
dds <- DESeqDataSetFromMatrix(
  countData = cts,
  colData = coldata,
  design = ~ condition )
# Pre filtering
keep <- rowSums(counts(dds)) >= 10 dds <- dds[keep,]
# Set Factor Level
dds$condition <- relevel(dds$condition, ref = "control")
# Run DESeq
dds <- DESeq(dds) res <- results(dds)
# Shrinkage of effect size (LFC estimates)
resLFC <- lfcShrink(dds, coef ="condition_heat_treated_vs_control", type="apeglm")
# Summary Results
summary(res) summary(resLFC)
# Convert to data frame
res_df <- as.data.frame(resLFC) write.csv(res_df, "deseq2_results.csv", row.names = TRUE)
# ------------------------------------------------------------------------------ MA PLOT Define label levels
diffexp_levels <- c(
  "Highly downregulated",
  "Downregulated",
  "Weak or No change",
  "Upregulated",
  "Highly upregulated",
  "Not significant" )
# Set default category
res_df$diffexp_sig <- factor("Not significant", levels = diffexp_levels)
# Identify significant rows
sig_idx <- !is.na(res_df$padj) & res_df$padj < 0.1
# Assign categories to significant rows
res_df$diffexp_sig[sig_idx] <- cut(
  res_df$log2FoldChange[sig_idx],
  breaks = c(-Inf, -2, -1, 1, 2, Inf),
  labels = diffexp_levels[1:5],
  ordered_result = TRUE )
# Restore factor structure
res_df$diffexp_sig <- factor(res_df$diffexp_sig, levels = diffexp_levels) table(res_df$diffexp_sig)
# Generate plot
ggplot(res_df, aes(x = baseMean, y = log2FoldChange, color = diffexp_sig)) +
  geom_point(size = 1, alpha = 0.6) +
  scale_x_log10() +
  scale_color_manual(
    values = c(
      "Highly downregulated" = "navy",
      "Downregulated" = "skyblue",
      "Weak or No change" = "gray50",
      "Upregulated" = "pink",
      "Highly upregulated" = "firebrick",
      "Not significant" = "gray90"
    ),
    name = "Differential expression"
  ) +
  geom_hline(yintercept = 0, linetype = "solid") +
  labs(
    title = "MA Plot: Heat treated vs. Control",
    x = "Mean normalized expression (log10 scale)",
    y = "Log2 fold change (shrunken)"
  ) +
  coord_cartesian(ylim = c(-6, 6)) +
  scale_y_continuous(breaks = seq(-6, 6, by = 2)) +
  theme_minimal()
# ------------------------------------------------------------------------------ Volcano Plot Add -log10(padj) column
res_df$neglog10padj <- -log10(res_df$padj)
# Define a significance label (optional)
res_df$sig <- ifelse(res_df$padj < 0.1 & abs(res_df$log2FoldChange) > 1, "yes", "no") res_df$volcano_color <- ifelse(
  res_df$padj < 0.1 & res_df$log2FoldChange > 1, "up",
  ifelse(res_df$padj < 0.1 & res_df$log2FoldChange < -1, "down", "ns") )
# Select top 10 upregulated genes
top10_up <- res_df[res_df$padj < 0.1 & res_df$log2FoldChange > 1, ] top10_up <- top10_up[order(top10_up$padj), ][1:10, ]
# Select top 10 downregulated genes
top10_down <- res_df[res_df$padj < 0.1 & res_df$log2FoldChange < -1, ] top10_down <- top10_down[order(top10_down$padj), ][1:10, ]
# Combine
top10_labeled <- rbind(top10_up, top10_down) top10_labeled$gene <- rownames(top10_labeled)
# Plot with labels
ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = volcano_color)) +
  geom_point(alpha = 0.6) +
  scale_color_manual(
    values = c("up" = "red", "down" = "blue", "ns" = "gray90"),
    labels = c(
      "up" = "Upregulated (FDR < 0.1, LFC > 1)",
      "down" = "Downregulated (FDR < 0.1, LFC < -1)",
      "ns" = "Not significant (FDR ≥ 0.1 or |LFC| ≤ 1)"
    ),
    name = "Significance"
  ) +
  geom_text_repel(
    data = top10_labeled,
    aes(label = gene),
    size = 3,
    box.padding = 0.3,
    point.padding = 0.2,
    max.overlaps = Inf
  ) +
  labs(
    title = "Differentially Expressed Genes: Top 10 Up/Downregulated (FDR < 0.1)",
    x = "log2FoldChange",
    y = "-log10 adjusted p-value"
  ) +
  theme_minimal()
# ------------------------------------------------------------------------------ Top 10 Up- and Downregulated Genes Analysis 
# ------------------------------------------ Top 10 up- and downregulated genes
gff <- read.delim("n.japonicum.emapper.decorated.gff", header = FALSE, sep = "\t", stringsAsFactors = FALSE, comment.char = "#", fill = 
TRUE) colnames(gff) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
# Extract NJAPM -> NJAPG mapping from attributes
gene_mrna <- gff[gff$type == "mRNA", "attributes"] gene_mrna_df <- data.frame(
  mRNA_ID = str_match(gene_mrna, "ID=([^;]+)")[, 2],
  gene_ID = str_match(gene_mrna, "Parent=([^;]+)")[, 2],
  stringsAsFactors = FALSE )
# Load annotation file (eggNOG-mapper output) and join with transcript -> gene mapping 1. Read all lines first
lines <- readLines("n.japonicum.emapper.annotations")
# 2. Identify header line index
header_line_index <- grep("^#query", lines)[1]
# 3. Extract header and clean it
header <- strsplit(sub("^#", "", lines[header_line_index]), "\t")[[1]]
#annotations <- read.delim("n.japonicum.emapper.annotations", header = TRUE, stringsAsFactors = FALSE)
# 4. Read the rest of the file skipping the header line
annotations <- read.delim("n.japonicum.emapper.annotations",
                          header = FALSE,
                          sep = "\t",
                          skip = header_line_index,
                          stringsAsFactors = FALSE,
                          fill = TRUE,
                          quote = "")
# 5. Assign column names
colnames(annotations) <- header annotations_mapped <- merge(gene_mrna_df, annotations, by.x = "mRNA_ID", by.y = "query")
# Summarize annotations per gene (one row per NJAPG gene)
annotations_per_gene <- annotations_mapped %>%
  group_by(gene_ID) %>%
  summarise(
    Gene_Name = first(Preferred_name[Preferred_name != "-" & !is.na(Preferred_name)]),
    Description = paste(unique(Description[Description != "-" & !is.na(Description)]), collapse = "; "),
    COG_category = paste(unique(COG_category[COG_category != "-" & !is.na(COG_category)]), collapse = "; "),
    GO_Terms = paste(unique(GOs[GOs != "-" & !is.na(GOs)]), collapse = "; ")
  ) %>%
  ungroup() colnames(annotations_per_gene)[1] <- "GeneID"
# Merge annotation into top DE gene tables
top10_up$GeneID <- rownames(top10_up) top10_down$GeneID <- rownames(top10_down) top10_up_annot <- merge(top10_up, annotations_per_gene, 
by = "GeneID", all.x = TRUE) top10_down_annot <- merge(top10_down, annotations_per_gene, by = "GeneID", all.x = TRUE)
# Final format for report tables
final_cols <- c("GeneID", "Gene_Name", "baseMean", "log2FoldChange", "padj", "Description", "COG_category") top10_up_final <- 
top10_up_annot[, final_cols] top10_down_final <- top10_down_annot[, final_cols] write.table(top10_up_final, "top10_upregulated.txt", 
sep = "\t", quote = FALSE, row.names = FALSE) write.table(top10_down_final, "top10_downregulated.txt", sep = "\t", quote = FALSE, 
row.names = FALSE)
# ------------------------------------------------------------------------------ Heatmap Variance stabilizing transformation
vsd <- vst(dds, blind = FALSE)
# Combine top genes
top_genes <- c(rownames(top10_up), rownames(top10_down))
# Extract normalized expression values
mat <- assay(vsd)[top_genes, ] mat_scaled <- t(scale(t(mat))) # z-score normalization per gene
# Annotation for columns
colnames(mat_scaled) <- c(
  "Control_1", "Control_2", "Control_3",
  "Heat_treatment_1", "Heat_treatment_2", "Heat_treatment_3" ) annotation_col <- data.frame(
  condition = factor(c(
    rep("Control", 3),
    rep("Heat_treatment", 3)
  )) ) rownames(annotation_col) <- colnames(mat_scaled) pheatmap(
  mat_scaled,
  annotation_col = annotation_col,
  show_rownames = TRUE,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  scale = "none",
  color = colorRampPalette(c("blue", "white", "red"))(100) )
# ------------------------------------------------------------------------------ Heatmap PCA
pcaData <- plotPCA(vsd, intgroup = "condition", returnData = TRUE) percentVar <- round(100 * attr(pcaData, "percentVar")) 
ggplot(pcaData, aes(PC1, PC2, color = condition)) +
  geom_point(size = 3) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  coord_fixed() +
  theme_minimal()
