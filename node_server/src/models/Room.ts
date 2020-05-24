import mongoose from "mongoose";
import autoIncrement from "mongoose-auto-increment";
import { MONGODB_URI } from "../util/secrets";

const connection = mongoose.createConnection(MONGODB_URI);
autoIncrement.initialize(connection);

export type Player = {
  name: string;
  id: string;
  teamIdentifier: string;
}

export enum GameStatus {
  CREATED = "CREATED",
  IN_PROGRESS = "IN_PROGRESS",
  COMPLETED = "COMPLETED"
}

export type RoomDocument = mongoose.Document & {
  roomId: string;
  players: Player[];
  status: GameStatus;
  lobbyLeader: Player;
}

const roomSchema = new mongoose.Schema({
  players: [{
    _id: false,
    id: String,
    name: String,
    teamIdentifier: String,
  }],
  status: String,
  lobbyLeader: {
    id: String,
    name: String
  },
  roomId: String,
});

// roomSchema.plugin(autoIncrement.plugin, { model: "Room", field: "roomId"});

export const Room = mongoose.model<RoomDocument>("Room", roomSchema);