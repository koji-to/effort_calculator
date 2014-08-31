##### preprocessing downsized change logs and change to .csv
##### !!!Warning!!! This script may take MANY hours. !!!Warning!!! 
##### In my environment, it takes over 3 days. Be careful.

file_list.df<-read.table("git_log_change/git_log_change_list.txt",header=F)
dir.create("git_log_change_proc/")
for(i in 1:nrow(file_list.df)){
  open_file_name<-paste("git_log_change_light/light_",file_list.df[i,1],sep="")
  if(file.access(open_file_name)==0){
    light_change_log.df<-data.frame(readLines(open_file_name,encoding="UTF-8"))
    if(nrow(data.frame(light_change_log.df))!=0){
      commit_data.df<-data.frame(matrix(0,1,5))
      names(commit_data.df)<-c("commi_hash","bug_flag","add_lines","del_lines","changed_files")
      proc_change_log.df<-commit_data.df
      for(j in 1:nrow(light_change_log.df)){
        if(length(grep("\\[\\[SOF\\]\\][0-9a-f]{40}\\[\\[EOF\\]\\]$",light_change_log.df[j,1],perl=T))!=0){
          if(j!=1){
            proc_change_log.df<-rbind(proc_change_log.df,commit_data.df)
          }
          commit_data.df[1]<-gsub("^\\[\\[SOF\\]\\]([0-9a-f]{40})\\[\\[EOF\\]\\]$","\\1",light_change_log.df[j,1])
          commit_data.df[2]<-""
          commit_data.df[3]<-0
          commit_data.df[4]<-0
          commit_data.df[5]<-1
        }else if(length(grep("BUG=|fix",light_change_log.df[j,1],perl=T,ignore.case=T))!=0){
          #remove "pre'fix'" or "test/cctest/test-'fix'ed-dtoa.cc" etc. foolish.
          if(length(grep("^\\d+\\t\\d+\\t[\\w|\\W]+$",light_change_log.df[j,1],perl=TRUE))!=0){
            
          }else{
            commit_data.df[2]<-1
          }
        }else if(length(grep("^\\d+\\t\\d+\\t[\\w|\\W]+$",light_change_log.df[j,1],perl=TRUE))!=0){
          commit_data.df[3]<-as.numeric(gsub("^(\\d+)\\t\\d+\\t[\\w|\\W]+$","\\1",light_change_log.df[j,1],perl=TRUE))+as.numeric(commit_data.df[3])
          commit_data.df[4]<-as.numeric(gsub("^\\d+\\t(\\d+)\\t[\\w|\\W]+$","\\1",light_change_log.df[j,1],perl=TRUE))+as.numeric(commit_data.df[4])
          commit_data.df[5]<-as.numeric(commit_data.df[5])+1
        }
      }
      proc_change_log.df<-rbind(proc_change_log.df,commit_data.df)
      proc_change_log.df<-proc_change_log.df[-1,]
      write.table(proc_change_log.df,paste("git_log_change_proc/proc_",file_list.df[i,1],sep=""),row.names=F,col.names=F,quote=F,append=T,sep=",")
      
    }
  }
gc()
gc()
}
