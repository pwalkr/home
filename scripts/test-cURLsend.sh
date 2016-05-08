#!/bin/bash

url="http://192.168.0.1:10000/cgi-bin/cfgfetch.cgi"

uname='admin'
upass='123456'

data="enable=/GAUCfg/sshserver/enable/text()"
data="${data}&advanced=/GAUCfg/sshserver/advanced/text()"
data="${data}&maxstartups=/GAUCfg/sshserver/maxstartups/text()"

eval "curl -u ${uname}:${upass} -X POST --data '$data' $url"
