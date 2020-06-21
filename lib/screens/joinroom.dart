import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/models/player.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/waitingpage.dart';
import 'package:literature/utils/audio.dart';

// Game communication helper import
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/loader.dart';
import 'package:provider/provider.dart';

class JoinRoom extends StatefulWidget {
  // Initialise AudioPlayer instance
  final AudioController audioController;

  // Passed -> "creategame.dart"
  JoinRoom(this.audioController);

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _roomId = new TextEditingController();
  Player currPlayer;
  List<dynamic> playersList = <dynamic>[];
  bool isLoading = false;
  String playerId;
  @override
  void initState() {
    super.initState();

    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    game.addListener(_joinRoomListener);
  }

  @override
  void dispose() {
    print("Disposing");
    game.removeListener(_joinRoomListener);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _joinRoomListener(Map message) {
    switch (message["action"]) {
      case "set_id":
        // Set the player ID.
        playerId = message["data"]["playerId"];
        Map joinDetails = {
          "roomId": _roomId.text,
          "name": _name.text,
          "playerId": playerId
        };
        game.send("join_game", json.encode(joinDetails));
        break;

      ///
      /// Each time a new player joins, we need to
      ///   * record the new list of players
      ///   * rebuild the list of all the players
      ///
      case "joined":
        setState(() {
          isLoading = false;
        });
        if (playersList.length == 0) {
          playersList = (message["data"])["players"];
          // print(playersList.toString());
          currPlayer = new Player(name: _name.text);
          // Assign the ID of the player
          currPlayer.id = playerId;
        }
        final players = Provider.of<PlayerList>(context, listen: false);
        players.addCurrPlayer(currPlayer);
        players.removeAll();
        List<Player> lp = [];
        for (var player in (message["data"])["players"]) {
          Player p;
          if ((message["data"])["lobbyLeader"]["id"] == player["id"])
            p = new Player(
                name: player["name"], id: player["id"], lobbyLeader: true);
          else
            p = new Player(name: player["name"], id: player["id"]);
          lp.add(p);
        }
        players.addPlayers(lp);
        // force rebuild
        // game.removeListener(_joinRoomListener);

        Navigator.pushReplacementNamed(
          context,
          '/waitingPage',
          arguments: message["data"]["roomId"],
        );
        break;
      case "roomisfull":
        showCustomDialogWithImage(context, "full");
        setState(() {
          isLoading = false;
        });
        break;
      case "invalid room":
        showCustomDialogWithImage(context, "invalid");
        setState(() {
          isLoading = false;
        });
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
            controller: _roomId,
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
    // Connect to the
    // socket.
    game.connect();
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = GlobalAppBar(audioController);
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: appBar,
        body: isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: Loader(),
              )
            : SingleChildScrollView(
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

/// ------------------------
/// Show Dialog for Users
/// ------------------------
void showCustomDialogWithImage(BuildContext context, String arg) {
  Dialog dialogWithImage = Dialog(
    child: Container(
      height: 300.0,
      width: 300.0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue[300],
            ),
            child: Text(
              "SORRY !!!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 200,
            width: 300,
            child: Image.asset(
              (arg == "full") ? 'assets/roomisfull.png' : 'assets/noroom.png',
              fit: BoxFit.scaleDown,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Go To Main Screen',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => dialogWithImage);
}
