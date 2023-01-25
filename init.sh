#!/bin/bash
if [ "$1" == "" ]; then
  echo "请输入用户名，并确保使用 sudo 运行该脚本。"
  exit
fi

echo 是否已将SSH RSA密钥加入到github？[y/N]
read result
if [ "$result" != "y" ]; then
  echo 请先将密钥加入github
  exit
fi

echo 该操作会覆盖现有配置，是否继续？[y/N]
read result
if [ "$result" != "y" ]; then
  echo 已终止安装！
  exit
fi


### list ###
# [done] common software
# [done] shadowsocks-libev
# [done] nvidia driver
# [done] docker and nvidia-docker
# neovim and my neovim ide
# i3wm-gaps
#   polybar
#   trayer
#   fcitx5 
#   blueman-applet 
#   telegram-desktop 
# [done] feh
#   steam
#   wallpaper-engine
# [done] birdtray
# [done] xfce4-terminal
# bitcoin-qt [optional]
# [done] diff-so-fancy # git diff beauty
# 

sudo runuser -u $1 -- git submodule update --init

ubuntu_codename=`lsb_release -a | grep Codename -i | awk '{print $2}'`
sudo wget https://mirrors.ustc.edu.cn/repogen/conf/ubuntu-https-4-$ubuntu_codename -O /etc/apt/sources.list
sudo add-apt-repository ppa:obsproject/obs-studio

sudo apt update && sudo apt install trayer git iputils-ping gcc g++ autoconf automake libtool screen \
  openssh-server wget vim alsa-utils apt-transport-https gdb gdbserver xorg zsh xfce4-terminal \
  libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager qemu-utils \
  software-properties-common thunderbird rclone filezilla fzf ranger cpu-x neofetch \
  curl sudo libdigest-sha-perl psmisc net-tools iftop dnsutils telnet nfs-common \
  firefox vlc xfce4-screenshooter gimp ffmpeg obs-studio \
  gnome-system-monitor figlet nodejs npm -y

sudo dpkg -i ./packages/netease-cloud-music.deb

echo "############################"
echo "开始安装shadowsocks-libev"

cd ./shadowsocks-libev_configuration/ && sudo bash ./init.sh --setup && cd - 

echo "############################"
echo "开始安装驱动"
sudo ubuntu-drivers autoinstall

echo "############################"
echo "开始安装docker和nvidia-docker"
cd ./docker-install-shell && sudo bash install-docker.sh && cd -

echo "############################"
echo "开始安装i3"
cd ./i3-config/ && ./install.sh && cd -

echo "############################"
echo "开始安装xfce4-terminal"
cd ./xfce4-terminal
sudo runuser -u vssblt -- ./install.sh
cd -

echo "############################"
echo "开始安装node相关软件"
sudo npm -g install diff-so-fancy -y
sudo runuser -u $1 -- git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
sudo runuser -u $1 -- git config --global interactive.diffFilter "diff-so-fancy --patch"
sudo runuser -u $1 -- git config --global color.ui true
sudo runuser -u $1 -- git config --global color.diff-highlight.oldNormal    "red bold"
sudo runuser -u $1 -- git config --global color.diff-highlight.oldHighlight "red bold 52"
sudo runuser -u $1 -- git config --global color.diff-highlight.newNormal    "green bold"
sudo runuser -u $1 -- git config --global color.diff-highlight.newHighlight "green bold 22"
sudo runuser -u $1 -- git config --global color.diff.meta       "11"
sudo runuser -u $1 -- git config --global color.diff.frag       "magenta bold"
sudo runuser -u $1 -- git config --global color.diff.func       "146 bold"
sudo runuser -u $1 -- git config --global color.diff.commit     "yellow bold"
sudo runuser -u $1 -- git config --global color.diff.old        "red bold"
sudo runuser -u $1 -- git config --global color.diff.new        "green bold"
sudo runuser -u $1 -- git config --global color.diff.whitespace "red reverse"


echo "############################"
echo "开始安装Telegram-desktop软件"
sudo snap install --classic telegram-desktop
