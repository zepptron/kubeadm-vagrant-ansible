Basic stuff is working but I still got some TDOs left.

## How to start
Install Vagrant on your machine. Then start your VMs with a simple "vagrant up", afterwards you'll have 4 running VMs not knowing each other very good.
Run the following to enable hostnames, install docker and kubernetes components including flannel:

```
vagrant ssh kube-boss # "ubu" is the password by default, waiting for a fix here...
..
sudo -i
ansible-playbook -i /vagrant/ansible/inventories/vagrant/vagrant.ini /vagrant/ansible/vagrant-install.yml
..
watch kubectl get nodes
```

<img src="https://github.com/zepptron/kubeadm-vagrant-ansible/blob/master/temp/vag.jpg?raw=true" width="800">

## Protips
There is this one user called "zepp" (default-pw: bitch) which is able to interact with kubernetes. You should use this one rather than always playing with root. There are also some sweet hacks in `.bashrc` like `k-nodes`, which will give you some stats about the cluster. Define your own user in the inventories folder.

<img src="https://github.com/zepptron/kubeadm-vagrant-ansible/blob/master/temp/k-node.jpg?raw=true" width="400">

### Working fast
the command `k` is your friend. It's the alias for `kubectl` because you will be angry when you always have to type _k u b e c t l_ ... followed by a namespace :)

So if you want to work in a specific namespace and you are annoyed of always typing `kubectl -n kube-public get pods -o wide` just adjust the _.bashrc_ file to your needs and it will be `k get pods -o wide`! I've already covered the standard namespaces, you just have to type `k-pub` (kube-public), `k-sys` (kube-system) or `k-def` (default) to work in a specific namespace. So when everything is installed and you login as "zepp", try the following:

```
k-sys
k get pods
k-nodes
```

This also works for deploying stuff etc, it's just an alias.

## Todos
- kill proxyfuckups while using kubeadm
- repair userfuckup in vagrantbox: https://bugs.launchpad.net/cloud-images/+bug/1569237 
- add some healthchecks
- be much more generic!
- integrate traefik and a demoservice

## Proxy
By default the proxy settings are turned off. If you need to fight with a proxy, enable and configure it in the Vagrantfile. It's defined at the top:
```
$proxy = false		# true or false
$proxy_url = "http://proxy.com:port"	# enter proxy URL here!
```

## Be aware!
As you might have noticed this is just the beginning. I'm trying to make it as generic as possible but I'm no ansible hero so this might take a while. The goal is to have the ability to run it on any relevant platform (ARM (Raspberry), x64 etc...). You can add your own inventory in `ansible/inventories/xx` and play around. It won't work out of the box because it's still a long way to go from here but you can fix it easily by changing some static stuff like the ethernet device or the ssh keys to your needs :)