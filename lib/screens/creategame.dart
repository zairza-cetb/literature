import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/models/player.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/joinroom.dart';
import 'package:literature/screens/createroom.dart';
import 'package:literature/screens/waitingpage.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'dart:convert';

class CreateGame extends StatefulWidget {
  _CreateGame createState() => _CreateGame();
}

class _CreateGame extends State<CreateGame> with AfterLayoutMixin<CreateGame> {
  Player currPlayer;
  String playerId;
  bool isLoading = false;
  List<dynamic> playersList = <dynamic>[];
  FirebaseUser user;
  var currPlayerProvider;
  TextEditingController joinRoomIdTextController;
  String joinRoomId;
  var auth;
  // TODO: Room ID should be a hashed value
  String roomId;
  @override
  void initState() {
    super.initState();
    userDetails();

    joinRoomIdTextController = new TextEditingController();
    // game.addListener(_joinRoomListener);
  }

  void dispose() {
    game.removeListener(_createGameListener);
    game.removeListener(_joinRoomListener);
    super.dispose();
  }

  userDetails() async {
    auth = FirebaseAuth.instance;
    user = await auth.currentUser();
  }

  _createGameListener(Map message) {
    switch (message["action"]) {
      case "set_id":
        // Set the player ID.
        playerId = message["data"]["playerId"];
        print(playerId);
        Map createDetails = {"name": user.displayName, "playerId": playerId};
        game.send("create_game", json.encode(createDetails));
        break;

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
        print(roomId.toString());

        currPlayer = new Player(
            name: user.displayName,
            id: playerId,
            lobbyLeader:
                (message["data"]["lobbyLeader"])["name"] == user.displayName
                    ? true
                    : false);

        currPlayerProvider.addCurrPlayer(currPlayer);
        currPlayerProvider.removeAll();
        currPlayerProvider.addPlayer(currPlayer);
        setState(() {
          isLoading = false;
        });
        // game.removeListener(_createRoomListener);
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => WaitingPage(
                roomId: roomId,
              ),
            ));
        break;
    }
  }

  _joinRoomListener(Map message) {
    switch (message["action"]) {
      case "set_id":
        // Set the player ID.
        playerId = message["data"]["playerId"];
        Map joinDetails = {
          "roomId": joinRoomId,
          "name": user.displayName,
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
          currPlayer = new Player(name: user.displayName);
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
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => WaitingPage(
                roomId: message["data"]["roomId"],
              ),
            ));
        break;
      case "roomisfull":
        showAnimateDialogBox(context, "full");
        game.removeListener(_joinRoomListener);
        game.disconnect();
        setState(() {
          isLoading = false;
        });
        break;
      case "invalid room":
        showAnimateDialogBox(context, "invalid");
        game.disconnect();
        game.removeListener(_joinRoomListener);
        setState(() {
          isLoading = false;
        });
        break;
    }
  }

  /// -----------------------------------------
  /// Sends a create game signal to the server
  /// -----------------------------------------
  _onCreateGame() {
    // Send a message to server to create a new game
    // and then move to join room page.

    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server, also creates the connection.
    ///
    game.addListener(_createGameListener);
    game.connect();

    setState(() {
      isLoading = true;
    });
    // Forces a rebuild
    // setState(() {});
  }

  _onJoinGame() {
    // Connect to the
    // socket.
    game.addListener(_joinRoomListener);
    game.connect();
    setState(() {
      isLoading = true;
    });
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

  void showWelcomeMessage(BuildContext context) {
    FirebaseUser u = currPlayerProvider.user;
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        customHeader: CircleAvatar(
          radius: 200,
          child: Image.network(
            u.photoUrl,
          ),
          backgroundColor: Colors.white,
        ),
        animType: AnimType.BOTTOMSLIDE,
        title: 'Welcome ' + u.displayName.split(' ').first,
        desc: ' ',
        btnOkOnPress: () {
          // dispose();
        },
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        useRootNavigator: false)
      ..show();
  }

  void showJoinDialog(BuildContext context) {
    showDialog(
        child: new Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.25,
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.01,
                MediaQuery.of(context).size.height * 0.01,
                MediaQuery.of(context).size.width * 0.01,
                MediaQuery.of(context).size.height * 0.01),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: new Text(
                    " Join Room",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: 'B612',
                      fontSize: 25,
                    ),
                  ),
                ),
                new TextField(
                  controller: joinRoomIdTextController,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    hintText: 'Enter Room ID...',
                    contentPadding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.height * 0.01,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.height * 0.01),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(32.0),
                    ),
                    icon: const Icon(Icons.person),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          game.disconnect();
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.black),
                        )),
                    FlatButton(
                      onPressed: () {
                        joinRoomId = joinRoomIdTextController.text;
                        _onJoinGame();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Join',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    currPlayerProvider = Provider.of<PlayerList>(context, listen: false);
    var appBar = GlobalAppBar();
    return Scaffold(
      backgroundColor: Color(0xFFb3e5fc),
      appBar: appBar,
      body: isLoading
          ? new Container(
              width: double.infinity,
              height: double.infinity,
              child: Loader(),
            )
          : Center(
              child: new ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
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
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/create_room_bg.png'),
                                    fit: BoxFit.cover),
                              ),
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03,
                              left: MediaQuery.of(context).size.width * 0.03,
                              right: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                    onTap: () => (user != null)
                                        ? _onCreateGame()
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateRoom())),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        shadowColor: Color(0xFFb3e5fc),
                                        color: Color(0xFF039be5),
                                        elevation: 7.0,
                                        child: Center(
                                          child: Text(
                                            'Create Room',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'B612'),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                InkWell(
                                    onTap: () => (user != null)
                                        ? showJoinDialog(context)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JoinRoom())),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        shadowColor: Color(0xFF24315E),
                                        color: Color(0xffb0bec5),
                                        elevation: 7.0,
                                        child: Center(
                                          child: Text(
                                            'Join Room',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'B612'),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JoinRoom()),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
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
                                              child: ImageIcon(
                                                AssetImage(
                                                    'assets/facebook.png'),
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  var auth =
                                                      FirebaseAuth.instance;
                                                  auth.signOut();
                                                },
                                                child: Text(
                                                  'Invite Friends with Facebook',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'B612'),
                                                ),
                                              ),
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
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    // if (currPlayerProvider.user != null) showWelcomeMessage(context);
  }
}
