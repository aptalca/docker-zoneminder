#!/bin/bash

  service zoneminder stop
  service apache stop
  service mysql stop
  
  #Search for config files, if they don't exist, copy the default ones
  if [ ! -f /config/apache.conf ]; then
    cp /root/apache.conf /config/apache.conf
    chmod a+w /config/apache.conf
  fi
  
  if [ ! -f /config/zm.conf ]; then
    cp /root/zm.conf /config/zm.conf
    chmod a+w /config/zm.conf
  fi
  
  # Copy mysql database if it doesn't exit
  if [ ! -d /config/mysql/zm ]; then
    mkdir -p /config/mysql/zm
    cp /var/lib/mysql/zm/* /config/mysql/zm/
    chmod -R o+rw /config/mysql/zm
  fi
  
  # Copy data folder if it doesn't exist
  if [ ! -d /config/data/zoneminder ]; then
    mkdir /config/data
    cp -R -p /usr/share/zoneminder /config/data
    rm /config/data/zoneminder/images
    rm /config/data/zoneminder/events
    rm /config/data/zoneminder/temp
    mkdir /config/data/zoneminder/images
    mkdir /config/data/zoneminder/events
    mkdir /config/data/zoneminder/temp
  fi
  
  rm -r /usr/share/zoneminder
  rm -r /var/lib/mysql/zm
  ln -s /config/data/zoneminder /usr/share/zoneminder
  ln -s /config/mysql/zm /var/lib/mysql/zm
  ln -s /config /etc/zm
  
  #Get docker env timezone and set system timezone
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  service mysql restart
  service apache2 restart
  service zoneminder restart
  
