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

  // Profile Pic
  String photoURL;

  // Constructor
  Player({
    this.lobbyLeader = false,
    @required this.name,
    this.id,
    this.teamIdentifier,
    this.photoURL = "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    this.teamLeader = false
  });

}
