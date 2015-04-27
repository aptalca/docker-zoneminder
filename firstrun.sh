#!/bin/bash

  service zoneminder stop
  service apache stop
  service mysql stop
  
  #Search for config files, if they don't exist, copy the default ones
  if [ ! -f /config/apache.conf ]; then
    cp /root/apache.conf /config/apache.conf
    chmod a+w /config/duck.conf
  fi
  
  if [ ! -f /config/zm.conf ]; then
    cp /root/zm.conf /config/zm.conf
    chmod a+w /config/zm.conf
  fi
  
  if [ ! -d /config/mysql/zm ]; then
    mkdir -p /config/mysql/zm
    cp /var/lib/mysql/zm/* /config/mysql/zm/
    chmod -R o+rw /config/mysql/zm
  fi
  
  rm -r /var/lib/mysql/zm
  ln -s /config/mysql/zm /var/lib/mysql/zm
  ln -s /config /etc/zm
  
  #Get docker env timezone and set system timezone
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  service mysql restart
  service apache2 restart
  service zoneminder restart
