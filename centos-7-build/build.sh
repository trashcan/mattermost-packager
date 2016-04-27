#!/bin/bash -x
set -e

# Build CentOS 7 RPM based on:
# http://docs.mattermost.com/install/prod-rhel-7.html
# by Pat Lathem <plathem@gmail.com>

VERSION="2.1.0"

# Works
cd /root/
apt-get install -q -y ruby ruby-dev build-essential nginx wget rpm
gem install fpm -q

mkdir -p /opt
wget https://releases.mattermost.com/${VERSION}/mattermost-team-${VERSION}-linux-amd64.tar.gz  -O /tmp/mattermost.tar.gz -nv
tar xzf /tmp/mattermost.tar.gz --directory=/opt/

# TODO test
mkdir -p /etc/nginx/default.d/
cp nginx.conf /etc/nginx/default.d/mattermost

# TODO: test
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/chap-Managing_Services_with_systemd.html#tabl-Managing_Services_with_systemd-Introduction-Units-Locations
mkdir -p /usr/lib/systemd/system/
cp mattermost.systemd /usr/lib/systemd/system/mattermost.service

useradd --system mattermost
chown -R mattermost:mattermost /opt/mattermost/

fpm -f -s dir -t rpm -n mattermost-team -v ${VERSION} \
  --url http://www.mattermost.org \
  --description "Mattermost is an open source, self-hosted Slack-alternative." \
  --deb-user mattermost --deb-group mattermost \
  --before-install /root/before-install.sh \
  --after-install /root/after-install.sh \
  -d nginx -d postgresql94-server -d postgresql94-contrib \
  --config-files /opt/mattermost/config/config.json \
  /opt/mattermost /etc/nginx/default.d/mattermost /usr/lib/systemd/system/mattermost.service

