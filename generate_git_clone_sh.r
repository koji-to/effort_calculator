######## generate .sh script for "git clone"
##### Set git directory structure file path from chromium project
gitweb<-"https://git.chromium.org/gitweb/?a=project_index"
#####
shell.df<-read.csv(gitweb,header=F)

shell_top.df<-matrix(c("#!/bin/sh","cd git_repo"),2,1)
write.table(shell_top.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=F)

shell.df[,1]<-gsub("^(.*)\\.git","git clone https://git\\.chromium\\.org/git/\\1\\.git \\1",shell.df[,1])
write.table(shell.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=T)

### make directory for git clone
dir.create("git_repo")

### save git repository tree in local
write.table(shell.df,"chromium_git_repo_tree.txt",col.names=F,row.names=F,quote=F,append=F)

##### This scriot is only for The Chromium Project
##### in other(not Chromium) project, run "git clone --recursive <foo>" and "ls -aR | grep \.git:$ | sed -e 's/\.\/\(.*\):/\1/' in top directory
