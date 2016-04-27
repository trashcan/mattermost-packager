yum install -q -y epel-release
yum install -q -y nginx

# TODO: rhel-6, is this correct??
yum install -q -y http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
yum install -q -y postgresql94-server postgresql94-contrib

rpm -Uvh /root/mattermost-team*.rpm
