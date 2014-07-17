#!/usr/bin/env bash

username="casper"
hostname="vubca"

packages_to_install="tree tmux vim git curl"

erlang_deb="esl-erlang_17.1-1~ubuntu~trusty_amd64.deb"
erlang_man="otp_doc_man_17.1.tar.gz"

erlang_deb_link=\
"http://packages.erlang-solutions.com\
/site/esl/esl-erlang/FLAVOUR_1_general/$erlang_deb"
erlang_man_link="http://www.erlang.org/download/$erlang_man"

home="/home/$username"

sync_dir="/vagrant"
cache_dir="$sync_dir/cache"

erlang_dir="/usr/lib/erlang"

sudoers_dir="/etc/sudoers.d"
locale_file="/etc/default/locale"
hostname_file="/etc/hostname"

flash_root="/media/flash"

run_as_username="sudo -iu $username"


### Fix locale

echo "LC_ALL=$LANG" >> $locale_file


### Change hostname

echo $hostname > $hostname_file
hostname $hostname


### Install $packages_to_install and Erlang

apt-get update && apt-get upgrade -y
apt-get install -y $packages_to_install

mkdir -p $cache_dir
cd $cache_dir

if [ ! -f $erlang_deb ]; then wget $erlang_deb_link; fi
if [ ! -f $erlang_man ]; then wget $erlang_man_link; fi

dpkg -i $erlang_deb
apt-get install -fy

tar vzxf $erlang_man -C $erlang_dir


### Add user $username

adduser --disabled-password --gecos "" $username

## Make $username the same sudoer as user vagrant

cp $sudoers_dir/vagrant $sudoers_dir/$username
sed -i s/vagrant/$username/ $sudoers_dir/$username

## Setup ssh for $username (you should put .ssh.tar.bz2 there)

tar vjxf $sync_dir/.ssh.tar.bz2 -C $home
cat /home/vagrant/.ssh/authorized_keys >> $home/.ssh/authorized_keys
chown -R $username:$username $home/.ssh/

## Setup some apps for $username

$run_as_username git clone git:git/configs
$run_as_username make install -C configs
$run_as_username rm -rf configs

$run_as_username git clone git@github.com:aialferov/etools $home/etools
$run_as_username make -C $home/etools
make install -C $home/etools
$run_as_username rm -rf $home/etools


### Setup flash drive directory

echo "export FLASH_ROOT=$flash_root" >> $home/.profile
