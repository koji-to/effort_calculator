####### preprocessing main logs and change to .csv
file_list.df<-read.table("git_log_main/git_log_main_list.txt",header=F)
dir.create("git_log_main_proc")

for(i in 1:nrow(file_list.df)){
  open_file_name<-paste("git_log_main/",file_list.df[i,1],sep="")
  if(file.access(open_file_name)==0){
    proc_main_log.df<-data.frame(readLines(open_file_name,encoding="UTF-8"))
    if(nrow(data.frame(proc_main_log.df))!=0){#変更して未チェックなので後で確認
      proc_main_log.df[,1]<-gsub("\\[\\[EOF\\]\\]\\[\\[SOF\\]\\]","\n",proc_main_log.df[,1])
      proc_main_log.df[,1]<-gsub("\\[\\[SOF\\]\\]","",proc_main_log.df[,1])
      proc_main_log.df[,1]<-gsub("\\[\\[EOF\\]\\]","",proc_main_log.df[,1])
      proc_main_log.df[,1]<-gsub(",","",proc_main_log.df[,1])
      proc_main_log.df[,1]<-gsub("/","",proc_main_log.df[,1])
      proc_main_log.df[,1]<-gsub("<chromium>",",",proc_main_log.df[,1])
      write.table(proc_main_log.df,paste("git_log_main_proc/proc_",file_list.df[i,1],sep=""),row.names=F,col.names=F,quote=F,sep=",")
    }
  }
}
