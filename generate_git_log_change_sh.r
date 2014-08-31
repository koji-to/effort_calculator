######## generate .sh script for "git log" about change log
######## git log option: --numstat %H%b

shell.df<-read.csv("chromium_git_repo_tree.txt",header=F)

shell_top.df<-matrix(c("#!/bin/sh","logdir=\"`pwd`/git_log_change/\"","hmdir=\"`pwd`\""),3,1)
write.table(shell_top.df,"git_log_change.sh",row.names=F,col.names=F,quote=F,append=F)

### replace by regular expression.
shell_slash.df<-data.frame(shell.df[grep("/",shell.df[,1]),1])
shell_slash.df[,1]<-gsub("^(.*)\\/(.*)\\.git","cd git_repo\\/\\1\\/\\2\\\nout=\\2\\.git\\\ngit log --numstat --pretty=format:\"\\[\\[SOF\\]\\]%H\\[\\[EOF\\]\\]%n%b\" >> \"${logdir}${out}_change.log\"\\\ncd $hmdir",shell_slash.df[,1])
write.table(shell_slash.df,"git_log_change.sh",row.names=F,col.names=F,quote=F,append=T)

shell_without_slash.df<-data.frame(shell.df[-(grep("/",shell.df[,1])),])
shell_without_slash.df[,1]<-gsub("^(.*)\\.git","cd git_repo\\/\\1\\\nout=\\1\\.git\\\ngit log --numstat --pretty=format:\"\\[\\[SOF\\]\\]%H\\[\\[EOF\\]\\]%n%b\" >> \"${logdir}${out}_change.log\"\\\ncd $hmdir",shell_without_slash.df[,1])
write.table(shell_without_slash.df,"git_log_change.sh",row.names=F,col.names=F,quote=F,append=T)

dir.create("git_log_change")

### generate change log files' name list
shell.df[,1]<-gsub("^.*\\/(.*)\\.git","\\1\\.git",shell.df[,1])
shell.df[,1]<-gsub("^(.*)\\.git","\\1\\.git_change.log",shell.df[,1])
shell.df<-unique(shell.df)
write.table(shell.df,"git_log_change/git_log_change_list.txt",row.names=F,col.names=F,quote=F,append=T)
