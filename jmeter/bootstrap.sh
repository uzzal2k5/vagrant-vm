#!/usr/bin/env bash
set -ex
JMETER_BASE_DIR="/home/vagrant/jmeter"
JMETER_VERSION="5.2.1"
JMETER_DIR="$JMETER_BASE_DIR/apache-jmeter-$JMETER_VERSION"
JMETER_APP="apache-jmeter-$JMETER_VERSION.zip"
JMETER_CHECKSUM="apache-jmeter-$JMETER_VERSION.zip.sha512"
JMETER="$JMETER_DIR/bin"
JDBC_DRIVER_VERSON="42.2.9"
JMETER_PLUGIN_VERSION="1.3"
JMETER_PLUGINS_MANAGER=$JMETER_DIR/lib/ext/jmeter-plugins-manager-$JMETER_PLUGIN_VERSION.jar

# Install Apache2 Web Server
sudo apt update
sudo apt install -y apache2
sudo ufw allow 'Apache'
sudo systemctl status apache2
sudo rm -rf /var/www/html/*
# Install Java 8
sudo apt update
sudo apt install -y openjdk-8-jdk openjdk-8-jre
sudo cat >> /etc/environment <<EOL
JAVA_HOME= /usr/lib/jvm/java-8-openjdk-amd64
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
EOL
sudo cat >> ~/.bashrc  <<EOL
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export PATH=$PATH:$JAVA_HOME/bin
EOL
java -version
# Install zip/Unzip
sudo apt-get install -y zip unzip
# Download JMeter
# https://jmeter.apache.org/download_jmeter.cgi
if [[ ! -d "$JMETER_DIR" ]];
then
  if [[ ! -f "$JMETER_APP" ]];
  then
    wget https://www-us.apache.org/dist//jmeter/binaries/apache-jmeter-$JMETER_VERSION.zip
  fi
  if [[ ! -f "$JMETER_CHECKSUM" ]];
  then
    wget https://www.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.zip.sha512
  fi
  sha512sum -c apache-jmeter-$JMETER_VERSION.zip.sha512
  if [[ ! -d "$JMETER_BASE_DIR" ]];
  then
    sudo mkdir -p $JMETER_BASE_DIR
    sudo mkdir -p $JMETER_BASE_DIR/test/jmx
    sudo chmod 777 -R $JMETER_BASE_DIR/
    sudo chown $(id -u vagrant):$(id -g vagrant) $JMETER_BASE_DIR
  fi
  unzip apache-jmeter-$JMETER_VERSION.zip -d $JMETER_BASE_DIR/
fi
# Download Require Packages and Plugins
if [[ ! -f "$JMETER_DIR/lib/postgresql-$JDBC_DRIVER_VERSON.jar" ]];
then
  #  https://jdbc.postgresql.org/download.html
  curl -o "$JMETER_DIR/"lib/postgresql-$JDBC_DRIVER_VERSON.jar  https://jdbc.postgresql.org/download/postgresql-$JDBC_DRIVER_VERSON.jar
fi

if [[ ! -f "$JMETER_PLUGINS_MANAGER" ]];
then
  # https://jmeter-plugins.org/install/Install/
  curl -o "$JMETER_PLUGINS_MANAGER" http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/$JMETER_PLUGIN_VERSION/jmeter-plugins-manager-$JMETER_PLUGIN_VERSION.jar
fi
