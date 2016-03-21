#!/bin/bash -x
set -e

# Build Ubuntu 14.04 LTS DEB based on:
# http://docs.mattermost.com/install/prod-ubuntu.html
# by Pat Lathem <plathem@gmail.com>

# Caveats:
# I'm changing the default nginx vhost. Hopefully that is the intent when installing this package.
# Am I doing too much post config in after-install.sh? I just want everything to work out of the box.
# If someone wanted to have a separate nginx or postgresql server, this package still depends on both.
# I haven't figured out how package updates will be handled yet.
# SSL? Maybe just install a commented out nginx config file with directions?
# Should I randomize the DB password? This might cause problems if there is a failed upgrade in the future.

VERSION="2.1.0"

cd /root/
apt-get update
apt-get install -q -y ruby-dev build-essential nginx
gem install fpm -q

mkdir -p /opt
wget https://releases.mattermost.com/${VERSION}/mattermost-team-${VERSION}-linux-amd64.tar.gz  -O /tmp/mattermost.tar.gz -nv
tar xzf /tmp/mattermost.tar.gz --directory=/opt/

mkdir -p /etc/nginx/sites-available
cp nginx.conf /etc/nginx/sites-available/mattermost

mkdir -p /etc/init
cp upstart.conf /etc/init/mattermost.conf

# TODO: seems broken
adduser --gecos '' mattermost
chown -R mattermost:mattermost /opt/mattermost/

fpm -f -s dir -t deb -n mattermost-team -v ${VERSION} \
  --url http://www.mattermost.org \
  --description "Mattermost is an open source, self-hosted Slack-alternative." \
  --deb-user mattermost --deb-group mattermost \
  --before-install /root/before-install.sh \
  --after-install /root/after-install.sh \
  -d nginx -d postgresql -d postgresql-contrib \
  --config-files /opt/mattermost/config/config.json \
  /opt/mattermost /etc/nginx/sites-available/mattermost /etc/init/mattermost.conf
