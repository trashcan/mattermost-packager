#!/bin/sh
# This script runs after the DEB package is installed.

echo "Configuring Nginx"
# TODO: fix
ln -sf /etc/nginx/sites-available/mattermost /etc/nginx/sites-enabled/default
systemctl reload nginx

echo "Configuring PostgreSQL"
systemctl restart postgresql
/usr/pgsql-9.4/bin/postgresql94-setup initdb
sudo -u postgres psql -c "create database mattermost;"
sudo -u postgres psql -c "create user mmuser WITH PASSWORD 'mmuser_password';"
sudo -u postgres psql -c "grant all privileges on database mattermost to mmuser;"
systemctl reload postgresql

echo "Configuring Mattermost"
ln -sf /opt/mattermost/logs /var/log/mattermost
ln -sf /opt/mattermost/config/config.json /etc/mattermost.json
sed -i.original 's#"DriverName": "mysql",#"DriverName": "postgres",#' /opt/mattermost/config/config.json
sed -i.original 's#"DataSource": "mmuser:mostest@tcp(dockerhost:3306)/mattermost_test?charset=utf8mb4,utf8",#"DataSource": "postgres://mmuser:mmuser_password@127.0.0.1:5432/mattermost?sslmode=disable\&connect_timeout=10",#' /opt/mattermost/config/config.json
systemctl enable mattermost
systemctl start mattermost

echo "Congratulations! Mattermost has been installed. Please visit http://docs.mattermost.com/ for more information."
