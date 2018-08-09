#!/usr/bin/env bash

function yum_install() {
  sudo yum install -y "$@"
  if [ $? -ne 0 ]; then
    echo "Failed to install: $@"
    exit 1
  fi
}

yum_install yum-utils rpmdevtools @"Development Tools" \
            sqlite-devel zlib-devel


# SBCL 1.3, we'll overwrite the repo version of sbcl with a more recent one
yum_install epel-release
sudo yum install -y sbcl.x86_64 --enablerepo=epel
if [ $? -ne 0 ]; then
  echo 'Failed to install sbcl from EPEL'
  exit 1
fi

wget http://downloads.sourceforge.net/project/sbcl/sbcl/1.3.6/sbcl-1.3.6-source.tar.bz2
tar xfj sbcl-1.3.6-source.tar.bz2
cd sbcl-1.3.6
./make.sh --with-sb-thread --with-sb-core-compression --prefix=/usr > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'Failed to build sbcl 1.3.6'
  exit 1
fi
sudo sh install.sh
cd

# Missing dependencies
yum_install install freetds-devel

# prepare the rpmbuild setup
rpmdev-setuptree

# pgloader
#make -C /vagrant rpm
