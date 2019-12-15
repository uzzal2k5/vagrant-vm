#!/usr/bin/env bash
set -ex
JMETER_VERSION="5.2.1"
JMETER_BASE_DIR="/home/vagrant/jmeter"
JMETER_DIR="$JMETER_BASE_DIR/apache-jmeter-$JMETER_VERSION"
JMETER="$JMETER_DIR/bin"

if [[ ! -d "$JMETER_DIR" ]];
then
  echo "JMeter $JMETER_VERSION Not Found !"
else
# Run JMeter
today=`date +%Y-%m-%d`
REPORTS_DIR="/var/www/html"
if [ "$(ls -A $REPORTS_DIR)" ];
then
  rm -rf $REPORTS_DIR/*
  echo "Reports Folder Are Not Empty ! Deleting Reports Directory !!!"
fi
#sh "$JMETER"/jmeter.sh -t test/jmx/Postgresql.jmx
sh "$JMETER"/jmeter.sh -n -t test/jmx/Postgresql.jmx -j test/logs/postgresql-test.log -l test/logs/postgresql-test.jtl -e -o $REPORTS_DIR > /dev/null 2>&1
fi
