#!/bin/bash

function show_menu() {
    echo "1. Basic Function (Apt-Update/Upgrade, Reboot, Shutdown)"
    echo "2. Docker"
    echo "3. Media (SMB mount, qBittorrent)"
    echo "4. ARRs"
    echo "5. Traefik"
    echo "6. Cloudflare"
    echo "7. Exit"
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

function media() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/3_media/media_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function arrs() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/4_arrs/arrs_menu.sh
    
    if [ $? -eq 1 ]; then
        exit 0
    fi
}
function traefik() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/5_traefik/traefik_menu.sh
    
    if [ $? -eq 1 ]; then
        exit 0
    fi
}
function cloudflare() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/menu/6_cloudflare-tunnel/cloudflare-menu.sh
    
    if [ $? -eq 1 ]; then
        exit 0
    fi
}
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
            media
            ;;
        4)
            arrs
            ;;
        5)
            traefik
            ;;   
        6)
            cloudflare
            ;;                  
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done