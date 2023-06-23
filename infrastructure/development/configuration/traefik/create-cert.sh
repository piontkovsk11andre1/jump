#!/bin/sh

# Create new cert & key files
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout local.key -out local.cert -subj "/CN=application.vngn" \
  -addext "subjectAltName=DNS:*.application.vngn"

# Create new pem file to import in the browser
cat local.cert local.key > ../../../local.certificate.$(date +"%Y-%m-%d_%H-%M-%S").pem

# chrome://settings/certificates