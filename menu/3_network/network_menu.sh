function show_menu() {
    echo "1. Pihole"
    echo "2. Traefik"
    echo "3. Cloudflare Tunnel"
    echo "4. Back"
    echo "5. Exit"
    echo -n "Please choose an option [1 - 5]: "
}
function install_pihole() {
    /opt/szilardshomelab/menu/3_network/1_pihole/install_pihole.sh
}
function install_traefik() {
    /opt/szilardshomelab/menu/2_docker/2_portainer_install/install_portainer.sh
}
function install_cloudflare_tunnel() {
    /opt/szilardshomelab/menu/2_docker/3_portainer_uninstall/uninstall_portainer.sh
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_pihole
            ;;
        2)
            install_traefik
            ;;
        3)
            install_cloudflare_tunnel
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