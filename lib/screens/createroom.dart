import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/models/player.dart';
import 'package:literature/screens/waitingpage.dart';
import 'package:literature/utils/audio.dart';

// Game communication helper import
import 'package:literature/utils/game_communication.dart';

class CreateRoom extends StatefulWidget {
  // Initialise AudioPlayer instance
  final AudioController audioController;
  // Passed -> "creategame.dart"
  CreateRoom(this.audioController);
  
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  static final TextEditingController _name = new TextEditingController();
  Player currPlayer;
  List<dynamic> playersList = <dynamic>[];
  // TODO: Room ID should be a hashed value
  int roomId;

  @override
  void initState() {
    super.initState();
    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    game.addListener(_createRoomListener);
  }

  @override
  void dispose() {
    game.removeListener(_createRoomListener);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _createRoomListener(Map message) {
    switch (message["action"]) {
      ///
      /// Creates a new game with a Room ID, Redirect to
      /// waiting page and wait for other players in 
      /// the lobby.
      ///
      case 'creates_game':
        playersList = (message["data"])["players"];
        roomId = (message["data"])["roomId"];
        // Validates if actually the player created the room,
        // Need username matching in the db for any room. 
        currPlayer = new Player(name: _name.text, lobbyLeader: (message["data"]["lobbyLeader"])["name"] == _name.text ? true : false );
        Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) 
                  => WaitingPage(
                    currPlayer: currPlayer,
                    playersList: playersList,
                    roomId: roomId.toString(),
                  ),
        ));
    }
  }

  ///
  /// Form to create a new game
  ///
  Widget _createNewGame() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter your name',
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
              onPressed: _onCreateGame,
              child: new Text('Create Game'),
            ),
          ),
        ],
      ),
    );
  }

  /// -----------------------------------------
  /// Sends a create game signal to the server
  /// -----------------------------------------
  _onCreateGame() {
    // Send a message to server to create a new game
    // and then move to join room page
    game.send("create_game", _name.text);

    // Forces a rebuild
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appBar = GlobalAppBar(audioController);
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createNewGame(),
            ],
          ),
        ),
      ),
    );
  }
}
