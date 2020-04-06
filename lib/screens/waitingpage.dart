import 'package:flutter/material.dart';
// Game communication helper import
import 'package:literature/utils/game_communication.dart';
// Start Game page
import 'package:literature/screens/startgame.dart';

class WaitingPage extends StatefulWidget {
  WaitingPage({
    Key key,
    this.opponentName,
    this.playersList,
    this.character,
    this.role,
  }): super(key: key);

  ///
  /// Name of the opponent
  ///
  final String opponentName;

  ///
  ///
  ///
  List<dynamic> playersList;
  ///
  /// Character to be used by the player for his/her moves ("X" or "O")
  ///
  final String character;

  ///
  /// Role of a person
  ///
  final String role;

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
        widget.playersList = message["data"];
        
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
    List<Widget> children = widget.playersList.map((playerInfo) {
        print(playerInfo);
        return new ListTile(
          title: new Text(playerInfo["name"]),
          trailing: new RaisedButton(
            onPressed: (){
              _onPlayGame(playerInfo["name"], playerInfo["id"], context);
            },
            child: new Text('Play'),
          ),
        );
      }).toList();
      
    return new Column(
      children: children,
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
              _playersList(context),
            ],
          ),
        ),
      ),
    );
  }
}
