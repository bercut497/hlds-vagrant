#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
maxtryes=1000
cd "$( dirname ""$0"" )"
apt-get update -y -q > /dev/null

echo ' == [ INSTALL HLDS SCRIPT ] == '
if [[ "$(uname -a | grep -c 'x86_64')" -eq "1" ]]; then
	echo 'system is 64bit (amd64)'
	echo ' => install 32 libs'
	apt-get install lib32gcc1 lib32stdc++6 lib32z1 -q -y
	[ $? -eq 0 ] || exit $?
else
    apt-get install libstdc++6 libz1 -q -y
	[ $? -eq 0 ] || exit $?
fi

echo ' => add user'
adduser --system --group --disabled-password steamuser
adduser vagrant steamuser

if [[ ! -d "/home/steamuser" ]]; then
  mkdir -p /home/steamuser
  chown -Rf steamuser:steamuser /home/steamuser
fi
[ $? -eq 0 ] || exit $?

echo ' => create folders '
 mkdir -p /opt/{steam,hlds}
 if [ -f "/vagrant_bak/hlds.tar.gz" ] ; then
  cd /opt
  tar -xzvf /vagrant_bak/hlds.tar.gz
 fi 
 chown -Rf steamuser:steamuser /opt/{steam,hlds} 
 chmod -Rf 775 /opt/{steam,hlds} 
[ $? -eq 0 ] || exit $?

echo ' => get SteamCmd'
cd /opt/steam

if [[ ! -f steamcmd.sh ]] ; then
    echo '=> steam.sh not fount; get from tar' 
    if [[ ! -f steamcmd_linux.tar.gz ]] ; then
    echo '=> steamcmd_linux.tar.gz not fount; get from web'
        sudo -n -u steamuser wget -c http://media.steampowered.com/installer/steamcmd_linux.tar.gz
    [ $? -ne 0 ] && exit $? || ls -la ./
    fi
    tar -xvzf ./steamcmd_linux.tar.gz
    ls -la ./
    chown -Rvf steamuser:steamuser ./
fi
[ $? -eq 0 ] || exit $?


echo ' => add create symlinks'
sudo -n -u steamuser mkdir -p /home/steamuser/.steam
if [[ ! -d "/home/steamuser/.steam/sdk32" ]] ;then
  sudo -n -u steamuser ln -s /opt/steam/linux32 /home/steamuser/.steam/sdk32
fi

if [[ ! -f "/home/steamuser/.steam/sdk32/steamclient.so" ]] ; then
  sudo -n -u steamuser ln -s /opt/steam/linux32/steamclient.so /home/steamuser/.steam/sdk32/steamclient.so
fi

if [[ ! -f "/home/steamuser/.steam/steam" ]] ; then
  sudo -n -u steamuser ln -s -T /opt/steam/steam.sh /home/steamuser/.steam/steam
