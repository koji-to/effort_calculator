# -*- coding: utf-8 -*-
"""
Created on Sun Oct 05 02:19:03 2014

@author: koji-to
"""
####### preprocessing main logs and change to .csv
import os
import os.path
import time
start = time.time()
from pandas import Series, DataFrame
import pandas as pd
from types import *
import re
os.chdir('E:/python_test')
os.mkdir("git_log_main_proc")

file_list=open('git_log_main/git_log_main_list.txt')
log_list=file_list.readlines()
file_list.close()
#log_list=pd.read_fwf(file_list,header=None)
regex_no_lf=re.compile("\[\[EOF\]\]\[\[SOF\]\]")
regex_hash_start=re.compile("\[\[SOF\]\]")
regex_hash_end=re.compile("\[\[EOF\]\]")
regex_proh_char=re.compile(',|/|"')
regex_del_semic=re.compile('(?<!\d{2}:\d{2}):(?!\d{2})')
regex_sep=re.compile('<chromium>')
for log_file in log_list:
    if(os.path.exists('git_log_main/'+log_file[:-1]) and os.path.getsize('git_log_main/'+log_file[:-1])!=0):
        input_file=open(('git_log_main/'+log_file[:-1]),'r')
        proc_line=input_file.read()
        input_file.close()
        
        proc_line=regex_no_lf.sub('\n',proc_line)
        proc_line=regex_hash_start.sub('',proc_line)
        proc_line=regex_hash_end.sub('',proc_line)
        proc_line=regex_proh_char.sub('',proc_line)
        proc_line=regex_del_semic.sub('',proc_line)
        proc_line=regex_sep.sub(',',proc_line)
        
        output_file=open(('git_log_main_proc/proc_'+log_file[:-1]),'w')
        output_file.write(proc_line)
        output_file.close()

