##### binding git change log and extraction

file_list.df<-read.table("git_log_change/git_log_change_list.txt",header=F)
output_df_exist_checker<-0
for(i in 1:nrow(file_list.df)){
  open_file_name<-paste("git_log_change_proc/proc_",file_list.df[i,1],sep="")
  if(file.access(open_file_name)==0){
    proc_change_log.df<-read.csv(open_file_name,encoding="UTF-8",header=F)
    if(output_df_exist_checker==0){
      proc_change_log_bind.df<-proc_change_log.df
      output_df_exist_checker<-1
    }else{
      proc_change_log_bind.df<-rbind(proc_change_log_bind.df,proc_change_log.df)
    }
  }
}
names(proc_change_log_bind.df)<-c("commit_hash","bug_fix","add_lines","del_lines","change_files")
proc_change_log_bind.df<-unique(proc_change_log_bind.df)
write.csv(proc_change_log_bind.df,"git_log_change_bind.csv",row.names=F)
