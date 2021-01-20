#!/bin/bash
# Update CentOS 
echo -e "\nUpdating CentOS"
dnf upgrade -y

# Installing packages
echo -e "\nInstalling packages"
dnf install epel-release vim mc wget dnf-plugins-core -y

# Installing Fail2Ban
echo -e "\nInstalling Fail2Ban"
dnf install fail2ban -y

# Create fail2ban.local
echo -e "\nCreate fail2ban.local"
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

# Create jail.local
echo -e "\nCreate jail.local"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Create sshd jail
echo -e "\nCreate sshd jail"
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
echo -e "\nEnable and start Fail2Ban"
systemctl enable fail2ban && systemctl start fail2ban

# Adding docker repo
echo -e "\nAdding docker repo"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Installing docker
echo -e "\nInstalling docker"
dnf install docker-ce docker-ce-cli containerd.io -y

# Enable and start docker
echo -e "\nEnable and start docker"
systemctl enable docker && systemctl start docker

# Download docker compose
echo -e "\nDownload docker compose"
wget "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)"

# Move docker compose file
echo -e "\nMove docker compose file"
mv ./docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose

# Exec docker compose file
echo -e "\nExec docker compose file"
chmod +x /usr/local/bin/docker-compose
