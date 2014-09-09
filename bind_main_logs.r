##### binding git main log and extraction

file_list.df<-read.table("git_log_main/git_log_main_list.txt",header=F)

###binding
output_df_exist_checker<-0
for(i in 1:nrow(file_list.df)){
  open_file_name<-paste("git_log_main_proc/proc_",file_list.df[i,1],sep="")
  if(file.access(open_file_name)==0){
    proc_main_log.df<-read.csv(open_file_name,encoding="UTF-8",header=F)
    if(output_df_exist_checker==0){
      proc_main_log_bind.df<-data.frame(proc_main_log.df)
      output_df_exist_checker<-1
    }else{
      proc_main_log_bind.df<-rbind(proc_main_log_bind.df,data.frame(proc_main_log.df))
    }
  }
}
names(proc_main_log_bind.df)<-c("commit_hash","author_mail","author_date","committer_mail","committer_date")

###extraction
proc_main_log_bind.df<-proc_main_log_bind.df[,c(-4,-5)]
proc_main_log_bind.df$author_date<-as.Date(as.POSIXlt(as.POSIXct(proc_main_log_bind.df$author_date),"GMT"))
proc_main_log_bind.df$author_mail<-as.character(proc_main_log_bind.df$author_mail)
proc_main_log_bind.df$author_mail<-gsub("(.*)@(.*)@(.*)","\\1@\\2",proc_main_log_bind.df$author_mail)
proc_main_log_bind.df<-unique(proc_main_log_bind.df)
write.csv(proc_main_log_bind.df,paste("git_log_main_bind.csv",sep=""),row.names=F)
