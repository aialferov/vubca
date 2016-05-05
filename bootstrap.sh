#!/usr/bin/env bash

usernames="casper aalferov"
hostname="ubca"

fullname="Anton I Alferov"

packages_to_install="\
    libevent-dev libncurses-dev \
    tree vim git curl rsync erlang erlang-manpages \
"

erlang_repo="erlang-solutions_1.0_all.deb"
erlang_repo_link="http://packages.erlang-solutions.com/$erlang_repo"

sync_dir="/vagrant"
cache_dir="$sync_dir/cache"

packages_dir="$cache_dir/apt"
packages_dir_guest="/var/cache/apt"

sources_dir="$cache_dir/sources"

sudoers_dir="/etc/sudoers.d"
locale_file="/etc/default/locale"
hostname_file="/etc/hostname"

flash_root="/media/flash"


### Fix locale

echo "LC_ALL=$LANG" >> $locale_file


### Change hostname

echo $hostname > $hostname_file
hostname $hostname


### Add user $username

for username in $usernames; do
    adduser --disabled-password --gecos "$fullname" $username
done

## Make $username the same sudoer as user vagrant

for username in $usernames; do
    cp $sudoers_dir/vagrant $sudoers_dir/$username
    sed -i s/vagrant/$username/ $sudoers_dir/$username
done

## Setup ssh for $usernames

for username in $usernames; do
    mkdir -p /home/$username/.ssh
    cat /home/vagrant/.ssh/authorized_keys >> \
        /home/$username/.ssh/authorized_keys
    chown -R $username:$username /home/$username/.ssh
done


### Install $packages_to_install and update system

mkdir -p $packages_dir/archives

# restore packages from cache
cp $packages_dir/*.bin $packages_dir_guest
cp $packages_dir/archives/*.deb $packages_dir_guest/archives

wget -c $erlang_repo_link -P $packages_dir_guest/archives
sudo dpkg -i $packages_dir_guest/archives/$erlang_repo

apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
apt-get install -y $packages_to_install

# update packages cache
rsync -a $packages_dir_guest/*.bin $packages_dir/
rsync -a $packages_dir_guest/archives/*.deb $packages_dir/archives/


### Setup some apps for $usernames

function tar_install { link="$1" name="$2"
    archive="${link##*/}"
    
    wget -c "$link"
    tar xf "$archive"
    cd "$name"

    ./configure
    make -j8
    sudo make install

    cd ../
}

function git_install { link="$1" make="$2" install_as="$3"
    name="${link##*/}"
    cur_dir="$PWD"
    run=""

    if [ -d "$name" ]; then cd $name; git pull; cd ../; else git clone $link; fi
    if [ "$make" = "make" ]; then make -C $name; fi
    if [ "$install_as" != "root" ]; then run="sudo -iu $install_as"; fi

    $run make install -C $cur_dir/$name
}

mkdir -p $sources_dir && cd $sources_dir

archive="https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
name="tmux-2.2"

tar_install "$archive" "$name"

for username in $usernames; do
    git_install git://github.com/aialferov/dotfiles nomake $username
done

git_install git://github.com/aialferov/etools make root
git_install git://github.com/aialferov/scripts nomake root


### Setup flash drive directory

for username in $usernames; do
    echo "export FLASH_ROOT=$flash_root" >> /home/$username/.profile
done
