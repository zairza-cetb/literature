import express from 'express'
import { createServer } from 'http'
import socketio from 'socket.io'
import { Room, GameStatus } from './models/Room'
import mongoose from 'mongoose'
import { MONGODB_URI, PORT } from './util/secrets'

const app = express()

mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useCreateIndex: true, useUnifiedTopology: true, useFindAndModify: true } ).then(
  () => { /** ready to use. The `mongoose.connect()` promise resolves to undefined. */ },
).catch(err => {
  console.log("MongoDB connection error. Please make sure MongoDB is running. " + err);
  // process.exit();
});

const http = createServer(app)

const io = socketio(http)

app.get('/', function(req, res) {
  res.send("Hello World")
})
app.set('port', PORT)

io.on('connection', (socket) => {
  /**
   * Create a game, add a room in db with status "CREATED",
   * send the numerical roomId back in callback 
   * which will be used to join the game
   */
  socket.on('create_game', async function(name, id, callback) {
    const newRoom = new Room({
      status: GameStatus.CREATED,
      players: [{id, name}]
    })
    await newRoom.save()
    // Create and join the socket room
    socket.join(newRoom.roomId.toString())
    callback(newRoom.roomId)
  })

  /**
   * Add the player to list of players in the room
   * Broadcast to other players about the player joined
   * Send other players details to the player
   */
  socket.on('join_game', async function(roomId, name, id) {
    const room = await Room.findOne({roomId})
    if(room.status === GameStatus.CREATED) {
      await Room.update(
        { roomId },
        { $push: { players: { name, id }}}
      )
      // Send new player details to every other player in the room
      socket.to(room.roomId.toString()).emit('new player', name)
      // Send other player details to the player
      socket.emit('joined', room.players)
      //Join the room
      socket.join(room.roomId.toString())
    } else {
      socket.emit('invalid room')
    }
  })
})

export default app