#!/bin/bash
# Update CentOS 
echo "Updating CentOS"
dnf upgrade -y

# Installing packages
echo "Installing packages"
dnf install epel-release vim mc wget dnf-plugins-core -y

# Installing Fail2Ban
echo "Installing Fail2Ban"
dnf install fail2ban -y

# Create fail2ban.local
echo "Create fail2ban.local"
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

# Create jail.local
echo "Create jail.local"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Create sshd jail
echo "Create sshd jail"
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
echo "Enable and start Fail2Ban"
systemctl enable fail2ban && systemctl start fail2ban

# Adding docker repo
echo "Adding docker repo"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Installing docker
echo "Installing docker"
dnf install docker-ce docker-ce-cli containerd.io -y

# Enable and start docker
echo "Enable and start docker"
systemctl enable docker && systemctl start docker

# Download docker compose
echo "Download docker compose"
wget "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)"

# Move docker compose file
echo "Move docker compose file"
mv ./docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose

# Exec docker compose file
echo "Exec docker compose file"
chmod +x /usr/local/bin/docker-compose
