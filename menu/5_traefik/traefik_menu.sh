function show_menu() {
    echo "1. Traefik install"
    echo "2. Back"
    echo "3. Exit"
    echo -n "Please choose an option [1 - 3]: "
}
function install_traefik() {
    /opt/szilardshomelab/menu/5_traefik/1_traefik_install/install_traefik.sh
}


while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_traefik
            ;;
        2)
            clear
            echo "Returning to the main menu..."
            exit 0
            ;;    
        3)
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