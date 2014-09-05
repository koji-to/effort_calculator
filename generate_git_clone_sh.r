####### generate .sh script for "git clone"
##### Set git directory structure file path
gitweb<-"http://git.chromium.org/gitweb/?a=project_index"
#####
shell.df<-read.csv(gitweb,header=F)

### save git repository tree in local
write.table(shell.df,"chromium_git_repo_tree.txt",col.names=F,row.names=F,quote=F,append=F)

###generage shell script for "git clone" 
shell_top.df<-matrix(c("#!/bin/sh","cd git_repo"),2,1)
write.table(shell_top.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=F)

shell.df[,1]<-gsub("^(.*)\\.git","git clone https://git\\.chromium\\.org/git/\\1\\.git \\1",shell.df[,1])
write.table(shell.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=T)

### make directory for git clone
dir.create("git_repo")

##### This scriot is only for The Chromium Project
##### in other(not Chromium) project,
##### run "git clone --recursive ..."
##### and
##### run "ls -aR | grep \.git:$ | sed -e 's/\.\/\(.*\):/\1/' > chromium_git_repo_tree.txt"
##### in top directory
