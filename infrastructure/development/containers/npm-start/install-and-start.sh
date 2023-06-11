#!/bin/sh

REGISTRY_URL=http://verdaccio:4873/

# Current entrypoint script args
NPM_START_ARGS=$@

# Install packages using the local registry
npm install --registry $REGISTRY_URL
npm audit fix --registry $REGISTRY_URL

# Start the process
if [ -n "$ECOSYSTEM_MODE" ]; then
  echo "Starting the process in ecosystem mode..."
  pm2 start --no-autorestart ecosystem.config.js
else
  echo "Starting the process in NPM start mode..."
  pm2 start --no-autorestart --time --attach "npm start -- $NPM_START_ARGS"
fi

# Check for package updates
if [ -n "$PROBE_UPDATES" ]; then
  # Stream logs to stdout
  pm2 logs &
  # Perform update checks
  echo "Waiting for changes in $PROBE_UPDATES modules..."
  while true; do
    PACKAGE_UPDATED=0
    # Check for updates of packages listed in the PROBE_UPDATES environment variable
    for PACKAGE_NAME in $PROBE_UPDATES; do
      LATEST_VERSION=$(npm show --registry $REGISTRY_URL $PACKAGE_NAME version)
      INSTALLED_VERSION=$(npm list --registry $REGISTRY_URL $PACKAGE_NAME | grep $PACKAGE_NAME | awk '{print $2}' | sed 's/[^0-9.]*//g')
      # If there is a newer version available, update the package
      if [ "$LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
        echo "Updating $PACKAGE_NAME from $INSTALLED_VERSION to $LATEST_VERSION"
        npm install --registry $REGISTRY_URL --save $PACKAGE_NAME@latest
        PACKAGE_UPDATED=1
      fi
    done
    if [[ $PACKAGE_UPDATED == 1 ]]; then
      if [ -z "$DO_NOT_RESTART" ]; then
        echo "Restarting the process..."
        pm2 restart all
      fi
    fi
    sleep 5
  done
else
  # Stream logs to stdout
  pm2 logs
fi