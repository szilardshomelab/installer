#!/bin/bash

# Define the base directory
BASE_DIR="/opt/appdata/traefik"

# Create the necessary directories
mkdir -p ${BASE_DIR}/logs

# Create the acme.json file with the required permissions
touch ${BASE_DIR}/acme.json
chmod 600 ${BASE_DIR}/acme.json

# Prompt the user for their email address and Cloudflare token
read -p "Enter your email address: " EMAIL_ADDRESS
read -p "Enter your Cloudflare token: " CLOUDFLARE_TOKEN

# Define the .env file path
ENV_FILE="/opt/appdata/.env"

# Update or append the EMAIL_ADDRESS and CLOUDFLARE_TOKEN values in the .env file
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
echo "${BASE_DIR}/traefik.yml"
echo "${BASE_DIR}/logs"
echo ".env file has been updated with your email address and Cloudflare token."