import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/game_communication.dart';

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

  /// Ready
  bool _ready = false;

  ///
  /// List of players in the room
  ///
  final List<dynamic> playersList;

  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<PlayingCard> _cards;

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
        // Assign cards to the current user
        // and setState.
        print("Opening hand");
        break;
      default:
        print("Default case");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Center(
        child: new ListView(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(child: new Text('Start Game'))
            ]
        ),
      ),
    );
  }
}
