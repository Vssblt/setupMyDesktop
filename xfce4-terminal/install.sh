#!/bin/bash
sudo apt install xfce4-terminal -y
mkdir .config/xfce4/terminal/ -p
cp ./conf/* $HOME/.config/xfce4/terminal/ -rf
