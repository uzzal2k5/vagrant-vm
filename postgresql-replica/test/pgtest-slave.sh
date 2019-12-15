#!/usr/bin/env bash
set -ex
# TO SLAVE
if [ `sudo su - postgres -c "psql -x -c \"\dt\"" | grep Name | awk '{print $3}' ` == "replica_test" ];
then
  echo "Congratualtion, Replication Success !"
  sleep 10
  if [  `sudo su - postgres -c "psql -x -c \"select * from replica_test;\"" | grep "Master" | awk '{print  $6}'` == "Master"  ]; then
     echo "Congratualtion Again. Data Replicated Successfully."
      
  fi
fi
