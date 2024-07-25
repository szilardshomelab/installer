function show_menu() {
    echo "1. Prowlarr install"
    echo "2. Prowlarr uninstall"
    echo "3. Radarr install"
    echo "4. Radarr uninstall"
    echo "5. Sonarr install"
    echo "6. Sonarr uninstall"
    echo "7. Back"
    echo "8. Exit"
    echo -n "Please choose an option [1 - 3]: "
}
function install_prowlarr() {
    /opt/szilardshomelab/Menu/4_ARRs/1_prowlarr_install/install_prowlarr.sh
}
function uninstall_prowlarr() {
    /opt/szilardshomelab/Menu/4_ARRs/2_prowlarr_uninstall/uninstall_prowlarr.sh
}
function install_radarr() {
    /opt/szilardshomelab/Menu/4_ARRs/3_radarr_install/install_radarr.sh
}
function uninstall_radarr() {
    /opt/szilardshomelab/Menu/4_ARRs/4_radarr_uninstall/uninstall_radarr.sh
}
function install_sonarr() {
    /opt/szilardshomelab/Menu/4_ARRs/5_sonarr_install/install_sonarr.sh
}
function uninstall_sonarr() {
    /opt/szilardshomelab/Menu/4_ARRs/6_sonarr_uninstall/uninstall_sonarr.sh
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_prowlarr
            ;;
        2)
            uninstall_prowlarr
            ;;
        3)
            install_radarr
            ;;
        4)
            uninstall_radarr
            ;;
        5)
            install_sonarr
            ;;
        6)
            uninstall_sonarr
            ;;
        7)
            clear
            echo "Returning to the main menu..."
            exit 0
            ;;    
        8)
            echo "Exit"
            exit 1
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done
EOF