import 'dart:typed_data';

import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  // Is the player the lobbyLeader
  bool lobbyLeader;
  // Name of the player
  String name;
  // ID of a player
  String id;
  bool teamLeader;
  // Team identifier
  String teamIdentifier;

  // Constructor
  Player({
    this.lobbyLeader = false,
    @required this.name,
    this.id,
    this.teamIdentifier,
    this.teamLeader = false
  });

}
