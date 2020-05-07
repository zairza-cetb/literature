import 'dart:math';

import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:literature/components/card_deck.dart';
import 'package:literature/utils/loader.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:literature/components/player_view.dart';

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
  List<dynamic> finalPlayersList = new List();
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
        // players.forEach((player) {
        //   if (player["teamIdentifier"] == "red") {
        //     // team_red.add(p);
        //     teamRed.add(
        //       new Player(
        //         name: player["name"],
        //         id: player["id"],
        //         teamIdentifier: player["teamIdentifier"]
        //       )
        //     );
        //   } 
        //   else teamBlue.add(
        //     new Player(
        //       name: player["name"],
        //       id: player["id"],
        //       teamIdentifier: player["teamIdentifier"]
        //     )
        //   );
        // });
        // Override playersList.
        finalPlayersList = players;
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
          new Text("Hi, " + player.name + "...", style: new TextStyle(fontSize: 30.0),)
        )
      ),
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
        body:  _ready ? SlidingUpPanel(
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              new Container(
                // height: MediaQuery.of(context).size.height*0.05,
                padding: EdgeInsets.all(0),
                child: _playerInformation(widget.player)
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.95,
                padding: EdgeInsets.all(0),
                color: Colors.blueGrey,
                child: new PlayerView(
                  containerHeight: MediaQuery.of(context).size.height*0.95,
                  containerWidth: MediaQuery.of(context).size.width,
                  currPlayer: widget.player,
                  finalPlayersList: finalPlayersList,
                ),
              ),
              // Allocate bottom with a few spaces.
            ]
          ),
          panel: new Container(
            alignment: Alignment.bottomCenter,
            child: CardDeck(cards: _cards, containerHeight: MediaQuery.of(context).size.height-467)
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
