import express from "express";
import cors from "cors";
import { createServer } from "http";
import socketio from "socket.io";
import { Room, GameStatus } from "./models/Room";
import mongoose from "mongoose";
import { MONGODB_URI, PORT } from "./util/secrets";
import { divideAndShuffleCards } from "./util/helper";
import { Move } from "./types";

const app = express();
app.use(cors());

mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useCreateIndex: true, useUnifiedTopology: true, useFindAndModify: true } ).then(
  () => { /** ready to use. The `mongoose.connect()` promise resolves to undefined. */ },
).catch(err => {
  console.log("MongoDB connection error. Please make sure MongoDB is running. " + err);
  // process.exit();
});

const http = createServer(app);

const io = socketio(http);

app.get("/", function(req, res) {
  res.send("Hello World");
});
app.set("port", PORT);

io.on("connection", (socket) => {
  /**
   * Create a game, add a room in db with status "CREATED",
   * send the numerical roomId back in callback 
   * which will be used to join the game
   */
  socket.on("create_game", async function(name: string, id: string) {
    const newRoom = new Room({
      status: GameStatus.CREATED,
      // TODO: Id is always null
      players: [{id, name}]
    });
    await newRoom.save();
    // Create and join the socket room
    socket.join(newRoom.roomId.toString());
    const players = newRoom.players;
    io.to(newRoom.roomId.toString())
      .emit(
        "created", 
        JSON.stringify({ 
          data: {roomId: newRoom.roomId, players: players, name: name}, 
          action: 'creates_game' 
        })
      );
  });

  /**
   * Add the player to list of players in the room
   * Broadcast to other players about the player joined
   * Send other players details to the player
   */
  socket.on("join_game", async function(data) {
    let parsedData = JSON.parse(data);
    const roomId = parseInt(parsedData.roomId);
    const name = parsedData.name;
    const room = await Room.findOne({roomId});
    if(room.status === GameStatus.CREATED) {
      await Room.update(
        { roomId },
        { $push: { players: { name }}}
      );
      //Join the room
      socket.join(room.roomId.toString());
      // Send data to the room after it has joined.
      io.to(room.roomId.toString())
        .emit("joined", JSON.stringify({ data: { players: room.players, roomId: room.roomId }, action: "joined" }));
    } else {
      socket.emit("invalid room");
    }
  });

  /**
   * Update game status to be IN_PROGRESS(so that room cannot be joined)
   * Make a deck of shuffled cards and return it to everyone in the room
   */
  socket.on("start_game", async function(roomId: number) {
    await Room.findOneAndUpdate(
      {roomId},
      {status: GameStatus.IN_PROGRESS}
    );
    const cards = divideAndShuffleCards();
    socket.to(roomId.toString()).emit("get_cards", cards);
  });

  /**
   * On making a card request send the request details
   * to all the players to check whether the request is
   * valid or not
   */
  socket.on("request_card", async function(roomId: number, move: Move ) {
    socket.to(roomId.toString()).emit("check_card", move);
  });
});



export default http;