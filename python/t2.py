#!/usr/bin/python
# -*- coding: utf-8 -*-

import os, sys
import re
import socket, fcntl, struct
import random
import urllib, urllib2
import cookielib

hostip = socket.gethostbyname(socket.gethostname())
print  'name'+socket.gethostname()
print hostip
def get_ip2(ifname):  
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  
    return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s', ifname[:15]))[20:24])  


if os.path.isdir('/home/dev/'):
    print os.path.isdir('/home/dev/')

 #   os.mknod('test.txt')


print os.stat('/home/dev')
print get_ip2('eth0')
print "  \n"
print re.compile('\w').findall('sadf')
print random.sample(range(10000,20000),5)
print random.randint(10,11)
print socket.gethostbyname('debian')
print socket.gethostbyname(socket.gethostname())
a = socket.gethostbyname_ex(socket.gethostname())
print isinstance(a,tuple)
print a
print os.path.exists('/home/dev/test.txt')




