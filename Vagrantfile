# -*- mode: ruby -*-
# vi: set ft=ruby :

$proxy = false	# true or false
$proxy_url = "http://proxy.fhm.de:8080"	# enter proxy URL here
N = 3 	# define number of nodes

Vagrant.configure("2") do |config|
	
	# global stuff
	config.vm.provision :shell, path: "prov/prepare.sh"
	config.vm.box = "ubuntu/xenial64"
	if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
		config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"], type: "rsync", rsync__exclude: ".git/"
	else
		config.vm.synced_folder ".", "/vagrant"
	end

	# proxy settings...
	global = "ansible/inventories/vagrant/group_vars/all"
	bashrc = "prov/configs/bashrc"
	$proxy_exp = "export {http,https,ftp}_proxy='#{$proxy_url}'"
	global_proxy_off = "proxy: false\nproxy_url: '#{$proxy_url}'"
	global_proxy_on = "proxy: true\nproxy_url: '#{$proxy_url}'"
	if $proxy == true
		readg = File.read(global)
		glob_search = readg.gsub(global_proxy_off, global_proxy_on)
		File.open(global, "w") {
			|file| file.puts glob_search 
		}
		readb = File.read(bashrc)
		bash_search = readb.gsub(/(#|)\sexport.*/, " #{$proxy_exp}")
		File.open(bashrc, "w") {
			|file| file.puts bash_search
		}
	else
		readg = File.read(global)
		glob_search = readg.gsub(global_proxy_on, global_proxy_off)
		File.open(global, "w") {
			|file| file.puts glob_search 
		}
		readb = File.read(bashrc)
		bash_search = readb.gsub(/(#|)\sexport.*/, "# #{$proxy_exp}")
		File.open(bashrc, "w") {
			|file| file.puts bash_search
		}
	end
	config.vm.provision :shell, inline: "cp -rf /vagrant/prov/configs/bashrc /root/.bashrc && source /root/.bashrc"
	config.ssh.insert_key = false
	config.vm.provision "shell", inline: <<-SHELL
      test -e /usr/bin/python || (apt -qqy update && apt install -qqy python-minimal)
  	SHELL

	# masterblaster:
	config.vm.define "kube-boss" do |d|
		d.vm.hostname = "kube-boss.foo.io"
		d.vm.network(:private_network, { ip: "172.16.0.10" })
		d.vm.provision :shell, path: "prov/tools.sh"	# ansible
		d.vm.provision :shell, inline: 'PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/init.yml -c local'
		d.vm.provider "virtualbox" do |v|
			v.memory = 1024
			v.customize ["modifyvm", :id, "--uartmode1", "disconnected"] # see: https://bugs.launchpad.net/cloud-images/+bug/1627844
		end
	end

	# workernodes:
	(1..N).each do |machine_id|
		config.vm.define "kube-#{machine_id}" do |machine|
			machine.vm.hostname = "kube-#{machine_id}.foo.io"
			machine.vm.network(:private_network, { ip: "172.16.0.#{10+machine_id}" })
			machine.vm.provider "virtualbox" do |v|
				v.memory = 512
			  v.customize ["modifyvm", :id, "--uartmode1", "disconnected"] # see: https://bugs.launchpad.net/cloud-images/+bug/1627844
		end
			end
		end
	end

	if Vagrant.has_plugin?("vagrant-vbguest")
		config.vbguest.auto_update = false
		config.vbguest.no_install = true
		config.vbguest.no_remote = true
	end
end
