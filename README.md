hadoop-vagrant
==============

Deploy easily an Hadoop Cluster with HBase, HBase REST / Zookeeper

- Requires Vagrant ( tested with 1.6 )
- Put a JDK tarball in same directory ( for example, jdk-7u25-linux-x64.tar.gz ), it will be installed in /opt and a symlink will be added as /opt/jdk

```
$ vagrant up
```

 - Based on Cloudera 5
Check http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_cdh5_install.html

 - Use lxcbr0 bridge with 10.0.13.0/24 network



TODO
====
 - Deploy more zookeeper server / namenode backup / hbase server backup
 - Configure an APT proxy to avoid downloading same stuff several times

reminders
=========
 - Namenode UI : http://10.0.13.100:50070
 - HBase Master UI : http://10.0.13.100:60010
 - HBase Region UI : http://10.0.13.10x:60030
