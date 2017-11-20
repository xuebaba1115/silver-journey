import pandas as pandas
import sys, os
import numpy as np

logpath='/var/log/tomcat8/localhost_access_log.txt'
with open(logpath,'r') as log:

    for line in log:
        print line
        spline=line.split()
        # print spline
        break
    print log.tell()
    log.seek(8000)
    print log.readline()
