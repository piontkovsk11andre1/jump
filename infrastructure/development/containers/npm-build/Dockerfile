FROM node:alpine

VOLUME [ "/workdir" ]
WORKDIR /workdir

COPY build-up.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Prepare simple http server for /health endpoint
RUN npm i -g serve
RUN mkdir /opt/monitoring && echo '{"result": "ok"}' > /opt/monitoring/health

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]