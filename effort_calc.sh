#!/bin/sh
#git clone
#should be tested "git clone --recursive"
homedir="`pwd`"
wget http://git.chromium.org/gitweb/?a=project_index -O chromium_git_repo_tree.txt
mkdir git_repo
cd git_repo
while read line;do
fname=${line}
git clone https://git.chromium.org/git/${fname} ${fname}
done<"${homedir}/chromium_git_repo_tree.txt"
cd ${homedir}

#get git main log
mkdir git_log_main
logdir="`pwd`/git_log_main/"

while read line;do
git_dir=${line}
cd git_repo/$git_dir
out_fname=${line##*/}
git log --date=iso --pretty=format:"[[SOF]]%H<chromium>%ae<chromium>%ad<chromium>%ce<chromium>%cd[[EOF]]" >> "${logdir}${out_fname}_main.log"
echo ${out_fname}_main.log >> ${logdir}git_log_main_list.txt
cd $homedir 
done<"chromium_git_repo_tree.txt"

#get git change log
mkdir git_log_change
logdir="`pwd`/git_log_change/"

while read line;do
git_dir=${line}
cd git_repo/$git_dir
out_fname=${line##*/}
git log --numstat --pretty=format:"[[SOF]]%H[[EOF]]%n%b" >> "${logdir}${out_fname}_change.log"
echo ${out_fname}_change.log >> ${logdir}git_log_change_list.txt
cd $homedir 
done<"chromium_git_repo_tree.txt"

###
python script/main_log_to_csv.py
python script/change_log_to_csv.py
R --vanilla --slave < script/bind_main_logs.r
R --vanilla --slave < script/bind_change_logs.r
R --vanilla --slave < script/merge_main_change_logs.r
# arguments are <release_cycle(days)> <threshold of commits> <newest release date(yyyy-mm-dd)> <the number of going back release>
R --vanilla --slave --args 42 2 2014-06-20 24 < script/calculate_metrics.r
