
# Prompt the user to confirm installation
while true; do
    read -p "Are you sure you want to create Cloudflare-Tunnel? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) break;;   # If 'y' or 'Y' is input, proceed
        [nN]* ) echo "Installation aborted."; exit 1;;  # If 'n' or 'N' is input, exit
        * ) echo "Please choose 'y' or 'n'."; # If not 'y' or 'n', prompt again
    esac
done
# Prompt for user input
read -p "Enter your domain (e.g., example.com): " DOMAIN
read -p "Enter the reverse proxy IP (e.g., 127.0.0.1): " REVERSE_PROXY_IP
read -p "Enter the reverse proxy port (e.g., 8000): " REVERSE_PROXY_PORT
read -p "Enter the tunnel name: " TUNNEL_NAME

CONFIG_DIR="/opt/appdata/cloudflared"
ENV_FILE="/opt/appdata/.env"
DOCKER_COMPOSE_FILE="docker-compose.yml"
mkdir -p $CONFIG_DIR
chmod -R 777 $CONFIG_DIR




# Log in to Cloudflare and create the tunnel
docker run -v $CONFIG_DIR:/home/nonroot/.cloudflared cloudflare/cloudflared:latest tunnel login

# Create the tunnel
docker run -v $CONFIG_DIR:/home/nonroot/.cloudflared cloudflare/cloudflared:latest tunnel create $TUNNEL_NAME

TUNNEL_ID=$(basename *.json .json)

# Function to update or append environment variables
update_or_append_env_var() {
  local var_name=$1
  local var_value=$2
  local file=$3
  if grep -q "^${var_name}=" "$file"; then
    sed -i "s|^${var_name}=.*|${var_name}=${var_value}|" "$file"
  else
    echo "${var_name}=${var_value}" >> "$file"
  fi
}

# Update or append environment variables
update_or_append_env_var "DOMAIN" "$DOMAIN" "$ENV_FILE"
update_or_append_env_var "REVERSE_PROXY_IP" "$REVERSE_PROXY_IP" "$ENV_FILE"
update_or_append_env_var "REVERSE_PROXY_PORT" "$REVERSE_PROXY_PORT" "$ENV_FILE"
update_or_append_env_var "TUNNEL_NAME" "$TUNNEL_NAME" "$ENV_FILE"
update_or_append_env_var "TUNNEL_ID" "$TUNNEL_ID" "$ENV_FILE"

# Source the environment variables from the .env file
set -o allexport
source $ENV_FILE
set -o allexport

# Create the config.yml file
cat <<EOF > $CONFIG_DIR/config.yml
tunnel: $TUNNEL_ID
credentials-file: /home/nonroot/.cloudflared/$TUNNEL_ID.json

ingress:
  - hostname: $DOMAIN
    service: https://$REVERSE_PROXY_IP:$REVERSE_PROXY_PORT
  - service: http_status:404
EOF

ENV_FILE2="/opt/appdata/.network.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/cloudflared/compose-template.yml"
touch /opt/appdata/cloudflared/compose.yml
OUTPUT_FILE="/opt/appdata/cloudflared/compose.yml"

# Load environment variables from the .env file
export $(grep -v '^#' $ENV_FILE2 | xargs)

# Substitute variables in the template and generate the docker-compose.yml
sed "s/__DOCKER_NETWORK_NAME__/${DOCKER_NETWORK_NAME}/g" $TEMPLATE_FILE > $OUTPUT_FILE

# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE --env-file /opt/appdata/.env up -d
echo "Configuration complete. You can now start the tunnel with 'docker-compose up -d'."

# Check if the Docker Compose command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to start cloudflare-tunnel!"
  exit 1
fi
