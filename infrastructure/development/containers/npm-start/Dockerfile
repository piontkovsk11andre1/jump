FROM node:alpine

VOLUME [ "/workdir" ]
WORKDIR /workdir

EXPOSE 9229

RUN npm i -g pm2

COPY install-and-start.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]