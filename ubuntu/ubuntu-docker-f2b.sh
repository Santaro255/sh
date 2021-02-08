#!/bin/bash
# Update Ubuntu
echo -e "\033[0;32m \nUpdating Ubuntu \033[0m"
apt-get update && apt-get upgrade -y

# Installing packages
echo -e "\033[0;32m \nInstalling packages \033[0m"
apt-get install vim mc -y

# Installing Fail2Ban
echo -e "\033[0;32m \nInstalling Fail2Ban \033[0m"
apt-get install fail2ban -y

# Create fail2ban.local
echo -e "\033[0;32m \nCreate fail2ban.local \033[0m"
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

# Create jail.local
echo -e "\033[0;32m \nCreate jail.local \033[0m"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Create sshd jail
echo -e "\033[0;32m \nCreate sshd jail \033[0m"
cat > /etc/fail2ban/jail.d/sshd.conf <<EOL
[sshd]
enabled = true
port = ssh
action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 2
bantime = 86400
EOL

# Enable and start Fail2Ban
echo -e "\033[0;32m \nEnable and start Fail2Ban \033[0m"
systemctl enable fail2ban && systemctl start fail2ban

# Adding docker repo
echo -e "\033[0;32m \nAdding docker repo \033[0m"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Installing docker
echo -e "\033[0;32m \nInstalling docker \033[0m"
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io -y

# Enable and start docker
echo -e "\033[0;32m \nEnable and start docker \033[0m"
systemctl enable docker && systemctl start docker

# Download docker compose
echo -e "\033[0;32m \nDownload docker compose \033[0m"
wget "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)"

# Move docker compose file
echo -e "\033[0;32m \nMove docker compose file \033[0m"
mv ./docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose

# Exec docker compose file
echo -e "\033[0;32m \nExec docker compose file \033[0m"
chmod +x /usr/local/bin/docker-compose
