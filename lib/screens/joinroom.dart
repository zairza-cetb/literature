import 'package:flutter/material.dart';
import 'package:literature/screens/waitingpage.dart';

// Game communication helper import
import 'package:literature/utils/game_communication.dart';

class JoinRoom extends StatefulWidget {
  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _roomID = new TextEditingController();
  String playerName;
  List<dynamic> playersList = <dynamic>[];

  @override
  void initState() {
    super.initState();
    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _onGameDataReceived(message) {
    switch (message["action"]) {
      ///
      /// Each time a new player joins, we need to
      ///   * record the new list of players
      ///   * rebuild the list of all the players
      ///
      case "players_list":
        playersList = message["data"];
        
        // force rebuild
        setState(() {});
        break;
    }
  }

  Widget _joinGame() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter your name...',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          new TextField(
            controller: _roomID,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter Room ID...',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: _onJoinGame,
              child: new Text('Join'),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Sends a message to server on room join request
  ///
  _onJoinGame() {
    game.send('join', _name.text);

    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) 
                  => new WaitingPage(
                      playersList: playersList,
                      opponentName: _name.text, 
                      character: 'X',
                      role: 'X',
                    ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Literature'),
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // _buildJoin(),
              _joinGame(),
              // _playersList(),
            ],
          ),
        ),
      ),
    );
  }
}
