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
  // card ui options
  static const font = "Courier New";
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

  Widget _cardsList() {
    if (_cards == null) {
      return new Text("No cards yet");
    } else {
      var children = _cards.map((card) {
        return new Column(
          children: <Widget>[
            new Material(
              color: Colors.white,
              // The card number
              // in the center.
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                height: 160.0,
                width: 100,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Center(
                            child: Text(
                              // put the card type here
                              _cardTypeToString(EnumToString.parse(card.cardType)),
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 60.0,
                                color: (
                                  EnumToString.parse(card.cardSuit) == "clubs" || 
                                  EnumToString.parse(card.cardSuit) == "spades" ? Colors.black : Colors.red
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Card emblem on the top.
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        // color: Colors.blue,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      _cardTypeToString(EnumToString.parse(card.cardType)),
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: 20.0,
                                        color: (
                                          EnumToString.parse(card.cardSuit) == "clubs" || 
                                          EnumToString.parse(card.cardSuit) == "spades" ? Colors.black : Colors.red
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                  height: 16.0,
                                    child: _cardSuitToImage(EnumToString.parse(card.cardSuit)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card emblem on the bottom.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 115, 4.0, 0),
                      child: Container(
                        // color: Colors.blue,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                  height: 16.0,
                                    child: _cardSuitToImage(EnumToString.parse(card.cardSuit)),
                                  ),
                                  Container(
                                    child: Text(
                                      _cardTypeToString(EnumToString.parse(card.cardType)),
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: 20.0,
                                        color: (
                                          EnumToString.parse(card.cardSuit) == "clubs" || 
                                          EnumToString.parse(card.cardSuit) == "spades" ? Colors.black : Colors.red
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList();
      
      return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children
          ),
        ),
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
        body:  new Stack(
          children: <Widget> [
            new Positioned(
              child: new Align(
                alignment: Alignment.topCenter,
                child: _playerInformation(widget.player)
              )
            ),
            new Positioned(
              bottom:0,
              left: 0,
              right: 0,
              child: Container(color: Colors.blue ,child: _cardsList())
            ),
          ]
        ),
      ),
    );
  }

  // Returns a string representing
  // the shorthand of a card suit.
  String _cardTypeToString(String type) {
    switch(type) {
      case "ace":
        return "A";
        break;
      case "two":
        return "2";
        break;
      case "three":
        return "3";
        break;
      case "four":
        return "4";
        break;
      case "five":
        return "5";
        break;
      case "six":
        return "6";
        break;
      case "eight":
        return "8";
        break;
      case "nine":
        return "9";
        break;
      case "ten":
        return "10";
        break;
      case "jack":
        return "J";
        break;
      case "king":
        return "K";
        break;
      case "queen":
        return "Q";
        break;
      default:
        return "0";
        break;
    }
  }

  Image _cardSuitToImage(String suit) {
    switch(suit) {
      case "hearts":
        return Image.asset("assets/hearts.png");
        break;
      case "diamonds":
        return Image.asset("assets/diamonds.png");
        break;
      case "clubs":
        return Image.asset("assets/clubs.png");
        break;
      case "spades":
        return Image.asset("assets/spades.png");
        break;
      default:
        return Image.asset("assets/spades.png");
        break;
    }
  }
}
