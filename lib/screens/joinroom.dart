import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/models/player.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/waitingpage.dart';

// Game communication helper import
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/loader.dart';
import 'package:provider/provider.dart';

class JoinRoom extends StatefulWidget {
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
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => WaitingPage(
                roomId: message["data"]["roomId"],
              ),
            ));
        break;
      case "roomisfull":
        showAnimateDialogBox(context, "full");
        game.disconnect();
        setState(() {
          isLoading = false;
        });
        break;
      case "invalid room":
        showAnimateDialogBox(context, "invalid");
        game.disconnect();
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
    var appBar = GlobalAppBar();
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
void showAnimateDialogBox(BuildContext context, String arg) {
  AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        btnOkColor: Colors.red,
        title: (arg == "full") ? 'Room is Full' : 'Invalid Room',
        desc: (arg == "full")
            ? 'The Room you have requested to join is already full.'
            : 'The Room you have requested to join doesn\'t exist.',
        btnOkOnPress: () {},
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        useRootNavigator: false)
      ..show();
}
