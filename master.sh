#!/bin/bash

# from http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_cdh5_install.html

PKG=""
# NameNode : hadoop-hdfs-namenode
PKG="$PKG hadoop-hdfs-namenode"
# One host in the cluster : hadoop-mapreduce-historyserver hadoop-yarn-proxyserver
PKG="$PKG hadoop-mapreduce-historyserver hadoop-yarn-proxyserver"
# Resource Manager : hadoop-yarn-resourcemanager
PKG="$PKG hadoop-yarn-resourcemanager"
# Hbase : hbase-master hbase-rest
PKG="$PKG hbase-master hbase-rest"
# Zookeeper server
PKG="$PKG zookeeper-server"

apt-get install -y $PKG
chown -R hdfs:hdfs /hadoop

cp /vagrant/default_bigtop-utils /etc/default/bigtop-utils

# zookeeper init
#zookeeper-server-initialize
service zookeeper-server init
mkdir -p /var/lib/zookeeper
chown -R zookeeper /var/lib/zookeeper/

for srv in $PKG; do
	service $srv stop
done

# copy configuration, install it as alternative and switch to it
for pkg in hbase hadoop zookeeper; do
    cp -r /vagrant/$pkg-conf /etc/$pkg/myconf 
    update-alternatives --install "/etc/$pkg/conf" "$pkg-conf" "/etc/$pkg/myconf" 1
    update-alternatives --set $pkg-conf "/etc/$pkg/myconf"
done

mkdir -p /var/lib/hadoop-hdfs/cache/hdfs/dfs/name
chown -R hdfs:hdfs /hadoop
chown -R hdfs:hdfs /var/lib/hadoop-hdfs/cache/hdfs/dfs/name
sudo -u hdfs hdfs namenode -format

# prepare hbase directory
sudo -u hdfs hadoop fs -mkdir /hbase
sudo -u hdfs hadoop fs -chown hbase /hbase

# restart service
for srv in $PKG; do
    service $srv start
done

apt-get clean
