import 'dart:math';

import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:literature/components/card_deck.dart';
import 'package:literature/utils/loader.dart';

class GameScreen extends StatefulWidget {
  GameScreen({
    Key key,
    this.player,
    this.playersList,
  }): super(key: key);

  ///
  /// Name of the opponent
  ///
  final Player player;

  ///
  /// List of players in the room
  ///
  List<dynamic> playersList;

  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<PlayingCard> _cards = new List<PlayingCard>();
  List<dynamic> playersList = new List();
  bool _ready = false;
  List<Player> teamRed = new List<Player>();
  List<Player> teamBlue = new List<Player>();
  double radius = 150.0;

  @override
  void initState() {
    super.initState();

    game.addListener(_gameScreenListener);
  }

  @override
  dispose() {
    super.dispose();
    game.removeListener(_gameScreenListener);
  }

  _gameScreenListener(message) {
    switch(message["action"]) {
      // Gets cards from the server.
      case "pre_game_data":
        List cards = (message["data"])["cards"];
        List players = (message["data"]["playersWithTeamIds"]);
        // Add to _cards list in the state
        cards.forEach((card) {
          _cards.add(new PlayingCard(
            cardSuit: EnumToString.fromString(CardSuit.values, card["suit"]),
            cardType: EnumToString.fromString(CardType.values ,card["card"]),
            name: widget.player.name,
            opened: false)
          );
        });
        // Assign red and blue teams
        players.forEach((player) {
          if (player["teamIdentifier"] == "red") {
            // team_red.add(p);
            teamRed.add(
              new Player(
                name: player["name"],
                id: player["id"],
                teamIdentifier: player["teamIdentifier"]
              )
            );
          } 
          else teamBlue.add(
            new Player(
              name: player["name"],
              id: player["id"],
              teamIdentifier: player["teamIdentifier"]
            )
          );
        });
        // Override playersList.
        playersList = players;
        // Force rebuild
        setState(() { _ready = true; });
        break;
      default:
        print("Default case");
        break;
    }
  }

  Widget _playerInformation(Player player) {
    return Container(
      child: Center(
        child: (
          new Text("Curr player: " + player.name, style: new TextStyle(fontSize: 30.0),)
        )
      ),
    );
  }

  //
  Widget _playerInGame(player) {
    // Display profile picture and actions
    // on Tap of the profile picture.
    return new Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: new Text(
        player["name"]
      ),
    );
  }

  // Sets up a player view
  // of a particular user.
  Widget _playerView() {
    var count = -1;

    List playersTable = playersList.map((player) {
      count += 1;
      return new Transform.translate(
        child: _playerInGame(player),
        offset: Offset(
          radius * cos(0.0 + count * pi / 3),
          radius * sin(0.0 + count * pi / 3),
        ),
      );
    }).toList();

    var children = new Center(
      child: Stack(
        children: <Widget>[
          new Transform.translate(
            offset: Offset(0.0, 0.0),
            child: new Text("Arena"),
          ),
          Stack(
            children: playersTable
          ),
        ],
      ),
    );

    return new Container(
      child: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        // Disable going to the waiting page
        // cause there won't be any forwarding
        // from there on.
        appBar: new AppBar(),
        body:  _ready ? Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              new Align(
                child: _playerInformation(widget.player)
              ),
              new Container(
                child: _playerView(),
              ),
              new Align(
                alignment: Alignment.bottomCenter,
                child: CardDeck(cards: _cards)
              ),
            ]
          ),
        ) :
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Loader(),
        ),
      ),
    );
  }
}
