import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
// Game communication helper import
import 'package:literature/utils/game_communication.dart';
// Start Game page
import 'package:literature/screens/startgame.dart';

class WaitingPage extends StatefulWidget {
  WaitingPage({
    Key key,
    this.currPlayer,
    this.playersList,
    this.roomId,
  }): super(key: key);

  ///
  /// Name of the opponent
  ///
  final Player currPlayer;

  ///
  ///
  ///
  List<dynamic> playersList;

  ///
  /// RoomId
  ///
  final String roomId;

  _WaitingPageState createState() => _WaitingPageState();
}

// Should contain a form of Room ID and
// Player name to join.
class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    super.initState();
    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    // game.addListener(_onGameDataReceived);
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
      case "joined":
        widget.playersList = (message["data"])["players"];
        
        // force rebuild
        setState(() {});
        break;
    }
  }

  /// --------------------------------------------------------------
  /// We launch a new Game, we need to:
  ///    * send the action "new_game", together with the ID
  ///      of the opponent we choosed
  ///    * redirect to the game
  ///      As we are the game initiator, we will play with the "X"
  /// --------------------------------------------------------------
  _onPlayGame(String opponentName, String opponentId, context){
    // We need to send the opponentId to initiate a new game
    game.send('new_game', opponentId);
	
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) 
                  => new StartGame(
                      opponentName: opponentName, 
                      character: 'X',
                    ),
    ));
  }

  _getPlayButton(_numberOfPlayers, playerInfo) {
    if (_numberOfPlayers > 6) {
      return new RaisedButton(
        onPressed: (){
          _onPlayGame(playerInfo["name"], playerInfo["id"], context);
        },
        child: new Text('Play'),
      );
    } else {
      return new Text("....");
    }
  }

  // ------------------------------------------------------
  /// Builds the list of players
  /// ------------------------------------------------------
  Widget _playersList(context) {
    ///
    /// If the user has not yet joined, do not display
    /// the list of players
    ///
    // if (game.playerName == "") {
    //   return new Container();
    // }

    ///
    /// Display the list of players.
    /// For each of them, put a Button that could be used
    /// to launch a new game, if it is an admin then only set
    /// play option.
    ///
    var _numberOfPlayers = widget.playersList.length;
    List<Widget> children = widget.playersList.map((playerInfo) {
      if (widget.currPlayer.lobbyLeader == true) {
        // print(playerInfo);
        return new ListTile(
          title: new Text(playerInfo["name"] + " [Lobby leader]"),
          trailing: _getPlayButton(_numberOfPlayers, playerInfo),
        );
      } else {
        // print(playerInfo);
        return new ListTile(
          title: new Text(playerInfo["name"]),
        );
      }
      }).toList();

      print(children.runtimeType);
      
    return new Column(
      children: children
    );
  }

  Widget roomInformation() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: (
          new Text("ROOM ID: " + widget.roomId, style: new TextStyle(fontSize: 30.0),)
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Roles: player.name or null
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
              roomInformation(),
              _playersList(context),
            ],
          ),
        ),
      ),
    );
  }
}
