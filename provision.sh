#!/bin/sh

# NOTICE: This script is interactive and will ask some questions!

# Remove password authentication and disable ssh login for root
# TODO these sed commands duplicate the entire config file and breaks it, have to do manually :(
#sed -in 'H;${x;s/\#PasswordAuthentication yes/PasswordAuthentication no/;p;}' /etc/ssh/sshd_config
#sed -in 'H;${x;s/PermitRootLogin yes/PermitRootLogin no/;p;}' /etc/ssh/sshd_config
#systemctl restart sshd

# Create swap (taken from https://github.com/loomio/loomio-deploy/blob/master/scripts/create_swapfile)
dd if=/dev/zero of=/swapfile count=4000 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# Upgrade all packages
apt-get update && apt-get upgrade -y

# Install docker and zsh
apt-get install -y --no-install-recommends \
    docker.io \
    docker-compose \
    zsh \
    git \
    fail2ban \
    iptables-persistent

# Create admin user for later sudo use
adduser admin
usermod -aG sudo admin

# Add root ssh key also for admin user
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
cp /root/.ssh/authorized_keys /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh

# Allow admin user to run docker
usermod -aG docker admin

# Install oh-my-zsh
sudo -u admin sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Change zsh theme from default "robbyrussel" to "ys"
sed -i 's/\brobbyrussell\b/ys/' /home/admin/.zshrc

# Add tmc alias for quick tmux attach/start
echo "alias tmc='tmux -CC attach-session -t \$USER || tmux -CC new-session -s \$USER'" >> /home/admin/.zshrc

# If needed, generate ssh key without passhprase
ssh-keygen -o -a 100 -t ed25519 -f /home/admin/.ssh/id_ed25519 -N ""

# Set up configuration for fail2ban
tee /etc/fail2ban/jail.local <<EOF
[DEFAULT]
destemail = $ADMIN_EMAIL
sendername = Fail2Ban

[sshd]
enabled = true
port = 22

[sshd-ddos]
enabled = true
port = 22
EOF
systemctl restart fail2ban

# Set up configuration for iptables
tee /etc/iptables/rules.v4 <<EOF
*filter

#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

#  Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL).
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT

#  Allow SSH connections
#  The -dport number should be the same port number you set in sshd_config
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

#  Allow ping
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

#  Log iptables denied calls
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

#  Reject all other inbound - default deny unless explicitly allowed policy
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOF
iptables-restore < /etc/iptables/rules.v4

# Check out this project
mkdir -p /opt/queerhaus
chown admin:admin /opt/queerhaus
sudo -u admin git clone https://github.com/queerhaus/hosting.git /opt/queerhaus
cd /opt/queerhaus

# Init submodules
git submodule init
git submodule update

# build hometown docker image
# TODO doesn't work https://github.com/tootsuite/mastodon/issues/12288
docker build -t hometown:local submodules/hometown
# NOTICE docker build command might give go errors, if so run this 
# dpkg -r --force-depends golang-docker-credential-helpers
# https://github.com/docker/docker-credential-helpers/issues/103


# Set up your environment
cp .env.example .env
nano .env

# Run mastodon setup guide
touch .env.hometown
chown 991:991 .env.hometown
docker-compose run --rm -v $(pwd)/.env.hometown:/opt/mastodon/.env.production town-web bundle exec rake mastodon:setup

