#!/bin/bash

rm -r /opt/szilardshomelab &&\
sudo mkdir /opt/szilardshomelab &&\
sudo mkdir /opt/szilardshomelab/docker &&\
sudo wget -qO /opt/szilardshomelab/basic_function.sh https://raw.githubusercontent.com/szilardshomelab/test/main/basic_function.sh &&\
chmod +x /opt/szilardshomelab/basic_function.sh &&\
sudo wget -qO /opt/szilardshomelab/menu.sh https://raw.githubusercontent.com/szilardshomelab/test/main/menu.sh &&\
chmod +x /opt/szilardshomelab/menu.sh &&\
sudo wget -qO /opt/szilardshomelab/docker/install.sh https://raw.githubusercontent.com/szilardshomelab/test/main/Docker/install.sh &&\
chmod +x /opt/szilardshomelab/docker/install.sh &&\
sudo wget -qO /opt/szilardshomelab/install_qbittorrent.sh https://raw.githubusercontent.com/szilardshomelab/test/main/install_qbittorrent.sh &&\
chmod +x /opt/szilardshomelab/install_qbittorrent.sh &&\
/opt/szilardshomelab/menu.sh


