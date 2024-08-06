#!/bin/bash

function show_menu() {
    echo "1. Basic Function (Apt-Update/Upgrade, Reboot, Shutdown)"
    echo "2. Docker (Docker, Portainer)"
    echo "3. Network (PiHole DNS, Traefik Reverse Proxy, Cloudflare-Tunnel)"
    echo "4. Media (SMB mount, qBittorrent)"
    echo "5. ARRs"
    echo "6. Traefik"
    echo "7. Cloudflare"
    echo "8. Exit"
    echo -n "Please choose an option [1 - 4]: "
}

function basic_function() {
    echo "Opening Basic Functions Menu..."
    /opt/szilardshomelab/menu/1_basic_scripts/basic_scripts_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function docker() {
    echo "Executing Docker setup..."
    /opt/szilardshomelab/menu/2_docker/docker_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function network() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/3_network/network_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function media() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/4_media/media_menu.sh
    
    if [ $? -eq 1 ]; then
        exit 0
    fi
}
function arrs() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/5_arrs/arrs_menu.sh
    
    if [ $? -eq 1 ]; then
        exit 0
    fi
}
# function cloudflare() {
#     echo "Executing Downloaders setup..."
#     /opt/szilardshomelab/menu/6_cloudflare-tunnel/cloudflare-menu.sh
    
#     if [ $? -eq 1 ]; then
#         exit 0
#     fi
# }
while true; do
    show_menu
    read choice
    case $choice in
        1)
            basic_function
            ;;
        2)
            docker
            ;;
        3)
            network
            ;;
        4)
            media
            ;;
        5)
            arrs
            ;;   
        # 6)
        #     cloudflare
        #     ;;                  
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done