import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/models/player.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/joinroom.dart';
import 'package:literature/screens/createroom.dart';
import 'package:literature/screens/waitingpage.dart';
import 'package:literature/utils/audio.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/loader.dart';
import 'package:provider/provider.dart';

class CreateGame extends StatefulWidget {
  // Initialise AudioPlayer instance
  final AudioController audioController;
  final Map userProfile;

  // Passed from "homepage.dart"
  CreateGame(
      {Key key, @required this.audioController, @required this.userProfile})
      : super(key: key);

  _CreateGame createState() => _CreateGame();
}

class _CreateGame extends State<CreateGame> {
  String playerId;
  Player currPlayer;
  // String playerId;
  bool isLoading = false;
  // TODO: Room ID should be a hashed value
  int roomId;

  static Map userInfo;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    game.removeListener(_createRoomListener);
    super.dispose();
  }

  _onCreateGame() {
    // Send a message to server to create a new game
    // and then move to join room page.

    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server, also creates the connection.
    ///
    game.addListener(_createRoomListener);
    game.connect();
    // print(isLoading);
    setState(() {
      isLoading = true;
    });
    // Forces a rebuild
  }

  _createRoomListener(Map message) {

    final currPlayerProvider = Provider.of<PlayerList>(context, listen: false);
    Player x = currPlayerProvider.currPlayer;
    // print(x.name);
    switch (message["action"]) {
      case "set_id":
        currPlayerProvider.removeAll();
        // Set the player ID.
        playerId = message["data"]["player_id"];
        Map createDetails = {"name": x.name, "playerId": playerId};
        game.send("create_game", json.encode(createDetails));
        break;

      ///
      /// Creates a new game with a Room ID, Redirect to
      /// waiting page and wait for other players in
      /// the lobby.
      ///
      case 'creates_game':
        roomId = (message["data"])["roomId"];
        // Validates if actually the player created the room,
        // Need username matching in the db for any room.
        // print(playersList.toString());
        currPlayer = new Player(
            name: currPlayerProvider.currPlayer.name,
            id: playerId,
            photoURL: x.photoURL,
            lobbyLeader: (message["data"]["lobbyLeader"])["name"] == currPlayerProvider.currPlayer.name
                ? true
                : false);
        // print(currPlayer.photoURL);
        currPlayerProvider.removeAll();
        currPlayerProvider.addPlayer(currPlayer);
        currPlayerProvider.addCurrPlayer(currPlayer);
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => WaitingPage(
                roomId: roomId.toString(),
              ),
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    userInfo = widget.userProfile;
    var appBar = GlobalAppBar(audioController);
    return Scaffold(
      backgroundColor: Color(0xFFb3e5fc),
      appBar: appBar,
      body: isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Loader(),
            )
          : Center(
              child: new ListView(children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height - 100,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent),
                  Positioned(
                      top: MediaQuery.of(context).size.height / 15,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45.0),
                                topRight: Radius.circular(45.0),
                              ),
                              color: Colors.white),
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: new Container(
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/create_room_bg.png'),
                                fit: BoxFit.cover),
                          ),
                          height: 339.0,
                          width: 241.0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                                userInfo["picture"]["data"]["url"]),
                            backgroundColor: Colors.transparent,
                          ),
                          Text(userInfo["name"]),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                                onTap: _onCreateGame, 
                                // () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             CreateRoom(audioController)),
                                //   );
                                // },
                                child: Container(
                                  height: 50.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Color(0xFFb3e5fc),
                                    color: Color(0xFF039be5),
                                    elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        'Create Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 20.0),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            JoinRoom(audioController)),
                                  );
                                },
                                child: Container(
                                  height: 50.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Color(0xFF24315E),
                                    color: Color(0xffb0bec5),
                                    elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        'Join Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 50.0),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            JoinRoom(audioController)),
                                  );
                                },
                                child: Container(
                                  height: 40.0,
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 1.0),
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: ImageIcon(AssetImage(
                                              'assets/facebook.png')),
                                        ),
                                        SizedBox(width: 10.0),
                                        Center(
                                          child: Text(
                                              'Invite Friends with Facebook',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat')),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ]),
            ),
    );
  }
}
