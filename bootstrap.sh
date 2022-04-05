#!/bin/bash

set -eu

# grab keys
curl -s https://github.com/szarnyasg.keys >> ~/.ssh/authorized_keys
curl -s https://github.com/gladap.keys >> ~/.ssh/authorized_keys
curl -s https://github.com/hbirler.keys >> ~/.ssh/authorized_keys
curl -s https://github.com/jackwaudby.keys >> ~/.ssh/authorized_keys

# git-aware prompt
cat << 'EOF' >> ~/.bashrc
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF

# aliases
cat << 'EOF' >> ~/.bashrc
alias bi="cd /data/ldbc_snb_bi"
alias int="cd /data/ldbc_snb_interactive_impls"
alias pg="cd /data/ldbc_snb_bi/paramgen"
alias datagen="cd /data/ldbc_snb_datagen_spark"
alias ec2="cd ~/ec2-bootstrap"
get() {
    curl -s ${1} | tar -xv -I zstd
}
EOF

# packages
sudo yum install -y tmux wget wget2 git docker docker-compose htop vim maven python3-pip unzip zstd fio
# make Docker work
sudo gpasswd -a ${USER} docker

# SELinux can get in the way of benchmarking, consider disabling it
echo "sudo setenforce 0" >> ~/.bashrc

# grab repository
cd ~
git clone https://github.com/szarnyasg/ec2-bootstrap
~/ec2-bootstrap/set-datagen-env-vars.sh
