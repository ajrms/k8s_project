# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  ### Master Node ####

  config.vm.define "master" do |master|
    master.vm.box = "generic/ubuntu1804"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "master"
      vb.cpus = 2
      vb.memory = 3072
    end
    master.vm.host_name = "master"
    # master.vm.network "public_network", bridge: "eth0", ip: "192.168.50.100" , netmask:"255.255.0.0"
    master.vm.network "public_network", bridge: "eth0", ip: "192.168.0.100"
    master.vm.network "forwarded_port", guest: 22, host: 10030, auto_correct: true, id: "ssh"
    master.vm.synced_folder ".", "/vagrant", disabled: true
    master.vm.provision "shell", path: "k8s_install.sh"
    master.vm.provision "shell", path: "master_node.sh"
    master.vm.provision "shell", path: "metallb.sh"
    master.vm.provision "shell", path: "monitoring.sh"
  end

  ### Worker node ###
  (1..2).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "generic/ubuntu1804"
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "worker#{i}"
        vb.cpus = 2
        vb.memory = 3072
      end
      worker.vm.host_name = "worker#{i}"
      # worker.vm.network "public_network", bridge: "eth0", ip: "192.168.50.1#{i}0", netmask:"255.255.0.0"
      worker.vm.network "public_network", bridge: "eth0", ip: "192.168.0.1#{i}0"
      worker.vm.network "forwarded_port", guest: 22, host: "1003#{i}", auto_correct: true, id: "ssh"
      worker.vm.synced_folder ".", "/vagrant", disabled: true
      worker.vm.provision "shell", path: "k8s_install.sh"
      worker.vm.provision "shell", path: "worker_node.sh"
      worker.vm.provision "shell", inline: <<-SHELL
        # echo Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.50.1"#{i}"0" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
        echo Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.0.1"#{i}"0" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
        systemctl daemon-reload
        systemctl restart kubelet
      SHELL
    end

  end

end