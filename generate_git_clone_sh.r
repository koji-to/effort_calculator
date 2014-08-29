######## generate .sh script for "git clone"
##### Set git directory structure file path
gitweb<-"https://git.chromium.org/gitweb/?a=project_index"
#####
shell.df<-read.csv(gitweb,header=F)

shell_top.df<-matrix(c("#!/bin/sh","cd git_repo"),2,1)
write.table(shell_top.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=F)

shell.df[,1]<-gsub("^(.*)\\.git","git clone https://git\\.chromium\\.org/git/\\1\\.git \\1",shell.df[,1])
write.table(shell.df,"git_clone.sh",row.names=F,col.names=F,quote=F,append=T)