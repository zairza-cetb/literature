import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:enum_to_string/enum_to_string.dart';

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
          _cards.add(new PlayingCard(cardSuit: EnumToString.fromString(CardSuit.values, card["suit"]), cardType: EnumToString.fromString(CardType.values ,card["card"]), name: widget.player.name, opened: false));
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
      alignment: Alignment.center,
      child: Center(
        child: (
          new Text("Curr player: " + player.name, style: new TextStyle(fontSize: 30.0),)
        )
      ),
    );
  }

  Widget _cardsList() {
    if (_cards == null) {
      return new Text("No cards yet");
    } else {
      List<Widget> children = _cards.map((card) {
        return new ListTile(
          title: new Text(EnumToString.parse(card.cardType)),
          trailing: new Text(EnumToString.parse(card.cardSuit)),
        );
      }).toList();
      
      return new Column(
        children: children
      );
    }
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
        body:  SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // _buildJoin(),
              _playerInformation(widget.player),
              _cardsList(),
            ],
          ),
        ),
      ),
    );
  }
}
