##### delete  unnecessary lines from change_log for postprocess

file_list.df<-read.table("git_log_change/git_log_change_list.txt",header=F)
dir.create("git_log_change_light")
for(i in 1:nrow(file_list.df)){
  open_file_name<-paste("git_log_change/",file_list.df[i,1],sep="")
  if(file.access(open_file_name)==0){
    change_log.df<-data.frame(readLines(open_file_name,encoding="UTF-8"))
    use_lines<-grep("(^\\d+\\t\\d+\\t[\\w|\\W]+?$|\\[\\[SOF\\]\\][0-9a-f]{40}\\[\\[EOF\\]\\]$|BUG=(?!none).+$|fix|refactor(ing|ed))",change_log.df[,1],perl=TRUE,ignore.case=T)
    change_log.df<-data.frame(change_log.df[use_lines,])
    write.table(change_log.df,paste("git_log_change_light/light_",file_list.df[i,1],sep=""),row.names=F,col.names=F,quote=F)
  }
}
