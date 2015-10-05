#!/bin/bash

set -e

SRC_DIR="$HOME/src"
ANSIBLE_DIR="$SRC_DIR/ansible"

: ${hostuname:=`uname -s`}
if [[ "${hostuname}" != "Darwin" ]]; then
    echo "Error  | Fatal     | Only use this script on OSX"
    exit 1
fi
unset hostuname

echo "Info   | Message   | Beginning OSX setup script"

# Download and install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    brew install ansible
fi

# Make the code directory
mkdir -p $SRC_DIR

# Clone down ansible
if [[ ! -d $ANSIBLE_DIR ]]; then
    git clone https://github.com/medains/ansible.git $ANSIBLE_DIR
fi

pushd $ANSIBLE_DIR
ansible-playbook site.yml -i hosts
popd
