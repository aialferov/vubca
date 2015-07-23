# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.network "forwarded_port", guest: 22, host: 2022
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.synced_folder ENV['FLASH_ROOT'], "/media/flash"

  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 8
  end

end
