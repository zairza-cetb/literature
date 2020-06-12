import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:enum_to_string/enum_to_string.dart';

class CardDeck extends StatefulWidget {
  CardDeck({
    Key key,
    this.cards,
    this.containerHeight,
  }): super(key: key);

  List<PlayingCard> cards;

  final double containerHeight;

  _CardDeckState createState() => _CardDeckState();
}

class _CardDeckState extends State<CardDeck> {
  static const font = "Courier New";

  // Do we have to show
  // the miniView?
  bool _miniView = false;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget _largeCardList() {
    return _miniCardsDeck();
  }

  // Widget _rowCardsView() {
  //   return _largeCardsDeck();
  // }
  
  @override
  Widget build(BuildContext context) {
    return _largeCardList();
  }

  // Mini representation of all
  // cards in a single view.
  Widget _miniCardsDeck() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: GridView.count(
        crossAxisCount:5,
        children: widget.cards.map((card) {
          return Center(
            child: _buildMiniCard(EnumToString.parse(card.cardType), EnumToString.parse(card.cardSuit)),
          );
        }).toList()
      ),
    );
  }

  // Large list of playing cards
  // N/A right now.
  Widget _largeCardsDeck() {
    if (widget.cards == null) {
      return new Text("No cards yet");
    } else {
      var children = widget.cards.map((card) {
        return new Column(
          children: <Widget>[
            _buildLargeCard(EnumToString.parse(card.cardType), EnumToString.parse(card.cardSuit))
          ],
        );
      }).toList();
      
      return Container(
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

   Widget _buildMiniCard(type, suit) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          color: Colors.white
        ),
        height: widget.containerHeight-10,
        width: 55,
        child: Padding(
          padding: EdgeInsets.all(1.6),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                child: Column(
                  children: <Widget>[
                    Align(
                      child: Text(
                      _cardTypeToString(type),
                      style: TextStyle(
                          fontFamily: font,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.0,
                          color: (
                            suit == "clubs" || 
                            suit == "spades" ? Colors.black : Colors.red
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 6,
                      child: _cardSuitToImage(suit),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: 10,
                child: Container(
                  height: 12,
                  child: _cardSuitToImage(suit),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Column(
                  children: <Widget>[
                    Align(
                      child: Text(
                      _cardTypeToString(type),
                      style: TextStyle(
                          fontFamily: font,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.0,
                          color: (
                            suit == "clubs" || 
                            suit == "spades" ? Colors.black : Colors.red
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 6,
                      child: _cardSuitToImage(suit),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 20,
                child: Container(
                  height: 12,
                  child: _cardSuitToImage(suit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// height: widget.containerHeight-43.4,
//         width: 90,
  // A mini card in an
  // all cards view.
  Widget _buildMiniCards(type, suit) {
    return new Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        // Height of each mini card.
        height: widget.containerHeight-43.4,
        width: 90,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(child: Text(
                    _cardTypeToString(type),
                    style: TextStyle(
                        fontFamily: font,
                        fontSize: 20.0,
                        color: (
                          suit == "clubs" || 
                          suit == "spades" ? Colors.black : Colors.red
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card emblem on top
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
                          height: 16.0,
                            child: _cardSuitToImage(suit),
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
    );
  }

  // A particular card in row of 
  // row card view.
  Widget _buildLargeCard(type, suit) {
    return new Material(
      color: Colors.white,
      // The card number
      // in the center.
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        // See: height of each card.
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
                      _cardTypeToString(type),
                      style: TextStyle(
                        fontFamily: font,
                        fontSize: 60.0,
                        color: (
                          suit == "clubs" || 
                          suit == "spades" ? Colors.black : Colors.red
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
                              _cardTypeToString(type),
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 20.0,
                                color: (
                                  suit == "clubs" || 
                                  suit == "spades" ? Colors.black : Colors.red
                                ),
                              ),
                            ),
                          ),
                          Container(
                          height: 16.0,
                            child: _cardSuitToImage(suit),
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
                            child: _cardSuitToImage(suit),
                          ),
                          Container(
                            child: Text(
                              _cardTypeToString(type),
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 20.0,
                                color: (
                                  suit == "clubs" || 
                                  suit == "spades" ? Colors.black : Colors.red
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
    );
  }
}
