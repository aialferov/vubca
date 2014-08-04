#!/usr/bin/env bash

username="casper"
hostname="vubca"

gecos="Anton I Alferov"

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

packages_dir="$cache_dir/apt"
packages_dir_guest="/var/cache/apt"

sources_dir="$cache_dir/sources"

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

mkdir -p $packages_dir/archives

# restore packages from cache
cp $packages_dir/*.bin $packages_dir_guest
cp $packages_dir/archives/*.deb $packages_dir_guest/archives

apt-get update && apt-get upgrade -y
apt-get install -y $packages_to_install

mkdir -p $cache_dir && cd $cache_dir

if [ ! -f $erlang_deb ]; then wget $erlang_deb_link; fi
if [ ! -f $erlang_man ]; then wget $erlang_man_link; fi

dpkg -i $erlang_deb
apt-get install -fy

tar vzxf $erlang_man -C $erlang_dir

# update packages cache
cp $packages_dir_guest/*.bin $packages_dir
cp $packages_dir_guest/archives/*.deb $packages_dir/archives


### Add user $username

adduser --disabled-password --gecos "$gecos" $username

## Make $username the same sudoer as user vagrant

cp $sudoers_dir/vagrant $sudoers_dir/$username
sed -i s/vagrant/$username/ $sudoers_dir/$username

## Setup ssh for $username (you should put .ssh.tar.bz2 there)

for i in $home /root; do tar vjxf $sync_dir/.ssh.tar.bz2 -C $i; done
cat /home/vagrant/.ssh/authorized_keys >> $home/.ssh/authorized_keys
chown -R root:root /root/.ssh/
chown -R $username:$username $home/.ssh/

## Setup some apps for $username

function git_install { path="$1" make="$2" install_from="$3"
	name="${path##*/}"
	cur_dir="$PWD"
	run=""

	if [ -d "$name" ]; then cd $name; git pull; cd ../; else git clone $path; fi
	if [ "$make" = "make" ]; then make -C $name; fi
	if [ "$install_from" != "root" ]; then run="sudo -iu $install_from"; fi

	$run make install -C $cur_dir/$name
}

mkdir -p $sources_dir && cd $sources_dir

git_install git@alferov.me:git/configs nomake $username
git_install git@github.com:aialferov/etools make root
git_install git@github.com:aialferov/scripts nomake root


### Setup flash drive directory

echo "export FLASH_ROOT=$flash_root" >> $home/.profile
