import express from "express";
import cors from "cors";
import { createServer } from "http";
import socketio from "socket.io";
import { Room, GameStatus, RoomDocument, Player } from "./models/Room";
import mongoose from "mongoose";
import { MONGODB_URI, PORT } from "./util/secrets";
import { divideAndShuffleCards, divideIntoTeams } from "./util/helper";
import { Move } from "./types";

const app = express();
app.use(cors());

mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useCreateIndex: true, useUnifiedTopology: true, useFindAndModify: true }).then(
  () => { /** ready to use. The `mongoose.connect()` promise resolves to undefined. */ },
).catch(err => {
  console.log("MongoDB connection error. Please make sure MongoDB is running. " + err);
  // process.exit();
});

const http = createServer(app);

const io = socketio(http);

app.get("/", function (_req, res) {
  res.send("Hello World");
});
app.set("port", PORT);

let GAME_STATUS = "";
const TURN_INTERVAL = 60000; // 60 seconds.

io.on("connection", (socket) => {
  // On connection, send it's
  // Id to the current player. This
  // Id will be sent on each request.
  // TODO: we may need to associate a
  // session with this ID.
  io.to(socket.id).emit(
    "get_id",
    JSON.stringify({ data: { playerId: socket.id }, action:"set_id" })
  );

  /**
   * Create a game, add a room in db with status "CREATED",
   * send the numerical roomId back in callback 
   * which will be used to join the game
   */
  socket.on("create_game", async function (data) {
    const parsedData = JSON.parse(data);
    const name = parsedData.name;
    const id = parsedData.playerId;

    const newRoom = new Room({
      status: GameStatus.CREATED,
      players: [{ id, name, teamIdentifier: null }],
      lobbyLeader: { id, name, teamIdentifier: null },
    });

    GAME_STATUS = "CREATED";

    await newRoom.save();
    // Create and join the socket room
    socket.join(newRoom.roomId.toString());
    const players = newRoom.players;
    io.to(newRoom.roomId.toString())
      .emit(
        "created",
        JSON.stringify({
          data: { roomId: newRoom.roomId, players: players, lobbyLeader: newRoom.lobbyLeader },
          action: "creates_game"
        })
      );
  });

  /**
   * Add the player to list of players in the room
   * Broadcast to other players about the player joined
   * Send other players details to the player
   */
  socket.on("join_game", async function (data) {
    const parsedData = JSON.parse(data);
    const roomId = parseInt(parsedData.roomId);
    const name = parsedData.name;
    const playerId = parsedData.playerId;
    const room = await Room.findOne({ roomId });
    // The value is not null
    if(room != null){
      if (room.status === GameStatus.CREATED) {
        if(room.players.length < 6){
          const newPlayerId = playerId;
        await Room.update(
          { roomId },
          { $push: { players: { name, id: newPlayerId, teamIdentifier: null } } }
        );
        //Join the room
        socket.join(room.roomId.toString());
        // Send the new room's details, not the old one's
        const updatedRoom = await Room.findOne({ roomId });
        // Send data to the room after it has joined.
        io.to(room.roomId.toString())
          .emit("joined", JSON.stringify({ data: { players: updatedRoom.players, roomId: room.roomId, lobbyLeader: room.lobbyLeader }, action: "joined" }));
        } else {
          io.emit("roomisfull", JSON.stringify({ data: { roomId:roomId }, action: "roomisfull" }));
        }
      } else {
        socket.emit("invalid room",JSON.stringify({data : { roomId: roomId }, action : "invalid room"}));
      } 
    } else {
      socket.emit("invalid room",JSON.stringify({data : { roomId: roomId }, action : "invalid room"}));
    }
  });

    // This function handles the game execution.
    const startGame = async (roomId: number, players: Player[], index: number) => {
      GAME_STATUS = "IN_PROGRESS";
      // Send to player 1 first.
      if (index == -2) {
        // Send to player 1 immediately.
        index = 0;
        io.to(roomId.toString()).emit(
          "whose_turn",
          JSON.stringify({ data: { playerName: players[0]["name"] },
          action: "make_move" })
        );
      }
  
      // Send turn details to others players.
      const timerId = setInterval(function() {
        index += 1;
        io.to(roomId.toString()).emit(
          "whose_turn",
          JSON.stringify({ data: { playerName: players[index]["name"] },
          action: "make_move" })
        );
        if (index >= players.length - 1) {
          index = -1;
        }
        clearTimeout(timerId);
        return startGame(roomId, players, index);
      }, TURN_INTERVAL);
      // Handles a move for each player.
      // Basically we have to swap cards if
      // correct guess, or pass turn if incorrent
      // Also the user can decide to fold.
      // In that case we need to check if game
      // status has been completed.
      io.on("move_ends", async function(data: any) {
        clearTimeout(timerId);
        console.log(data);
        // start next players turn.
        return startGame(roomId, players, index);
      });
    };

  /**
   * Update game status to be IN_PROGRESS(so that room cannot be joined)
   * Make a deck of shuffled cards and return it to everyone in the room
   */
  socket.on("start_game", async function (roomId: number) {
    socket.to(roomId.toString()).emit("game_started", JSON.stringify({ action: "game_started" }));
    const room = await Room.findOneAndUpdate(
      { roomId },
      { status: GameStatus.IN_PROGRESS }
    );
    const playersWithTeamIds = divideIntoTeams(room.players);
    const cards = divideAndShuffleCards();
    // This is a specific room details.
    // and it's connections.
    const socketRoom = io.sockets.adapter.rooms[roomId.toString()];
    let cardIndex = 0;
    Object.keys(socketRoom).map((key: string, index) => {
      if (key === "sockets") {
        Object.keys(socketRoom[key]).map((socketId: string) => {
          // Add an if condition if connection == true
          io.to(socketId).emit(
            "pre_game_data",
            JSON.stringify(
              { 
                data: { cards: cards.slice(cardIndex * 8, cardIndex * 8 + 8),
                  playersWithTeamIds: playersWithTeamIds },
                action: "pre_game_data" 
              })
            );
          cardIndex += 1;
        });
      }
    });
    // Reassign index back to 0.
    // For handling next group of people.
    cardIndex = 0;
    // Since each message to the socket
    // get's spooled we do not need to worry about
    // whether a player is ready or not, cause
    // others will then recieve the request.
    // Send to player 1 first.
    const index = -2;
    startGame(roomId, room.players, index);
  });


});



export default http;