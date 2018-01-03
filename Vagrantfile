# -*- mode: ruby -*-
# vi: set ft=ruby :

$proxy = false

Vagrant.configure("2") do |config|
	
	# global stuff
	config.vm.provision "shell", inline: "echo 'ubuntu:ubu' | sudo chpasswd"
	config.vm.provision :shell, path: "prov/prepare.sh"
	config.vm.box = "ubuntu/xenial64"
	config.vm.synced_folder ".", "/vagrant"
	# global proxy settings
	file_name = "ansible/inventories/dev/group_vars/all"
	if $proxy == true
		config.vm.provision :shell, inline: "cp -rf /vagrant/prov/configs/proxy/bashrc /root/.bashrc && source /root/.bashrc"
		text = File.read(file_name)
		new_contents = text.gsub("proxy: false", "proxy: true")
		File.open(file_name, "w") {
			|file| file.puts new_contents 
		}
	else
		text = File.read(file_name)
		new_contents = text.gsub("proxy: true", "proxy: false")
		File.open(file_name, "w") {
			|file| file.puts new_contents 
		}
	end
	config.ssh.insert_key = false
	config.vm.provision "shell", inline: <<-SHELL
      test -e /usr/bin/python || (apt -qqy update && apt install -qqy python-minimal)
  	SHELL

	# masterblaster:
	config.vm.define "kube-boss" do |d|
		d.vm.hostname = "kube-boss.foo.io"
		d.vm.network "private_network", ip: "10.10.0.10"
		d.vm.provision :shell, path: "prov/tools.sh"	# ansible
		d.vm.provision :shell, inline: 'PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/init.yml -c local'
		d.vm.provider "virtualbox" do |v|
			v.memory = 1024
		end
	end

	# workernodes:
	N = 3
	(1..N).each do |machine_id|
		config.vm.define "kube-#{machine_id}" do |machine|
			machine.vm.hostname = "kube-#{machine_id}.foo.io"
			machine.vm.network "private_network", ip: "10.10.0.#{10+machine_id}"
			machine.vm.provider "virtualbox" do |v|
				v.memory = 512
			end
		end
	end

	if Vagrant.has_plugin?("vagrant-vbguest")
		config.vbguest.auto_update = false
		config.vbguest.no_install = true
		config.vbguest.no_remote = true
	end
end