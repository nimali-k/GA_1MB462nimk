#!/bin/bash -l

#check git version
git --version 

#update git version 
module load git

#can recheck the version if needed 

#store the credential helper 
	#git config --global credential.helper
	#store

#clone the repository when asked for pat token provide the token created on the git repository
	#git clone  /path to the repository 

#to unsave credentials 
	#git config --global --unset credential.helper

#pull the newest version from repo before commiting 
	git pull 

#add the files in git 
	#git add <filename>


