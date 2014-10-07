# -*- coding: utf-8 -*-
"""
Created on Sun Oct 05 04:36:14 2014

@author: koji-to
"""
import os
import os.path
import sys
import time
start = time.time()
from pandas import Series, DataFrame
import pandas as pd
from types import *
import re
os.chdir(sys.path[0])
os.chdir('../')
os.mkdir("git_log_change_proc")

file_list=open('git_log_change/git_log_change_list.txt')
log_list=file_list.readlines()
file_list.close()
regex_hash=re.compile('\[\[SOF\]\]([0-9a-f]{40})\[\[EOF\]\]$')
regex_ch_log=re.compile('^(\d+)\t(\d+)\t([\w|\W]+)$')
regex_bugfix=re.compile('BUG=(?!(none|None|NONE)).+$|fix')
regex_refactoring=re.compile('refactor(ing|ed)')
#should use glob.glob
for log_file in log_list:
    if(os.path.exists('git_log_change/'+log_file[:-1]) and os.path.getsize('git_log_change/'+log_file[:-1])!=0):
        input_file=open('git_log_change/'+log_file[:-1],'r')
        log=input_file.readline()
        
        f_bugfix=0
        f_refact=0
        while log:
            match_hash=regex_hash.match(log)
            if match_hash:
                hash_value=match_hash.group(1)
            match_bugfix=regex_bugfix.match(log)
            if match_bugfix:
                f_bugfix=1
            match_refactoring=regex_refactoring.match(log)
            if match_refactoring:
                f_refact=1
            match_ch_log=regex_ch_log.match(log)
            if match_ch_log:
                add_lines=int(match_ch_log.group(1))
                del_lines=int(match_ch_log.group(2))
                file_name=match_ch_log.group(3)
                if 'Dic' not in locals():
                    Dic={hash_value:{file_name:{'add_lines':add_lines,'del_lines':del_lines,'f_bugfix':f_bugfix,'f_refact':f_refact}}}
                elif (not Dic.has_key(hash_value)):
                    Dic[hash_value]={file_name:{'add_lines':add_lines,'del_lines':del_lines,'f_bugfix':f_bugfix,'f_refact':f_refact}}
                else:
                    Dic[hash_value][file_name]={'add_lines':add_lines,'del_lines':del_lines,'f_bugfix':f_bugfix,'f_refact':f_refact}
                f_bugfix=0
                f_refact=0
            log=input_file.readline()
        input_file.close()    
	if 'Dic' in locals():
	        output_file=open(('git_log_change_proc/proc_'+log_file[:-1]),'w')
       		for k in range(len(Dic)):
	            each_hash_df=pd.DataFrame.from_dict(Dic[Dic.keys()[k]])
        	    out_str_fname=len(each_hash_df.columns)
	            out_str_addlines=each_hash_df.sum(axis=1)['add_lines']
	            out_str_dellines=each_hash_df.sum(axis=1)['del_lines']
        	    out_str_bugfix=each_hash_df.sum(axis=1)['f_bugfix']
	            out_str_refact=each_hash_df.sum(axis=1)['f_refact']
        	    out_str_hash=Dic.keys()[k]
	            output_file.write(out_str_hash+','+str(out_str_fname)+','+str(out_str_addlines)+','+str(out_str_dellines)+','+str(out_str_bugfix)+','+str(out_str_refact)+'\n')
	        output_file.close()
	        del Dic
elapsed_time = time.time() - start
print("elapsed_time_{0}".format(elapsed_time))
