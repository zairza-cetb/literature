import 'package:flutter/material.dart';

class CardPreviewer extends StatefulWidget {
  final cardSuit;
  final cardType;
  CardPreviewer({
    @required this.cardSuit,
    @required this.cardType,
  });
  _CardPreviewerState createState() => _CardPreviewerState();
}

class _CardPreviewerState extends State<CardPreviewer> {
  static const font = "Courier New";
  @override
  void initState() {
    print("State changing...");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var containerHeight = MediaQuery.of(context).size.height;
    var containerWidth = MediaQuery.of(context).size.width;

    return _buildLargeCard(widget.cardType, widget.cardSuit, containerHeight, containerWidth);
  }

  Widget _buildLargeCard(type, suit, h, w) {
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
        height: h*0.188,
        width: w*0.2415,
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
                        fontSize: w*0.145,
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
                                fontSize: w*0.0483,
                                color: (
                                  suit == "clubs" || 
                                  suit == "spades" ? Colors.black : Colors.red
                                ),
                              ),
                            ),
                          ),
                          Container(
                          height: h*0.0188,
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
                          height: h*0.0188,
                            child: _cardSuitToImage(suit),
                          ),
                          Container(
                            child: Text(
                              _cardTypeToString(type),
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: w*0.0483,
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
