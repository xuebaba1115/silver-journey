#!/usr/bin/python
# -*- coding: utf-8 -*-
import multiprocessing as process
import os
import random
import re
import subprocess
import sys
import time
import webbrowser
import socket
import numpy as np
import urllib3
import pandas as pd
a = np.arange(20).reshape(4, 5)
print "a:"
print a
print "the 2nd and 4th column of a:"
print a[:,[1]]
print a[:, 2][a[:, 0] > 5]




class Chain(object):
    def __init__(self,path='GET '):
        self._path=path

    def __getattr__(self,path):
        print self._path
        return Chain('%s/%s' % (self._path,path))

    def __call__(self,path):
        print self._path
        print path
        return Chain('%s/%s' % (self._path,path))

    # def __str__(self):
    #     return self._path

    #__repr__=__str__


print(Chain(path='POST ').user('michael').bb.repos('123').a.c.s)
print Chain('abc')


dates = pd.date_range('20150101', periods=5)
df = pd.DataFrame(np.random.randn(5,4),index=dates,columns=list(
'ABCD'))
print df.describe()
print df 