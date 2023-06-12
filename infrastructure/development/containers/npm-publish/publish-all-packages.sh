#!/bin/sh

# Indicate that monitoring server is up
HEALTH_CHECK_SERVER=0

# NPM user credentials
USERNAME=local-admin
PASSWORD=root
EMAIL=admin@local.npm

# Authorize local repository account (or exit)
/usr/bin/expect <<EOD
spawn npm adduser --registry http://verdaccio:4873/
expect {
  "Username:" {send "$USERNAME\r"; exp_continue}
  "Password:" {send "$PASSWORD\r"; exp_continue}
  "Email: (this IS public)" {send "$EMAIL\r"; exp_continue}
  eof
}
EOD

# Check if npm is authorized
AUTHORIZED_USER=$(npm whoami --registry http://verdaccio:4873/ 2>/dev/null)

if [ -n "$AUTHORIZED_USER" ]; then
  echo "npm is authorized for user: $AUTHORIZED_USER"
else
  echo "npm is not authorized"
  exit 1
fi

# Publish initial (current) version to the local repo
while true; do
  for package in /packages/*; do
    cd "$package"
    # Get remote and local versions of the package
    CURRENT_PACKAGE_NAME=$(cat $package/package.json | jq -r '.name')
    CURRENT_VERSION=$(cat $package/package.json | jq -r '.version')
    PUBLISHED_VERSION=$(npm --registry http://verdaccio:4873/ view $CURRENT_PACKAGE_NAME version)
    # If package was updated re-publish it in the repo
    if [ "$PUBLISHED_VERSION" != "$CURRENT_VERSION" ]; then
      echo "Package: $CURRENT_PACKAGE_NAME"
      echo "Version (actual): $CURRENT_VERSION"
      echo "Version (published): $PUBLISHED_VERSION"
      npm publish --registry http://verdaccio:4873/
    fi
  done
  # On first iteration set up the monitoring server
  if [ $HEALTH_CHECK_SERVER == 0 ]; then
    # Start health-server to monitor service's state
    serve -l 8080 /opt/monitoring >/dev/null &
    echo "Monitoring server is up..."
    HEALTH_CHECK_SERVER=1
  fi
  sleep 5
done