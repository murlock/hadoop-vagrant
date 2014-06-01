#!/bin/bash

PKG="hadoop-hdfs-datanode hadoop-yarn-nodemanager hbase-regionserver" # hadoop-mapreduce"
apt-get install -y $PKG

chown -R hdfs:hdfs /hadoop

cp /vagrant/default_bigtop-utils /etc/default/bigtop-utils

for srv in $PKG; do
	service $srv stop
done

# copy configuration, install it as alternative and switch to it
for pkg in hbase hadoop zookeeper; do
    cp -r /vagrant/$pkg-conf /etc/$pkg/myconf 
    update-alternatives --install "/etc/$pkg/conf" "$pkg-conf" "/etc/$pkg/myconf" 1
    update-alternatives --set $pkg-conf "/etc/$pkg/myconf"
done


for srv in $PKG; do
	service $srv start
done

apt-get clean