fi
[ $? -eq 0 ] || exit $?

  echo ' => try get steam files'
  /opt/steam/steamcmd.sh +login anonymous +quit
  
  cd /home/steamuser

  echo ' => *******************'
  echo ' => get game files'
  echo ' => *******************'


  echo ' ->  steam app 70 valve files'
  if [[ ! -f "/opt/steam/hlds_valve70.steam.sh" ]] ; then
    cp -v /vagrant_data/hlds_valve70.steam.sh /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_valve70.steam.sh
    chmod +x /opt/steam/hlds_valve70.steam.sh
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser /opt/steam/hlds_valve70.steam.sh
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt ${maxtryes} ]; then
        tcount=$(( ${tcount} +1 ));
        echo -e "\n ---> next try ( ${tcount} / ${maxtryes} ) ... \n\n"
		if [[ ${tcount}%100 -eq 0 ]] ; then 
		  sleep 10m
		elif [[ ${tcount}%10 -eq 0 ]] ; then
		  sleep 1m
		else
		  sleep 10s
		fi
    else
        echo "Cant update [ app 70 valve ] files. Try count: ${tcount} . "
        exit 1
    fi
  done

  echo ' ->  steam app 90 valve files'
  if [[ ! -f "/opt/steam/hlds_valve90.steam.sh" ]] ; then
    cp -v /vagrant_data/hlds_valve90.steam.sh /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_valve90.steam.sh
    chmod +x /opt/steam/hlds_valve90.steam.sh
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser /opt/steam/hlds_valve90.steam.sh
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt ${maxtryes} ]; then
        tcount=$(( ${tcount} +1 ));
        echo -e "\n ---> next try ( ${tcount} / ${maxtryes} ) ... \n\n"
		if [[ ${tcount}%100 -eq 0 ]] ; then 
		  sleep 10m
		elif [[ ${tcount}%10 -eq 0 ]] ; then
		  sleep 1m
		else
		  sleep 10s
		fi
    else
        echo "Cant update [ app 90 valve ] files. Try count: ${tcount} . "
        exit 1
    fi
  done  


  echo ' ->  steam app 90 cstrike files'
  if [[ ! -f "/opt/steam/hlds_cstrike10.steam.sh" ]] ; then
    cp -v /vagrant_data/hlds_cstrike10.steam.sh /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_cstrike10.steam.sh
    chmod +x /opt/steam/hlds_cstrike10.steam.sh
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser /opt/steam/hlds_cstrike10.steam.sh
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt ${maxtryes} ]; then
        tcount=$(( ${tcount} +1 ));
        echo -e "\n ---> next try ( ${tcount} / ${maxtryes} ) ... \n\n"
        if [[ ${tcount}%100 -eq 0 ]] ; then 
		  sleep 10m
		elif [[ ${tcount}%10 -eq 0 ]] ; then
		  sleep 1m
		else
		  sleep 10s
		fi
    else
        echo "Cant update [ app 10 cstrike ] files. Try count: ${tcount} . "
        exit 1
    fi
  done

  echo ' ->  steam app 90 cstrike files'
  if [[ ! -f "/opt/steam/hlds_cstrike90.steam.sh" ]] ; then
    cp -v /vagrant_data/hlds_cstrike90.steam.sh /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_cstrike90.steam.sh
    chmod +x /opt/steam/hlds_cstrike90.steam.sh
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser /opt/steam/hlds_cstrike90.steam.sh
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt ${maxtryes} ]; then
        tcount=$(( ${tcount} +1 ));
        echo -e "\n ---> next try ( ${tcount} / ${maxtryes} ) ... \n\n"
        if [[ ${tcount}%100 -eq 0 ]] ; then 
		  sleep 10m
		elif [[ ${tcount}%10 -eq 0 ]] ; then
		  sleep 1m
		else
		  sleep 10s
		fi
    else
        echo "Cant update [ app 90 cstrike ] files. Try count: ${tcount} . "
        exit 1
    fi
  done 
  
  cd ~

sudo -n -u steamuser touch /opt/hlds/cstrike/{listip,banned}.cfg
csdir="/opt/hlds/cstrike"

echo ' => disable secure'
sed -i 's|"secure".*|"secure ""0"" "|g' ${csdir}/liblist.gam
[ $? -eq 0 ] || exit $?

echo ' => create backup tar for boosting installation'
if [ -d "/vagrant_bak" ] ; then
	if [ -f "/vagrant_bak/hlds.tar.gz" ] ; then
		rm -f /vagrant_bak/hlds.tar.gz
	fi
	cd /opt
	tar -czvf /vagrant_bak/hlds.tar.gz hlds
fi

if [ ! -f "/var/run/hlds.pid" ] ; then
  touch /var/run/hlds.pid
fi
chmod 664 /var/run/hlds.pid
chown steamuser:steamuser /var/run/hlds.pid

if [ ! -f "/etc/init.d/hlds" ] ; then
  echo ' => set daemon'
  cp -v /vagrant_data/hlds-daemon.init /etc/init.d/hlds
  chmod +x /etc/init.d/hlds
  update-rc.d hlds defaults
  [ $? -eq 0 ] || exit $?
  
  echo ' => start daemon'
  /etc/init.d/hlds start
  [ $? -eq 0 ] || exit $?
fi

/etc/init.d/hlds status
exit 0
