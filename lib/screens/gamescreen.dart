import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:literature/components/card_deck.dart';

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
  final List<dynamic> playersList;

  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<PlayingCard> _cards = new List<PlayingCard>();
  bool _ready = false;

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
      case "opening_hand":
        List cards = (message["data"])["cards"];
        // Add to _cards list in the state
        cards.forEach((card) {
          _cards.add(new PlayingCard(
            cardSuit: EnumToString.fromString(CardSuit.values, card["suit"]),
            cardType: EnumToString.fromString(CardType.values ,card["card"]),
            name: widget.player.name,
            opened: false)
          );
        });
        // Assign cards to the current user
        // and setState.
        setState(() {});
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
        body:  Container(
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
        ),
      ),
    );
  }
}
