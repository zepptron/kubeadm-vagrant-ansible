echo "installing ansible.."
apt-add-repository -y ppa:ansible/ansible
apt update -y
apt install -y ansible
echo "done."