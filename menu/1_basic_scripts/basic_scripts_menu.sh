#!/bin/bash

function show_menu() {
    echo "1. Update/Upgrade"
    echo "2. Reboot"
    echo "3. Poweroff"
    echo "4. Back to Main Menu"
    echo "5. Exit"
    echo -n "Please choose an option [1 - 5]: "
}

function update_system() {
    echo "Updating and upgrading the system..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
}

function reboot_system() {
    echo "Rebooting the system..."
    sudo reboot
}

function poweroff_system() {
    echo "Powering off the system..."
    sudo poweroff
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            update_system
            ;;
        2)
            reboot_system
            ;;
        3)
            poweroff_system
            ;;
        4)
            clear
            echo "Returning to the main menu..."
            exit 0
            ;;
        5)
            echo "Exit"
            exit 1
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done