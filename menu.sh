#!/bin/bash

function show_menu() {
    echo "1. Basic Function (Apt-Update/Upgrade, Reboot, Shutdown)"
    echo "2. Docker"
    echo "3. Media (SMB mount, qBittorrent)"
    echo "4. ARRs"
    echo "5. Exit"
    echo -n "Please choose an option [1 - 4]: "
}

function basic_function() {
    echo "Opening Basic Functions Menu..."
    /opt/szilardshomelab/Menu/1_Basic_Scripts/basic_scripts_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function docker() {
    echo "Executing Docker setup..."
    /opt/szilardshomelab/Menu/2_Docker/docker_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function media() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/Menu/3_Media/media_menu.sh
    if [ $? -eq 1 ]; then
        exit 0
    fi
}

function arrs() {
    echo "Executing Downloaders setup..."
    /opt/szilardshomelab/Menu/4_ARRs/arrs_menu.sh
    
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
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done