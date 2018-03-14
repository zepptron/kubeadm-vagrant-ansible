This combination of Vagrant, Ansible and Kubeadm will give you a running Kubernetes Cluster within a few seconds. 
While I'm still working on HA features (see branches), ETCD is already clustered and equipped with TLS!

## How to start
Install Vagrant on your machine. Then start your VMs with a simple "vagrant up", afterwards you'll have 4 running VMs not knowing each other very good.

Run the following to enable hostnames, install docker and kubernetes components including flannel.

```
vagrant ssh kube-boss
..
sudo -i
cd /vagrant/ansible
ansible-playbook -i inventories/vagrant/vagrant.ini vagrant-install.yml
```

### deploy Traefik and a Testapplication

You can use Calico as your networking solution. It's available in `/vagrant/ansible/deployments/sys/calico.yml`. Deploy with `kubectl create -f calico.yml`. Afterwards you can deploy whatever you want but you may want to use traefik as your reverse proxy to get access from the outside world. `k create -f traefik.yml` will solve that. It's all in the same folder. 

Check your local `/etc/hosts` file and add these lines to access the frontends running inside the cluster:

```
172.16.0.11     traefik.example.com
172.16.0.11		test.example.com
```

Now open http://traefik.example.com in your webbrowser and see what you have done.

Deploying your first app is easy too:

`k create -f /vagrant/ansible/deployments/webtest/webtest.yml`

Open and Reload test.example.com a few times to see the servicemodel in action.

### use helm

package your applications with helm to deploy and update/rollback them easily. 

```
cd /vagrant/ansible/deployments/helm
helm install --name xxx .
```

There is also a policy deployed which rejects any connections from sidecars to frontends. 

<img src="https://github.com/zepptron/kubeadm-vagrant-ansible/blob/master/temp/vag.jpg?raw=true" width="800">

## Protips
There is this one user called "zepp" (default-pw: wurst) which is able to interact with kubernetes. You should use this one rather than always playing with root. There are also some sweet hacks in `.bashrc` like `k-nodes`, which will give you some stats about the cluster. Define your own user in the inventories folder.

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
- add helm
- integrate HA-features (check the branches)

## Proxy - DEPRECATED
By default the proxy settings are turned off. If you need to fight with a proxy, enable and configure it in the Vagrantfile. It's defined at the top:
```
$proxy = false		# true or false
$proxy_url = "http://proxy.com:port"	# enter proxy URL here!
```

Proxysupport won't be tested anymore. Sorry.
