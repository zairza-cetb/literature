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
  Map selectedCard = {
    "name": "", 
    "suit": ""
  };

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  // Widget _rowCardsView() {
  //   return _largeCardsDeck();
  // }
  
  @override
  Widget build(BuildContext context) {
    return new Center(child: _buildCardDeck());
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

  Widget _buildCardDeck() {
    var padding = ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width*0.07246*(widget.cards.length-1)
      + MediaQuery.of(context).size.width*0.2536))/2 > 0) ?
      (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width*0.07246*(widget.cards.length-1)
      + MediaQuery.of(context).size.width*0.2536))/2 : MediaQuery.of(context).size.width*0.0121;
    return Container(
      height: MediaQuery.of(context).size.height*0.2232,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, 0, 0),
        child: Stack(
          children: widget.cards.asMap().entries.map((card) {
            var isSelected = selectedCard["name"] == EnumToString.parse(card.value.cardType)
                && selectedCard["suit"] == EnumToString.parse(card.value.cardSuit) ? true : false;
            return Positioned(
              bottom: isSelected ? MediaQuery.of(context).size.height*0.03116 : MediaQuery.of(context).size.height*0.02232,
              top: isSelected ? MediaQuery.of(context).size.height*0.01116 : MediaQuery.of(context).size.height*0.02232,
              child: Padding(
                padding: EdgeInsets.fromLTRB(card.key.toDouble()*MediaQuery.of(context).size.width*0.0723, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      selectedCard["name"] = "";
                      selectedCard["suit"] = "";
                    } else {
                      selectedCard["name"] = EnumToString.parse(card.value.cardType);
                      selectedCard["suit"] = EnumToString.parse(card.value.cardSuit);
                    }
                    // setState
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // Here
                      border: isSelected ? Border.all(width: 2.5, color: Color(0xffCCB100)) : Border.all(width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                    ),
                    child: _buildCard(EnumToString.parse(card.value.cardType), EnumToString.parse(card.value.cardSuit)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(type, suit) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width*0.2536,
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
                          fontSize: MediaQuery.of(context).size.width*0.043478,
                          color: (
                            suit == "clubs" || 
                            suit == "spades" ? Colors.black : Colors.red
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.0156,
                      child: _cardSuitToImage(suit),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.04464,
                left: MediaQuery.of(context).size.width*0.036231,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.08929,
                  child: _cardSuitToImage(suit),
                )
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
                          fontSize: MediaQuery.of(context).size.width*0.043478,
                          color: (
                            suit == "clubs" || 
                            suit == "spades" ? Colors.black : Colors.red
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.0156,
                      child: _cardSuitToImage(suit),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
