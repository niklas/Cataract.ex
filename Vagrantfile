# -*- mode: ruby -*-
# vi: set ft=ruby :

shared_folder = "/home/vagrant/PhoenixApp"

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  
  config.vm.network :private_network, ip: "192.168.101.100"

  config.vm.provision :shell, :inline => PROVISION

  config.vm.synced_folder "./", shared_folder
end

PROVISION = <<EOP
update-locale LC_ALL=en_US.utf8
update-locale LANG=en_US.utf8

mkdir -p #{shared_folder}

if ! hash erl 2>/dev/null; then
  cd /tmp/
  wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
  dpkg -i erlang-solutions_1.0_all.deb
  
  apt-get update
  apt-get install -y esl-erlang
fi

if ! hash elixir 2>/dev/null; then
  apt-get install -y elixir
fi

if ! hash git 2>/dev/null; then
  apt-get install -y git-core
fi

EOP
