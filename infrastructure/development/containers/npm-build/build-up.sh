#!/bin/sh

REGISTRY_URL=http://verdaccio:4873/

# Ping registry before build
npm ping --registry http://verdaccio:4873/ || exit 1

# Install packages using the local registry
npm install --registry $REGISTRY_URL
npm audit fix --registry $REGISTRY_URL

echo "Waiting for changes in modules: $PROBE_UPDATES"

# Make the build
npm run build

# Check for package updates
if [ -n "$PROBE_UPDATES" ]; then
  # Start health-server to monitor service's state
  serve -l 8080 /opt/monitoring >/dev/null &
  echo "Monitoring server is up..."
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
    # Rebuild package on updates
    if [ $PACKAGE_UPDATED == 1 ]; then
      echo "Package updated, rebuilding..."
      npm run build
    fi
    sleep 5
  done
else
  # Start health-server to monitor service's state
  echo "Start monitoring server..."
  serve -l 8080 /opt/monitoring >/dev/null
fi