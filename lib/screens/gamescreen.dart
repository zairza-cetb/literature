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
  bool _ready = false;
  List<Player> teamRed = new List<Player>();
  List<Player> teamBlue = new List<Player>();

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
        // Override playersList.
        widget.playersList = players;
        // Assign red and blue teams
        print(players);
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
          child: new Stack(
            children: <Widget> [
              new Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _playerInformation(widget.player)
              ),
              new Positioned(
                bottom:20,
                left: 0,
                right: 0,
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
