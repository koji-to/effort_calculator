### merge binded main log and binded change log

main_log_bind.df<-read.csv("git_log_main_bind.csv",header=T)
change_log_bind.df<-read.csv("git_log_change_bind.csv",header=T)
git_log_merged.df<-merge(main_log_bind.df,change_log_bind.df)
git_log_merged.df<-unique(git_log_merged.df)
write.csv(git_log_merged.df,paste("git_log_main_change_merged.csv",row.names=F)
