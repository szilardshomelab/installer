function show_menu() {
    echo "1. SMB Mount"
    echo "2. qBittorrent install"
    echo "3. qBittorrent uninstall"
    echo "4. Back"
    echo "5. Exit"
    echo -n "Please choose an option [1 - 3]: "
}
function smb_mount() {
    /opt/szilardshomelab/menu/4_media/1_SMB_mount/mount_smb.sh
}
function install_qbittorrent() {
    /opt/szilardshomelab/menu/4_media/2_qbittorrent/install_qbittorrent.sh
}
function uninstall_qbittorrent() {
    /opt/szilardshomelab/menu/4_media/3_qbittorrent_uninstall/uninstall_qbittorrent.sh
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            smb_mount
            ;;
        2)
            install_qbittorrent
            ;;
        3)
            uninstall_qbittorrent
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
EOF