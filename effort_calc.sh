#!/bin/sh
#git clone
homedir="`pwd`"
wget http://git.chromium.org/gitweb/?a=project_index -O chromium_git_repo_tree.txt
mkdir git_repo
cd git_repo
while read line;do
fname=${line%.*}
git clone https://git.chromium.org/git/${fname}.git ${fname}
done<"${homedir}/chromium_git_repo_tree.txt"
cd ${homedir}

#get git main log
mkdir git_log_main
logdir="`pwd`/git_log_main/"

while read line;do
git_dir=${line%.*}
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
git_dir=${line%.*}
cd git_repo/$git_dir
out_fname=${line##*/}
git log --numstat --pretty=format:"[[SOF]]%H[[EOF]]%n%b" >> "${logdir}${out_fname}_change.log"
echo ${out_fname}_change.log >> ${logdir}git_log_change_list.txt
cd $homedir 
done<"chromium_git_repo_tree.txt"

###
python scripts/main_log_to_csv.py
python scripts/change_log_to_csv.py
R --vanilla --slave < scripts/bind_main_logs.r
R --vanilla --slave < scripts/bind_change_logs.r
R --vanilla --slave < scripts/merge_main_change_logs.r
R --vanilla --slave < scripts/calculate_metrics.r
