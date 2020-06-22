import express from "express";
import cors from "cors";
import { createServer } from "http";
import socketio from "socket.io";
import { Room, GameStatus, RoomDocument, Player } from "./models/Room";
import mongoose from "mongoose";
import { MONGODB_URI, PORT } from "./util/secrets";
import { divideAndShuffleCards, divideIntoTeams } from "./util/helper";
import { Move } from "./types";

const shortid = require('shortid');

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

// ================
// CONSTANTS
// ================
let GAME_STATUS = ""; // 60 seconds.
let handleTurns = new Map<number, string>();

io.on("connection", (socket) => {
  // On connection, send it's
  // Id to the current player. This
  // Id will be sent on each request.
  // TODO: we may need to associate a
  // session with this ID.
  io.to(socket.id).emit(
    "get_id",
    JSON.stringify({ data: { playerId: socket.id }, action: "set_id" })
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
    const roomId = shortid.generate();
    const newRoom = new Room({
      status: GameStatus.CREATED,
      players: [{ id, name, teamIdentifier: null }],
      lobbyLeader: { id, name, teamIdentifier: null },
      roomId: roomId
    });
    GAME_STATUS = "CREATED";
    try {
      await newRoom.save();
    } catch (e) {
      console.log(e);
    }
    // Create and join the socket room
    console.log(newRoom.roomId);
    socket.join(newRoom.roomId);
    const players = newRoom.players;
    io.to(newRoom.roomId)
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
    const roomId = parsedData.roomId;
    const name = parsedData.name;
    const playerId = parsedData.playerId;
    const room = await Room.findOne({ roomId });
    // The value is not null
    if (room != null) {
      if (room.status === GameStatus.CREATED) {
        if (room.players.length < 6) {
          const newPlayerId = playerId;
          await Room.update(
            { roomId },
            { $push: { players: { name, id: newPlayerId, teamIdentifier: null } } }
          );
          //Join the room
          socket.join(room.roomId);
          // Send the new room's details, not the old one's
          const updatedRoom = await Room.findOne({ roomId });
          // Send data to the room after it has joined.
          io.to(room.roomId)
            .emit("joined", JSON.stringify({ data: { players: updatedRoom.players, roomId: room.roomId, lobbyLeader: room.lobbyLeader }, action: "joined" }));
        } else {
          io.emit("roomisfull", JSON.stringify({ data: { roomId: roomId }, action: "roomisfull" }));
        }
      } else {
        socket.emit("invalid room", JSON.stringify({ data: { roomId: roomId }, action: "invalid room" }));
      }
    } else {
      socket.emit("invalid room", JSON.stringify({ data: { roomId: roomId }, action: "invalid room" }));
    }
  });

  /**
   * Update game status to be IN_PROGRESS(so that room cannot be joined)
   * Make a deck of shuffled cards and return it to everyone in the room
   */
  socket.on("start_game", async function (roomId: string) {
    socket.to(roomId).emit("game_started", JSON.stringify({ action: "game_started" }));
    const room = await Room.findOneAndUpdate(
      { roomId },
      { status: GameStatus.IN_PROGRESS }
    );
    const playersWithTeamIds = divideIntoTeams(room.players);
    const cards = divideAndShuffleCards();
    // This is a specific room details.
    // and it's connections.
    const socketRoom = io.sockets.adapter.rooms[roomId];
    let cardIndex = 0;
    Object.keys(socketRoom).map((key: string, index) => {
      if (key === "sockets") {
        Object.keys(socketRoom[key]).map((socketId: string) => {
          // Add an if condition if connection == true
          io.to(socketId).emit(
            "pre_game_data",
            JSON.stringify(
              {
                data: {
                  cards: cards.slice(cardIndex * 8, cardIndex * 8 + 8),
                  playersWithTeamIds: playersWithTeamIds
                },
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
    // The logic  is that we make a map
    // of all the players and iterate through the
    // indexes on each request of player turns.
    let index = 0;
    for (let player of room.players) {
      handleTurns.set(index++, player["name"]);
    }
    // Initiator -> send to player 1 immediately.
    io.to(roomId.toString()).emit(
      "whose_turn",
      JSON.stringify({
        data: { playerName: handleTurns.get(0) },
        action: "make_move"
      })
    );
  });

  // Passes a player's turn.
  socket.on("finished_turn", async (data: any) => {
    const parsedData = JSON.parse(data);
    const roomId = parsedData.roomId;
    const name = parsedData.name;
    let playerIndex;
    console.log(name + " has finished turn...");
    handleTurns.forEach((n, index) => {
      if (n === name) {
        playerIndex = index;
      }
    });
    if (playerIndex === handleTurns.size - 1) {
      playerIndex = -1;
    }
    io.to(roomId).emit(
      "whose_turn",
      JSON.stringify({
        data: { playerName: handleTurns.get(++playerIndex) },
        action: "make_move"
      })
    );
  })

  // Handles a player's card asking event.
  // We broadcast that even to the room, then if the
  // recipient has the card he generates another event.
  socket.on("card_asking_event", async (data: any) => {
    const parsedData = JSON.parse(data);
    const { whoAsked, askingTo, roomId, cardSuit, cardType } = parsedData;
    io.to(roomId).emit(
      "do_you_have_this_card",
      JSON.stringify({
        data: { inquirer: whoAsked, recipient: askingTo, cardSuit: cardSuit, cardType: cardType },
        action: "send_card_on_request"
      }),
    );
  });

  // Handles the event if a card should be transferred from a person
  // or not. Have to send a message nevertheless to show if the guess
  // was correct or not in the arena.
  socket.on("card_transfer", async (payload) => {
    const parsedData = JSON.parse(payload);
    const { cardSuit, cardType, from, recipient, roomId, result } = parsedData;
    io.to(roomId).emit(
      "card_transfer_result",
      JSON.stringify({
        data: { inquirer: from, recipient, cardSuit, cardType, result },
        action: "card_transfer_result"
      })
    );
  });

  // So, the user can submitted a fold request. We would first use
  // server to check against all the users.
  socket.on("folding_result_initial", async (payload) => {
    const parsedData = JSON.parse(payload);
    const { roomId, foldedResults } = parsedData;
    // console.log(parsedData);
    io.to(roomId).emit(
      "folding_result_verification",
      JSON.stringify({
        // Array of selections.
        data: foldedResults,
        action: "verify_for_folding_authenticity"
      }),
    );
  });

  // When a user sends a confirmation result, broadcast to change
  // the foldState for a user emitting this message.
  socket.on("folding_confirmation", async (data) => {
    const parsedData = JSON.parse(data);
    const { roomId, name, confirmation, forWhichCards, whoAsked } = parsedData;
    io.to(roomId).emit(
      "folding_confirmation_recieved",
      JSON.stringify({
        data: { whoAsked, name, confirmation, forWhichCards },
        action: "update_foldState",
      }),
    );
  });

  socket.on("player_remove_clicked", async (data) => {
    // Map playerDetails =  {"roomId": widget.roomId, "name": playerInfo.name, "playerId": playerInfo.id};
    const parsedData = JSON.parse(data);
    const roomId = parsedData.roomId;
    const playerName = parsedData.name;
    const playerId = parsedData.playerId;
    const room = await Room.findOne({ roomId });

    if (room != null) {
      if (room.status === GameStatus.CREATED) {
        await Room.update(
          { roomId },
          { $pull: { players: { name: playerName, id: playerId } } }
        );
      }
    }
    //Join the room
    socket.join(room.roomId);
    // Send the new rooom's details 
    const updatedRoom = await Room.findOne({ roomId });

    io.to(room.roomId)
      .emit("joined",
        JSON.stringify({ data: { players: updatedRoom.players, roomId: room.roomId, lobbyLeader: room.lobbyLeader }, action: "player_removed" }));
  });

  socket.on('remove_room', async (data) => {
    const parsedData = JSON.parse(data);
    const roomId = parsedData.roomId;
    const room = await Room.findOne({ roomId });
    if (room != null) {
      if (room.status === GameStatus.CREATED) {
        await Room.update({ roomId }, { $set: { status: GameStatus.COMPLETED } });
      }
    }
  });
});



export default http;