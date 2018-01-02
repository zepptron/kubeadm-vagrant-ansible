#!/bin/bash

# Ensure ssh keys and the authorized_key file is preset
echo "Check if the root ssh directory is there"
if [ ! -d /root/.ssh/ ]; then
	mkdir /root/.ssh/
fi

echo "Change permissions of the ssh folder"
chmod 600 /root/.ssh

echo "Add the rsa key to the root user"

cp /vagrant/prov/ssh/id_rsa /root/.ssh/
cp /vagrant/prov/ssh/id_rsa.pub /root/.ssh/
cat /vagrant/prov/ssh/id_rsa.pub >> /root/.ssh/authorized_keys

echo "Change permissions of the ssh key files"
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/authorized_keys

echo "Change permissions of the ssh key files in /vagrant/"
chmod 600 /vagrant/prov/ssh/id_rsa
chmod 644 /vagrant/prov/ssh/id_rsa.pub

echo "Check if the ubuntu ssh directory is there"
if [ ! -d /home/ubuntu/.ssh/ ]; then
	mkdir /home/ubuntu/.ssh/
fi

echo "Change permissions of the ssh folder"
chmod 600 /root/.ssh

echo "Add the shared rsa key to the vagrant user"

cp /vagrant/prov/ssh/id_rsa /home/ubuntu/.ssh/
cp /vagrant/prov/ssh/id_rsa.pub /home/ubuntu/.ssh/
cat /vagrant/prov/ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys

echo "Change permissions of the ssh key files"
chmod 600 /home/ubuntu/.ssh/id_rsa
chmod 644 /home/ubuntu/.ssh/id_rsa.pub
chmod 600 /home/ubuntu/.ssh/authorized_keys

echo "Disable IPv6 Support (persistant)"
echo "net.ipv6.conf.all.disable_ipv6 = 1 \
	  net.ipv6.conf.default.disable_ipv6 = 1 \
	  net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/99-my-disable-ipv6.conf
service procps reload