#!/usr/bin/env bash
POSTGRESQL_VERSION=10
echo "This is PostGreSQL Master Node"

sudo sed -i "s/#listen_address.*/listen_addresses ='192.168.10.115'/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf

sudo mkdir -p /var/lib/postgresql/$POSTGRESQL_VERSION/main/archive/
sudo chmod 700 /var/lib/postgresql/$POSTGRESQL_VERSION/main/archive/
sudo chown -R postgres:postgres /var/lib/postgresql/$POSTGRESQL_VERSION/main/archive/
sudo systemctl restart postgresql
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
