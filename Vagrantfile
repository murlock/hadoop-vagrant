# -*- mode: ruby -*-
# vi: set ft=ruby :


"""
    Configure a small cluster for Hadoop :
    one namenode
    two slaves
"""

Vagrant.configure("2") do |config|
    config.vm.provision :shell, :inline => "ifconfig"
    config.vm.provision :shell, :inline => "hostname"
    config.vm.provision :shell, :path => "common.sh"

    # default box used
    config.vm.box = "hashicorp/precise64" #apache"

    config.vm.define "master", primary: true do |namenode|
        namenode.vm.hostname = "master"
        namenode.vm.network "public_network", ip: "10.0.13.100", :bridge => "lxcbr0"
        config.vm.provision :shell, :path => "master.sh"
    end


    # not work : for i in 1..2 !! ( check http://docs.vagrantup.com/v2/vagrantfile/tips.html )
    (1..4).each do |i|
        config.vm.define "slave#{i}" do |slave|
            #db.vm.box = "hashicorp/precise64" #mysql"
            slave.vm.hostname = "slave#{i}"
            slave.vm.network "public_network", ip: "10.0.13.10#{i}", :bridge => "lxcbr0"
            slave.vm.provision :shell, :path => "slave.sh"
        end
    end
end

