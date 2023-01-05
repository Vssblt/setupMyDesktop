#!/bin/bash
if [ "$1" == "" ]; then
  echo "请输入用户名，并确保已加入sudo"
  exit
fi

su - $1
if [ "$?" != "0" ]; then
  echo "用户不存在"
  exit 
fi

echo 是否已将SSH RSA密钥加入到github？[y/N]
read result
if [ "$result" != "y" ]; then
  echo 请先将密钥加入github
  exit
fi



### list ###
# common software
# shadowsocks-libev
# nvidia driver
# docker and nvidia-docker
# neovim and my neovim ide
# i3wm-gaps
#   polybar
#   trayer
#   fcitx5 
#   blueman-applet 
#   telegram-desktop 
#   feh
#   steam
#   wallpaper-engine
#   birdtray
#   xfce4-terminal
# bitcoin-qt
# diff-so-fancy # git diff beauty
# 

git submodules init --update

ubuntu_codename=`lsb_release -a | grep Codename -i | awk '{print $2}'`
sudo wget https://mirrors.ustc.edu.cn/repogen/conf/ubuntu-https-4-$ubuntu_codename -O /etc/apt/sources.list
sudo add-apt-repository ppa:obsproject/obs-studio

sudo apt update && apt install git iputils-ping gcc g++ autoconf automake libtool screen \
  libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager qemu-utils \
  openssh-server wget vim alsa-utils apt-transport-https gdb gdbserver xorg zsh \
  curl sudo libdigest-sha-perl psmisc net-tools iftop dnsutils telnet nfs-common \
  software-properties-common thunderbird rclone filezilla fzf ranger cpu-x neofetch \
  google-chrome-stable firefox vlc xfce4-screenshooter gimp ffmpeg obs-studio \
  gnome-system-monitor figlet nodejs npm -y

sudo dpkg -i ./packages/netease-cloud-music.deb

echo "############################"
echo "开始安装shadowsocks-libev"
cd ./shadowsocks-libev_configuration/ && ./init.sh --setup && cd -

echo "############################"
echo "开始安装驱动"
sudo ubuntu-drivers autoinstall

echo "############################"
echo "开始安装docker和nvidia-docker"
cd ./docker-install-shell && sudo bash install-docker.sh && cd -

echo "############################"
echo "开始安装i3"

echo "############################"
echo "开始安装polybar"
cd ./polybar && ./init.sh && cd -

echo "############################"
echo "开始安装node相关软件"
sudo npm install diff-so-fancy -y
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
