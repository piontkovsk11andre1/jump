FROM verdaccio/verdaccio:latest

# Install plugin for user authentication
USER root
RUN npm install -g verdaccio-auth-memory

# Get back to default verdaccio user
USER $VERDACCIO_USER_UID