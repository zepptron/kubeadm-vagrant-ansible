echo "installing ansible.."
apt-add-repository -y ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible
echo "done."