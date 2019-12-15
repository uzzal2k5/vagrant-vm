#!/usr/bin/env bash
set -ex
# TO MASTER

# TEST REPLICA CONFIGURATION
sudo su - postgres -c "psql -c \"select application_name, state, sync_priority, sync_state from pg_stat_replication;\""
sudo su - postgres -c "psql -x -c \"select * from pg_stat_replication;\""

# TEST REPLICA BY CREATING DATA
sudo su - postgres -c "psql -x -c \"CREATE TABLE replica_test (testbed varchar(100));\""
sudo su - postgres -c "psql -x -c \"INSERT INTO replica_test VALUES ('testbed.example.com');\""
sudo su - postgres -c "psql -x -c \"INSERT INTO replica_test VALUES ('This is from Master');\""
sudo su - postgres -c "psql -x -c \"INSERT INTO replica_test VALUES ('pg replication by uzzal, DevOps Engineer');\""

sudo su - postgres -c "psql -x -c \"select * from replica_test;\""

