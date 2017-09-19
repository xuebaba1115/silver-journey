#!/usr/bin/python
# -*- coding: utf-8 -*-
import os,sys,re,time
import socket
import shutil
import tarfile
import ConfigParser
from multiprocessing import Pool

hostlit={'trade_auth':'trade_auth','sms':'sms', 'merchant':'merchant', 'pump':'pump', \
         'gateway01':'trade_gateway', 'action':'action_agent', 'log':'logging', 'risk':'risk',\
         'query':'query_engine', 'trade_hub':'trade_hub', 'strategy':'strategy_agent',\
         'ptrader':'ptrader', 'pushlet':'pushlet', 'offer':'offer_agent', 'settle':'settlement', \
         'vmatch':'virtual_match', 'market_hub':'market_hub','market_auth':'market_auth',\
         'analyze':'market_analyzer','dispatch':'market_dispatcher','mbucket':'market_bucket'} 
hostip = socket.gethostbyname(socket.gethostname())
homepwd = os.environ['HOME']
homepth = os.environ['HOME']+'/cheetah/'


def pathlist():
    with open('testhosts.txt','rb') as hosts:
        a = hosts.read()   
        b = re.findall('%s\s*(\w*)'%(hostip),a)
        c= []
        for i in b:
            try:
                c.append(hostlit[i])
            except KeyError:
                pass
    return set(c)

def copydatabase(i):
    if not os.path.exists(homepth+i+'/mnesia'):    
        dataname = filter(lambda x: re.findall('%s\w*'%(i),x),os.listdir('./mnesia-data')) 
        #'.*(\.*%s*.\w*.\d*.tgz).*'%(i)
        try:
            shutil.copy('./mnesia-data/%s'%(dataname[0]),homepth+i)
            os.system('tar xzf %s -C %s'%(homepth+i+'/'+dataname[0],homepth+i))
            os.remove(homepth+i+'/'+dataname[0])
            print '\033[1;32m %s \033[0m\033[1;32mDatabases mnesis copy ok! \033[0m'%(i)  
        except IndexError as e:
            print '\033[1;35m %s \033[0m\033[1;31m Copay Database mnesis Fail ! --> %s \033[0m'%(i,e) 
            pass
        except IOError as e:
            print '\033[1;35m %s \033[0m\033[1;31m  Fail ! --> %s \033[0m'%(i,e) 
    else:
        print '\033[1;32m %s \033[0m\033[1;32mDatabases mnesis copy ok! \033[0m'%(i)   


def copydeps(i):
    if os.path.exists(homepth+i):
        if os.path.exists(homepth+i+'/deps'):
            rebarcom(i)
        else:
            shutil.copy('deps.tgz',homepth+i)
            os.system('tar xzf %s -C %s'%(homepth+i+'/deps.tgz',homepth+i))
            os.remove(homepth+i+'/deps.tgz')
            rebarcom(i)
    else:
        print  '\033[1;31m NO cheetah path \033[0m'

def rebarcom(i):
    print '\033[1;32m %s \033[0m\033[1;32m deps copy tar ok! \033[0m'%(i)    
    if not os.path.exists(homepth+i+'/ebin'):   
        r191 = os.system('. %s/ErlangVM/R191.hipe/activate'%(homepwd))      
        playdeps = os.system(' cd %s/ &&./rebar get-deps'%(homepth+i))
        if  playdeps==0:
            print '\033[1;32m %s \033[0m\033[1;32m  play rebar get-deps ok! \033[0m'%(i) 
            playcom = os.system('cd %s/ &&./rebar compile'%(homepth+i))
            if playcom==0:
                print '\033[1;32m %s \033[0m\033[1;32m  play rebar compile ok! \033[0m'%(i)  
            else:              
                os.system(' cd %s/deps/emysql && git checkout R18 && cd %s/ &&./rebar compile'%(homepth+i,homepth+i))                           
                print '\033[1;32m %s \033[0m\033[1;32m  play rebar compile err and emsql go to git checkout R18！ \033[0m'%(i)                           
        else:
            print '\033[1;35m %s \033[0m\033[1;31m  ./rebar get-deps Fail \033[0m'%(i) 

def copyconfig(i): 
    cf = ConfigParser.ConfigParser() 
    cf.read("erlangstart.conf")
    if  os.path.exists(homepth+i+'/ebin'): 
        shpath = "%s/ebin/dev_console.sh"%(homepth+i)
        content=cf.get(i,'sh')
        if not os.path.exists("%s/ebin/dev_console.sh"%(homepth+i)):        
            os.mknod(shpath,0744)
            with open(shpath,'w') as sh:
                sh.write(content)
                print '\033[1;32m %s \033[0m\033[1;32m  dev_consol.sh copy ok! \033[0m'%(i)  
        else:
            with open(shpath,'w') as sh:
                sh.write(content) 
                print '\033[1;32m %s \033[0m\033[1;32m  dev_consol.sh copy ok! \033[0m'%(i)    
    else:
        print '\033[1;35m %s \033[0m\033[1;31m  No ebin path, There is ./rebar compile is Fail\033[0m'%(i) 


def loopdatabase(nodename):
    p = Pool(8)
    for i in nodename:       
        p.apply_async(copydatabase,args=(i,))
    p.close()
    p.join()

def loopdeps(nodename):
    p = Pool(8)
    for i in nodename:      
        p.apply_async(copydeps,args=(i,))
    p.close()
    p.join()

def loopconfig(nodename):
    p = Pool(8)
    for i in nodename:       
        p.apply_async(copyconfig,args=(i,))
    p.close()
    p.join()

def main():
    start = time.time()
    nodename = pathlist()
    loopdeps(nodename)
    loopconfig(nodename)
    loopdatabase(nodename)
    end = time.time()
    print('Task  runs %0.2f seconds.' % ( (end - start)))
    
if __name__ == '__main__':
    main()