######## generate .sh script for "git log" about main log
######## git log option: "%H%ae%ad%ce%cd"

shell.df<-read.csv("chromium_git_repo_tree.txt",header=F)

shell_top.df<-matrix(c("#!/bin/sh","logdir=\"`pwd`/git_log_main/\"","hmdir=\"`pwd`\""),3,1)
write.table(shell_top.df,"git_log_main.sh",row.names=F,col.names=F,quote=F,append=F)

### replace by regular expression.
shell_slash.df<-data.frame(shell.df[grep("/",shell.df[,1]),1])
shell_slash.df[,1]<-gsub("^(.*)\\/(.*)\\.git","cd git_repo\\/\\1\\/\\2\\\nout=\\2\\.git\\\ngit log --date=iso --pretty=format:\"\\[\\[SOF\\]\\]%H<chromium>%ae<chromium>%ad<chromium>%ce<chromium>%cd\\[\\[EOF\\]\\]\" >> \"${logdir}${out}_main.log\"\\\ncd $hmdir",shell_slash.df[,1])
write.table(shell_slash.df,"git_log_main.sh",row.names=F,col.names=F,quote=F,append=T)

shell_without_slash.df<-data.frame(shell.df[-(grep("/",shell.df[,1])),])
shell_without_slash.df[,1]<-gsub("^(.*)\\.git","cd git_repo\\/\\1\\\nout=\\1\\.git\\\ngit log --date=iso --pretty=format:\"\\[\\[SOF\\]\\]%H<chromium>%ae<chromium>%ad<chromium>%ce<chromium>%cd\\[\\[EOF\\]\\]\" >> \"${logdir}${out}_main.log\"\\\ncd $hmdir",shell_without_slash.df[,1])
write.table(shell_without_slash.df,"git_log_main.sh",row.names=F,col.names=F,quote=F,append=T)

dir.create("git_log_main")

#### generate change log files' name list
shell.df[,1]<-gsub("^.*\\/(.*)\\.git","\\1\\.git",shell.df[,1])
shell.df[,1]<-gsub("^(.*)\\.git","\\1\\.git_main.log",shell.df[,1])
shell.df<-unique(shell.df)
write.table(shell.df,"git_log_main/git_log_main_list.txt",row.names=F,col.names=F,quote=F,append=T)
