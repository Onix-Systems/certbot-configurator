# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.33.103"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
  end
  config.vm.provision "shell", inline: <<-SHELL
      set -e
      APT_FILE="/etc/apt/sources.list"
      [ ! -e "${APT_FILE}.orig" ] && cp ${APT_FILE} ${APT_FILE}.orig
      sed -i 's,http://archive,http://ua.archive,g' ${APT_FILE}
      # Set our native time zone in VM
      ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
      # mc repo
      echo "deb http://www.tataranovich.com/debian $(lsb_release -cs) main" > /etc/apt/sources.list.d/mc.list
      apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 0x836CC41976FB442E
      apt-get update
      apt-get install -y \
          apt-transport-https \
          ca-certificates \
          curl \
          software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
      add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      apt-key fingerprint 0EBFCD88
      apt-get update
      apt-get install -y \
          docker-ce \
          htop \
          mc
  SHELL
end
