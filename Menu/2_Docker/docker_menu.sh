function show_menu() {
    echo "1. Install Docker + Docker Composet"
    echo "2. Install Portainer"
    echo "3. Uninstall Portainer"
    echo "4. Back"
    echo "5. Exit"
    echo -n "Please choose an option [1 - 5]: "
}
function install_docker() {
    /opt/szilardshomelab/menu/2_docker/1_install_docker/install_docker.sh
}
function install_portainer() {
    /opt/szilardshomelab/menu/2_docker/2_portainer_install/install_portainer.sh
}
function uninstall_portainer() {
    /opt/szilardshomelab/menu/2_docker/3_portainer_uninstall/uninstall_portainer.sh
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_docker
            ;;
        2)
            install_portainer
            ;;
        3)
            uninstall_portainer
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