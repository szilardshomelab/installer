function show_menu() {
    echo "1. Cloudflare-tunnel start"
    echo "2. Back"
    echo "3. Exit"
    echo -n "Please choose an option [1 - 3]: "
}
function cloudflare_start() {
    /opt/szilardshomelab/menu/6_cloudflare-tunnel/1_create_tunnel/create_tunnel.sh
}


while true; do
    show_menu
    read choice
    case $choice in
        1)
            cloudflare_start
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