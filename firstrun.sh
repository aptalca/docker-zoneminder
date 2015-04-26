#!/bin/bash

  #Search for config files, if they don't exist, copy the default ones
  if [ ! -f /config/apache.conf ]; then
    cp /root/apache.conf /config/apache.conf
    chmod a+w /config/duck.conf
  fi
  
  if [ ! -f /config/zm.conf ]; then
    cp /root/zm.conf /config/zm.conf
    chmod a+w /config/zm.conf
  fi
  
  ln -s /config /etc/zm
  
  #Get docker env timezone and set system timezone
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  service mysql restart
  service apache2 restart
  service zoneminder restart
