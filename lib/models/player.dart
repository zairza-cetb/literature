import 'package:flutter/material.dart';

class Player {
  // Is the player the lobbyLeader
  bool lobbyLeader;
  // Name of the player
  String name;

  // Constructor
  Player({
    this.lobbyLeader = false,
    @required this.name,
  });
}
