import express from 'express'
import { createServer } from 'http'
import { server as webSocketServer } from 'websocket'

const port = 34263

const app = express()

const server = createServer(app)

server.listen(port, () => {
  console.log('Connected on PORT: ' + port)
})

const wsServer = new webSocketServer({
  httpServer: server
})

wsServer.on('request', (request) => {
  const connection = request.accept(null, request.origin)
  const player = new Player(request.key, connection)
})

function Player(id, connection) {
  this.id = id;
  this.connection = connection;
  this.name = "";
  this.opponentIndex = null;
  this.index = Players.length;
  this.gameCreator = null;
}

let Players = [];
