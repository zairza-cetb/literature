FROM node:8

WORKDIR /usr/src/app

COPY ./node_server/package*.json ./

RUN npm install

COPY ./node_server .

EXPOSE 3000

CMD ["npm", "start"]
