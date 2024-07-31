#!/bin/bash

# Prompt the user to confirm installation
while true; do
    read -p "Are you sure you want to install Traefik? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) break;;   # If 'y' or 'Y' is input, proceed
        [nN]* ) echo "Installation aborted."; exit 1;;  # If 'n' or 'N' is input, exit
        * ) echo "Please choose 'y' or 'n'."; # If not 'y' or 'n', prompt again
    esac
done

# Define the base directory
BASE_DIR="/opt/appdata/traefik"

# Create the necessary directories
mkdir -p ${BASE_DIR}/logs

touch ${BASE_DIR}/config.yml
# Create the acme.json file with the required permissions
touch ${BASE_DIR}/acme.json
chmod 600 ${BASE_DIR}/acme.json

# Prompt the user for their email address, Cloudflare token, and domain
read -p "Enter your email address: " EMAIL_ADDRESS
read -p "Enter your Cloudflare token: " CLOUDFLARE_TOKEN
read -p "Enter your domain name: " DOMAIN_NAME

# Define the .env file path
ENV_FILE="/opt/appdata/.env"

# Update or append the EMAIL_ADDRESS, CLOUDFLARE_TOKEN, and DOMAIN_NAME values in the .env file
if grep -q "^TRAEFIK_EMAIL=" ${ENV_FILE}; then
    sed -i "s/^TRAEFIK_EMAIL=.*/TRAEFIK_EMAIL=${EMAIL_ADDRESS}/" ${ENV_FILE}
else
    echo "TRAEFIK_EMAIL=${EMAIL_ADDRESS}" >> ${ENV_FILE}
fi

if grep -q "^CLOUDFLARE_TOKEN=" ${ENV_FILE}; then
    sed -i "s/^CLOUDFLARE_TOKEN=.*/CLOUDFLARE_TOKEN=${CLOUDFLARE_TOKEN}/" ${ENV_FILE}
else
    echo "CLOUDFLARE_TOKEN=${CLOUDFLARE_TOKEN}" >> ${ENV_FILE}
fi

if grep -q "^DOMAIN_NAME=" ${ENV_FILE}; then
    sed -i "s/^DOMAIN_NAME=.*/DOMAIN_NAME=${DOMAIN_NAME}/" ${ENV_FILE}
else
    echo "DOMAIN_NAME=${DOMAIN_NAME}" >> ${ENV_FILE}
fi

# Create and populate the traefik.yml file
cat <<EOL > ${BASE_DIR}/traefik.yml
api:
  dashboard: true
  debug: true
entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: https
          scheme: https
  https:
    address: ":443"
serversTransport:
  insecureSkipVerify: true
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    filename: /config.yml
certificatesResolvers:
  cloudflare:
    acme:
      email: ${EMAIL_ADDRESS}
      storage: acme.json
      dnsChallenge:
        provider: cloudflare
        #disablePropagationCheck: true # uncomment this if you have issues pulling certificates through cloudflare, By setting this flag to true disables the need to wait for the propagation of the TXT record to all authoritative name servers.
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
EOL

# Notify the user that the files have been created and the .env file has been updated
echo "Files and directories have been created successfully:"
echo "${BASE_DIR}/acme.json (permissions: 600)"
echo "${BASE_DIR}/config.yml"
echo "${BASE_DIR}/traefik.yml"
echo "${BASE_DIR}/logs"
echo ".env file has been updated with your email address, Cloudflare token, and domain name."

ENV_FILE="/opt/appdata/.network.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/traefik/compose-template.yml"
touch /opt/appdata/traefik/compose.yml
OUTPUT_FILE="/opt/appdata/traefik/compose.yml"

# Load environment variables from the .env file
export $(grep -v '^#' $ENV_FILE | xargs)

# Substitute variables in the template and generate the docker-compose.yml
sed "s/__DOCKER_NETWORK_NAME__/${DOCKER_NETWORK_NAME}/g" $TEMPLATE_FILE > $OUTPUT_FILE

# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE --env-file /opt/appdata/.env up -d

# Check if the Docker Compose command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to start Traefik service"
  exit 1
fi

echo "Traefik service started successfully"

#Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Assuming Portainer is exposed on port 8989
traefik_PORT=8090

# Construct the access URL
ACCESS_URL="http://$SERVER_IP:$traefik_PORT"

echo "Access Traefik Dashboard at: $ACCESS_URL"
echo "Default username : admin"
echo "Default password : password"