#!/usr/bin/env bash
POSTGRESQL_VERSION=10
echo "-- updating package lists"
  apt-get update
  # gotta put this before the upgrade, b/c it reboots and then all commands are lost
  echo "-- installing postgres"
  apt-get -y install postgresql
  # fix permissions
  echo "-- fixing postgres pg_hba.conf file"
  # replace the ipv4 host line with the above line
  sudo cat >> /etc/postgresql/10/main/pg_hba.conf <<EOF
  # Accept all IPv4 connections - FOR DEVELOPMENT ONLY!!!
  host    all         all         0.0.0.0/0             md5
EOF
 sudo cat >> /etc/postgresql/$POSTGRESQL_VERSION/main/pg_hba.conf <<EOF
# Localhost
host    replication     replica          127.0.0.1/32            md5
# PostgreSQL Master IP address
host    replication         replica         192.168.10.0/24             md5
# PostgreSQL SLave IP address
host    replication         postgres         192.168.10.0/24             md5
EOF
  echo "-- creating postgres vagrant role with password vagrant"
  # Create Role and login
  sudo su postgres -c "psql -c \"CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant'\" "
  sudo su postgres -c "psql -c \"CREATE USER replica REPLICATION LOGIN ENCRYPTED PASSWORD 'vagrant'\" "
  echo "--  creating test_db database"
  # Create WTM database
  sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O vagrant test_db"
  sudo su postgres -c "psql -d test_db -c \"CREATE TABLE customer(name VARCHAR (50) NOT NULL,age int  NOT NULL,email VARCHAR (355)  NOT NULL,created_on TIMESTAMP NOT NULL,last_login TIMESTAMP);\""
  sudo su postgres -c "psql -d test_db -c \"insert into customer values ('Md Shafiqul Islam','32','uzzal2k5@gmail.com','now','now');\""
  echo "-- upgrading packages to latest"
  #apt-get upgrade -y
  sudo apt-get install -y ufw
  sudo ufw allow ssh
  sudo ufw allow postgresql
  sudo ufw enable
  sudo ufw status
# Configuration Replication
sudo cp /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf.original

echo " --- CONFIGUREING postgresql.conf ---"
sudo sed -i "s/#wal_level.*/wal_level = hot_standby/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#synchronous_commit.*/synchronous_commit = local/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#archive_mode.*/archive_mode = on/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#max_wal_senders.*/max_wal_senders = 2/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#wal_keep_segments.*/wal_keep_segments = 10/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo sed -i "s/#synchronous_standby_names.*/synchronous_standby_names = 'pgslave001'/" /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
sudo su
echo "archive_command = 'cp %p /var/lib/postgresql/$POSTGRESQL_VERSION/main/archive/%f'">> /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
