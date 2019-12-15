#!/usr/bin/env bash
set -ex
echo "This is PostgreSQL Master Slave Replica"
PGMASTER_IP='192.168.10.115'
sudo su - postgres
cd  /var/lib/postgresql/10/
mv main main-backup
mkdir main/
chmod 700 main/
chown -R postgres:postgres /var/lib/postgresql/10/main/
export PGPASSWORD='vagrant'
pg_basebackup -h $PGMASTER_IP -U replica -D /var/lib/postgresql/10/main -v -P
cat <<EOF > main/recovery.conf
standby_mode = 'on'
primary_conninfo = 'host=$PGMASTER_IP port=5432 user=replica password=vagrant application_name=pgslave001'
restore_command = 'cp //var/lib/postgresql/10/main/archive/%f %p'
trigger_file = '/tmp/postgresql.trigger.5432'
EOF
chmod 600 main/recovery.conf
chown -R postgres:postgres /var/lib/postgresql/10/main/
sudo systemctl restart postgresql
# Running Test
apt-get install -y sshpass
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -t vagrant@"$PGMASTER_IP" sudo bash test/pgtest-master.sh
sleep 2
sudo bash /home/vagrant/test/pgtest-slave.sh

