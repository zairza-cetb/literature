import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:literature/utils/websocket.dart';

///
/// Global variable, the whole class is 
/// accessible through this variable.
///
GameCommunication game = new GameCommunication();

class GameCommunication {
  static final GameCommunication _game = new GameCommunication._internal();

  ///
  /// At first initialization, the player has not yet provided any name
  ///
  String _playerName = "";

  ///
  /// Before the "join" action, the player has no unique ID
  ///
  String _playerID = "";

  /// Reuse the same instance of 
  /// the class using "factory" identifier.
  factory GameCommunication(){
    return _game;
  }

  // Private Constructor for the class.
  GameCommunication._internal(){
    ///
    /// Let's initialize the WebSockets communication
    ///
    socket.initCommunication();
  }

  /// ----------------------------------------------------------
  /// Common method to send requests to the server
  /// ----------------------------------------------------------
  send(String action, String data){
    ///
    /// When a player joins, we need to record the name
    /// he provides
    ///
    if (action == 'join'){
      _playerName = data;
    }

    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON 
    ///
    socket.send(action, data);
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback){
    socket.addListener(callback);
  }
  removeListener(Function callback){
    socket.removeListener(callback);
  }
}
