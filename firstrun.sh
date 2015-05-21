#!/bin/bash
  
  #Search for config files, if they don't exist, copy the default ones
  if [ ! -f /config/apache.conf ]; then
    echo "copying apache.conf"
    cp /root/apache.conf /config/apache.conf
  fi
  
  if [ ! -f /config/zm.conf ]; then
    echo "copying zm.conf"
    cp /root/zm.conf /config/zm.conf
  fi
  
  # Copy mysql database if it doesn't exit
  if [ ! -d /config/mysql/mysql ]; then
    echo "moving mysql to config folder"
    rm -r /config/mysql
    cp -p -R /var/lib/mysql /config/
  fi
  
  # Copy data folder if it doesn't exist
  if [ ! -d /config/data ]; then
    echo "moving data folder to config folder"
    mkdir /config/data
    cp -R -p /usr/share/zoneminder /config/data/
    rm /config/data/zoneminder/images
    rm /config/data/zoneminder/events
    rm /config/data/zoneminder/temp
    mkdir /config/data/zoneminder/images
    mkdir /config/data/zoneminder/events
    mkdir /config/data/zoneminder/temp
  fi
  
  echo "creating symbolink links"
  rm -r /usr/share/zoneminder
  rm -r /var/lib/mysql
  rm -r /etc/zm
  ln -s /config/data/zoneminder /usr/share/zoneminder
  ln -s /config/mysql /var/lib/mysql
  ln -s /config /etc/zm
  chown -R mysql:mysql /var/lib/mysql
  chmod -R go+rw /config
  
  #Get docker env timezone and set system timezone
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  echo "starting services"
  service mysql start
  service apache2 start
  service zoneminder start
  
