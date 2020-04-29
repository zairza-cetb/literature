import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:literature/models/player.dart';
// Game communication helper import
import 'package:literature/utils/game_communication.dart';
// Start Game page
import 'package:literature/screens/gamescreen.dart';
// Local Notification Helper
import 'package:literature/utils/local_notification_helper.dart';

class WaitingPage extends StatefulWidget {

  WaitingPage({
    Key key,
    this.currPlayer,
    this.playersList,
    this.roomId,
  }) : super(key: key);

  ///
  /// Holds the current player
  ///
  Player currPlayer;

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
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    game.addListener(_waitingPageListener);
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    
    // A Push Notification Check
    if( widget.playersList.length == 6 ) {
      showOngoingNotification(notifications, title: 'Start The Game', body: 'The Room is full. You can start the Game.'); 
    }

  }

  Future onSelectNotification(String payload) async { 
    setState(() {});
    notifications.cancel(0);  
  }

  @override
  void dispose() {
    game.removeListener(_waitingPageListener);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _waitingPageListener(message) {
    switch (message["action"]) {

      ///
      /// Each time a new player joins, we need to
      ///   * record the new list of players
      ///   * rebuild the list of all the players
      ///
      case "joined":
        print("joined");
        widget.playersList = (message["data"])["players"];
        
        // force rebuild
        setState(() {});
        break;
      // Move any waiting clients
      // to the game page.
      case "game_started":
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => new GameScreen(
                player: widget.currPlayer,
                playersList: widget.playersList,
              ),
            ));
        break;

        
    }
  }

  /// --------------------------------------------------------------
  /// We launch a new Game, we need to:
  ///    * send the action "new_game", together with the players
  ///
  ///    * redirect to the game as we are the game initiator
  /// --------------------------------------------------------------
  _onPlayGame(context) {
    // We need to send the opponentId to initiate a new game
    game.send('start_game', widget.roomId);

    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new GameScreen(
            player: widget.currPlayer,
            playersList: widget.playersList,
          ),
        ));
  }

  _getPlayButton(playerInfo) {
    if (widget.playersList.length == 6) {
      return new RaisedButton(
        onPressed: () {
          _onPlayGame(context);
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
  Widget _playersList() {
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
    /// TODO: Fix this stale state behaviour.
    List<Widget> children = widget.playersList?.map((playerInfo) {
      // print(widget.currPlayer.name + " " + playerInfo["name"]);
      if (widget.currPlayer.lobbyLeader == true &&
          widget.currPlayer.name == playerInfo["name"]) {
        // print(playerInfo);
        return new ListTile(
          title: new Text(playerInfo["name"] + " [Lobby leader]"),
          trailing: _getPlayButton(playerInfo),
        );
      } else {
        // print(playerInfo);
        return new ListTile(
          title: new Text(playerInfo["name"]),
        );
      }
    })?.toList();

    return new Column(children: children);
  }

  Widget roomInformation() {
    return Container(
      alignment: Alignment.center,
      child: Center(
          child: (new Text(
        "ROOM ID: " + widget.roomId,
        style: new TextStyle(fontSize: 30.0),
      ))),
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
              _playersList(),
            ],
          ),
        ),
      ),
    );
  }
}
