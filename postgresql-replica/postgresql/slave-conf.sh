#!/usr/bin/env bash
echo "This is PostgreSQL Slave Node"
POSTGRESQL_VERSION=10
sudo sed -i "s/#listen_address.*/listen_addresses = '192.168.10.116'/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#hot_standby = on/hot_standby = on/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo systemctl restart postgresql


