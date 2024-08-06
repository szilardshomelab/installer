#!/bin/bash

function show_menu() {
    echo "1. Update/Upgrade"
    echo "2. Install Qemu-Guest-Agent"
    echo "3. Reboot"
    echo "4. Poweroff"
    echo "5. Back to Main Menu"
    echo "6. Exit"
    echo -n "Please choose an option [1 - 5]: "
}

function update_system() {
    echo "Updating and upgrading the system..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
}
function qemu-guest-agent(){
    sudo apt-get update -y
    sudo apt-get install qemu-guest-agent -y
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
            qemu-guest-agent
            ;;
        4)
            poweroff_system
            ;;
        5)
            clear
            echo "Returning to the main menu..."
            exit 0
            ;;
        6)
            echo "Exit"
            exit 1
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done