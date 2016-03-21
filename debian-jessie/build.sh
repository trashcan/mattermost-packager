#!/bin/bash -x

# Build Debian Jessie DEB based on:
# http://docs.mattermost.com/install/prod-debian.html
# by Pat Lathem <plathem@gmail.com>

set -e
VERSION="2.1.0"

# Works
cd /root/
apt-get update
apt-get install -q -y ruby ruby-dev build-essential nginx wget
gem install fpm -q

# Works
mkdir -p /opt
wget https://releases.mattermost.com/${VERSION}/mattermost-team-${VERSION}-linux-amd64.tar.gz  -O /tmp/mattermost.tar.gz -nv
tar xzf /tmp/mattermost.tar.gz --directory=/opt/

# TODO test
mkdir -p /etc/nginx/sites-available
cp nginx.conf /etc/nginx/sites-available/mattermost

# TODO: test
mkdir -p /lib/systemd/system/
cp mattermost.systemd /lib/systemd/system/mattermost.service

# TODO: seems broken
useradd mattermost
chown -R mattermost:mattermost /opt/mattermost/

# TODO
fpm -f -s dir -t deb -n mattermost-team -v ${VERSION} \
  --url http://www.mattermost.org \
  --description "Mattermost is an open source, self-hosted Slack-alternative." \
  --deb-user mattermost --deb-group mattermost \
  --before-install /root/before-install.sh \
  --after-install /root/after-install.sh \
  -d nginx -d postgresql -d postgresql-contrib \
  --config-files /opt/mattermost/config/config.json \
  /opt/mattermost /etc/nginx/sites-available/mattermost /lib/systemd/system/mattermost.service
