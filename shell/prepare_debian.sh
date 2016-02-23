#!/bin/bash

start_date=$(date +"%s")

if [[ "$EUID" -ne "0" ]]; then
	echo ' sh: -> restart with sudo'
	sudo $0
else

  echo ' sh: -> locale-gen'
  locale-gen > /dev/null
  cat >> /root/.bashrc <<EOL
##
if [[ -f "/etc/bash_completion" ]] ; then
    . /etc/bash_completion
fi

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

EOL

cat >> /home/vagrant/.bashrc <<EOL

##
if [[ -f "/etc/bash_completion" ]] ; then
    . /etc/bash_completion
fi

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

EOL

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
localedef -i en_US -f UTF-8 en_US.UTF-8 > /dev/null

sed -i 's|^mesg n.*$|tty -s \&\& mesg n|gi' /root/.profile

  echo ' sh: -> disable password for users "vagrant" and "root"'
  usermod vagrant --lock
  usermod root --lock
  
  echo ' sh: -> GRUB single boot record (disablr recovery'
  sed -i 's|^#GRUB_DISABLE_RECOVERY=.*$|GRUB_DISABLE_RECOVERY="true"|g' /etc/default/grub
  sed -i 's|^GRUB_TIMEOUT=[0-9]$|GRUB_TIMEOUT=1|g' /etc/default/grub
  
  update-grub
  
  echo ' sh: -> copy sources to vm'
  cat /vagrant_conf/pref > /etc/apt/preferences
  cat /vagrant_conf/src > /etc/apt/sources.list
  sudo cp -frv /vagrant_conf/d/* /etc/apt/sources.list.d
  sudo cp -frv /vagrant_conf/apt.d/* /etc/apt/apt.conf.d
  
  echo ' sh: -> restore priviveleges'
  chmod -Rv 755 /etc/apt/sources.list.d
  chown -Rv root:root /etc/apt/sources.list.d  
  
  echo ' sh: -> import local keys'
  cd /vagrant_conf/key/
  bash /vagrant_conf/key/add-key.gpg.sh
  cd ~
 
  
  echo ' sh: -> disable ipv6 at all '
  cat > /etc/sysctl.d/noipv6 <<EOL
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
net.ipv6.conf.eth1.disable_ipv6 = 1
net.ipv6.conf.ppp0.disable_ipv6 = 1
net.ipv6.conf.tun0.disable_ipv6 = 1
EOL

  cat > /etc/apt/apt.conf.d/99-force-ipv4 <<EOL
Acquire::ForceIPv4 true;
Acquire::ForceIPv6 false;
EOL

  sed -i 's|#precedence ::ffff:0:0/96  100|precedence ::ffff:0:0/96  100|g' /etc/gai.conf
  sed -i 's/tcp6/#tcp6/g' /etc/netconfig
  sed -i 's/udp6/#udp6/g' /etc/netconfig

  echo ' sh: -> update all'
  aptitude update > /dev/null

  echo ' sh: -> install debian keyrings'
  apt-get --yes --force-yes install \
    debian-keyring \
    debian-archive-keyring \
    debian-ports-archive-keyring \
    deb-multimedia-keyring \
    > /dev/null


  #echo ' sh: -> debian update'
  #apt-get --yes update > /dev/null
  #apt-get --yes --force-yes upgrade > /dev/null
  #aptitude -Ry safe-upgrade

end_date=$(date +"%s")
diff=$(($end_date-$start_date))
echo '#########################'
echo "## $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."

fi
exit 0
