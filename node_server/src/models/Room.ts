import mongoose from "mongoose";
import autoIncrement from "mongoose-auto-increment";
import { MONGODB_URI } from "../util/secrets";

const connection = mongoose.createConnection(MONGODB_URI);
autoIncrement.initialize(connection);

type Player = {
  name: string;
  id: number;
}

export enum GameStatus {
  CREATED = "CREATED",
  IN_PROGRESS = "IN_PROGRESS",
  COMPLETED = "COMPLETED"
}

export type RoomDocument = mongoose.Document & {
  roomId: number;
  players: Player[];
  status: GameStatus;
  lobbyLeader: Player;
}

const roomSchema = new mongoose.Schema({
  players: [{
    _id: false,
    id: Number,
    name: String
  }],
  status: String,
  lobbyLeader: {
    id: Number,
    name: String
  }
});

roomSchema.plugin(autoIncrement.plugin, { model: "Room", field: "roomId"});

export const Room = mongoose.model<RoomDocument>("Room", roomSchema);