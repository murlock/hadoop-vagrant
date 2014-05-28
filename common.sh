#!/bin/bash


# Check if Apt-Cacher-Ng is available 
# apt-cacher-ng is not working very well
#echo | nc 10.0.13.1 3142
#if [ $? -eq 0 ]; then
#    echo "Enable APT-CACHER-NG"
#    echo 'Acquire::http { Proxy "http://10.0.13.1:3142"; };' > /etc/apt/apt.conf.d/02proxy
#fi

# Install JAVA
pushd /opt
JAVANAME="$( ls /vagrant/jdk* | sort | tail -n1 )"
tar xf $JAVANAME
NAME="$( ls -d /opt/jdk* | sort | tail -n1 )"
ln -sf $NAME /opt/jdk

for pkg in java javac javaws; do \
    update-alternatives --install "/usr/bin/$pkg" "$pkg" "/opt/jdk/bin/$pkg" 1 ;\
    update-alternatives --set $pkg /opt/jdk/bin/$pkg ;\
done

# go back to current directory
popd

# 
cat <<EOF >/etc/profile.d/java.sh
export JAVA_HOME=/opt/jdk
export PATH=\$PATH:\$JAVA_HOME/bin
EOF


# remove 127.0.1.1 entry in /etc/hosts
sed "/127.0.1.1/d" -i /etc/hosts


# add repo key for Cloudera
curl -s http://archive.cloudera.com/cdh5/ubuntu/lucid/amd64/cdh/archive.key | apt-key add -

# download metapackage for CDH5
wget http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb -O /tmp/cdh5-repository_1.0_all.deb
dpkg -i /tmp/cdh5-repository_1.0_all.deb
apt-get update

# install usefull packages
apt-get -y install vim-nox

for i in /vagrant/utils/*; do
    cp -v $i /root/.`basename $i`
    cp -v $i /home/vagrant/.`basename $i`
done


# prepare /etc/hosts
cat <<EOF >>/etc/hosts

10.0.13.100	master
10.0.13.101	slave1
10.0.13.102	slave2
10.0.13.103	slave3
10.0.13.104	slave4
10.0.13.105	slave5
10.0.13.106	slave6
EOF

# prepare directory for hadoop
mkdir -p /hadoop/hdfs
# FIXME: in post-installation, chown directories
