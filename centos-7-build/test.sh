#!/bin/bash
# Install package requirements and install the built RPM. Run with:
# vagrant ssh -c 'sudo su -c /root/test.sh'
# (or just run from inside the VM)

yum install -q -y epel-release
yum install -q -y nginx


#apt-get install -y nginx postgresql postgresql-contrib
#dpkg -i /root/mattermost-platform*.deb
#sleep 3

#tail /opt/mattermost/logs/mattermost.log
#status mattermost
