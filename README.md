Ok so this thing here is a WIP and you shouldn't even use it for a demo right now. 

Always check these files for proxysettings before running it:
```
Vagrantfile 
ansible/inventories/dev/group_vars/all
```

Start your VMs with a simple "vagrant up", afterwards you'll have 4 running VMs.
Now run the following:

```
vagrant ssh kube-boss # "ubu" is the password by default
..
sudo -i
ansible-playbook -i /vagrant/ansible/inventories/dev/dev.ini /vagrant/ansible/install.yml
```

This will install docker and the kubernetes components (kubectl on master, kubelet and kubeadm everywhere).

todo:
- kill proxyfuckups
- repair userfuckup in vagrant: https://bugs.launchpad.net/cloud-images/+bug/1569237 
- kubeadm init via ansible
- add containernetwork

As you might see, this is just the beginning. I'm trying to make it as generic as possible but I'm no ansible hero so this might take a while. The goal is to run it on every relevant platform (ARM, x64 etc...)