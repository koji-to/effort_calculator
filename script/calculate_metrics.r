#extract commit log from each relase cycle

##### set from args #####
args<-commandArgs(trailingOnly=T)

#check the number of arguments
if(length(args) == 0){
  print("use default setting (for Chromium), --args 42 2 2014-06-20 24")
  release_cycle<-42#days(= 6 weeks = 1.5month)
  threshold<-2#commits/release_cycle
  newest_release_date<-as.Date("2014-06-20")#ver37
  num_release<-24#: a number of past release to trace
}else if(length(args) != 4){
  write("Error: commandline arguments for <release_cycle(days)> <threshold of commits> <newest release date(yyyy-mm-dd)> <the number of going back release> are required", stderr())
  q()
}else{
  release_cycle<-as.numeric(args[1])
  threshold<-as.numeric(args[2])
  newest_release_date<-as.Date(args[3])
  num_release<-as.numeric(args[4])
}
# import merged git log file
git_log.df<-read.csv("git_log_main_change_merged.csv",header=T)
git_log.df$author_date<-as.Date(git_log.df$author_date)
git_log.df$author_mail<-as.character(git_log.df$author_mail)
#filtering
activity.df<-data.frame(1:num_release,1:2)
names(activity.df)<-c("Duration","Effort")
for(i in 1:num_release){
  git_log_tmp.df<-subset(git_log.df,git_log.df$author_date<(newest_release_date-release_cycle*(i-1)) & (newest_release_date-release_cycle*i)<=git_log.df$author_date)
  auth_freq.df<-data.frame(table(git_log_tmp.df$author_mail))
  names(auth_freq.df)<-c("author_mail","commit_count")
  
  activity.df$Duration[i]<-paste(newest_release_date-release_cycle*(i-1),"-",newest_release_date-release_cycle*i,sep="")
  # In original paper, non-fulltime developers' effort is caliculated by commit_count/threshold, so using ">="
  # http://gsyc.urjc.es/~grex/repro/2014-msr-effort/msr14-robles-estimating-effort.pdf
  fulltime_auth.df<-subset(auth_freq.df,auth_freq.df$commit_count>=threshold)
  parttime_auth.df<-subset(auth_freq.df,auth_freq.df$commit_count<threshold)
  parttime_auth.df$effort<-parttime_auth.df$commit_count/threshold
  # 28 = 1 month
  activity.df$Effort[i]<-(nrow(fulltime_auth.df)+sum(parttime_auth.df$effort))*(release_cycle/28)
  activity.df$commits[i]<-nrow(git_log_tmp.df)
  activity.df$bugfix_commits[i]<-nrow(subset(git_log_tmp.df,git_log_tmp.df$bug_fix==1))
  activity.df$refactoring_commits[i]<-nrow(subset(git_log_tmp.df,git_log_tmp.df$refactoring_flag==1))
  activity.df$newfunc_commits[i]<-nrow(subset(git_log_tmp.df,git_log_tmp.df$bug_fix!=1 & git_log_tmp.df$refactoring_flag!=1))
  activity.df$add_lines[i]<-sum(git_log_tmp.df$add_lines)
  activity.df$del_lines[i]<-sum(git_log_tmp.df$del_lines)
  activity.df$change_files[i]<-sum(git_log_tmp.df$change_files)
  
  ##temporary dataframe output
  #write.csv(auth_freq.df,paste("author_activity_from_",(newest_release_date-release_cycle*i),"_to_",(newest_release_date-release_cycle*(i-1)),".csv",sep=""),row.names=F)
}
write.csv(activity.df,paste("chromium_activity_metrics.csv",sep=""),row.names=F)
