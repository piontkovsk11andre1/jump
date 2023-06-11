FROM node:latest

EXPOSE 80

COPY package.json /app/package.json
COPY server.js /app/server.js
WORKDIR /app

RUN npm install

CMD ["npm", "start"]