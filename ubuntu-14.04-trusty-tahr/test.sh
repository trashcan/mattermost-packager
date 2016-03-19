#!/bin/bash
# Install package requirements and install the built DEB. Run with:
# vagrant ssh -c 'sudo su -c /root/test.sh'
# (or just run from inside the VM)

apt-get install -y nginx postgresql postgresql-contrib
dpkg -i /root/mattermost-platform*.deb
sleep 3
tail /opt/mattermost/logs/mattermost.log
status mattermost
