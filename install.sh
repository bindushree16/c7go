#!/bin/bash -e

echo "================= Adding some global settings ==================="
mkdir -p "$HOME/.ssh/"
mv /c7go/config "$HOME/.ssh/"
cat /c7go/90forceyes >> /etc/yum.conf
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ================"

yum -y install  \
sudo \
software-properties-common \
wget \
curl \
openssh-client \
ftp \
gettext \
smbclient \
which \
make

# TODO: cross-check this list against final CentOS script
# Install packages for Go
echo "================= Install packages for Go ==================="

yum update && yum install -y \
autotools-dev \
autoconf \
bison \
git \
mercurial \
cmake \
scons \
binutils \
gcc \
bzr

echo "================= Installing Python packages ==================="
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
#adding key required to install python
gpgkey=http://springdale.math.ias.edu/data/puias/6/x86_64/os/RPM-GPG-KEY-puias

sudo yum install -y \
  python-devel \
  python-pip

sudo pip2 install virtualenv==16.5.0
sudo pip2 install pyOpenSSL==19.0.0

export JQ_VERSION=1.5*
echo "================= Adding JQ $JQ_VERSION ==================="
sudo yum install -y jq-"$JQ_VERSION"

echo "================= Installing CLIs packages ======================"

export GIT_VERSION=2.18.0
echo "================= Installing Git $GIT_VERSION ===================="
sudo yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
sudo yum install -y git-"$GIT_VERSION"

export GCLOUD_SDKREPO=249.0*
echo "================= Adding gcloud $GCLOUD_SDKREPO  ============"
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
#adding key required to install gcloud
rpm --import  https://packages.cloud.google.com/yum/doc/yum-key.gpg
rpm --import  https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
sudo yum install -y google-cloud-sdk-"$GCLOUD_SDKREPO"

export AWS_VERSION=1.16.173
echo "================= Adding awscli $AWS_VERSION ===================="
sudo pip install awscli=="$AWS_VERSION"

AZURE_CLI_VERSION=2.0*
echo "================ Adding azure-cli $AZURE_CLI_VERSION  =============="
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
sudo yum install -y azure-cli-$AZURE_CLI_VERSION

export JFROG_VERSION=1.25.0
echo "================= Adding jfrog-cli $JFROG_VERSION==================="
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
sudo mv jfrog /usr/bin/jfrog

# Install gvm
echo "================= Install gvm ==================="
curl -s -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash

export CGO_ENABLED=0
. /c7go/go_install.sh
