import 'package:flutter/material.dart';
import 'package:literature/components/card_deck.dart';

class Arena extends StatefulWidget {
  Arena(this.turnsMapper, this.height, this.messages, this.currTeamScore, this.completeSets, this.opponentTeamScore);
  final turnsMapper;
  double height;
  final List messages;
  int currTeamScore;
  int opponentTeamScore;
  List completeSets;
  _ArenaState createState() => _ArenaState();
}

class _ArenaState extends State<Arena> {
  // Score is of the format, red vs blue.
  String score = "0-0";
  String whoseTurn = "";
  List setsComplete;
  @override
  void initState() {
    super.initState();
    setsComplete = widget.completeSets;
  }

  _getCurrentTurn(Map turnsMapper) {
    var name = ""; 
    turnsMapper.forEach((key, value) { 
      if (value == "hasTurn") {
        name = key;
      }
    });
    return name;
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<Widget> arenaMessages = widget.messages.map((m) {
      return Container(
        child: Text(m, style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: height*0.0223)),
      );
    }).toList();
    whoseTurn = _getCurrentTurn(widget.turnsMapper);
    List<Widget> completeSets = setsComplete.map((el) {
      return Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Container(
          height: 25,
          width: 25,
          color: Colors.white,
          child: _cardSuitToImage(el["suit"]),
        ),
      );
    }).toList();
    return Container(
      padding: EdgeInsets.fromLTRB(width*0.1087, height*0.0522, width*0.1087, height*0.0522),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height*0.01116),
            // child: Text(scoreCard, style: TextStyle(color: Colors.white, fontSize: height*0.0335, fontFamily: 'Montserrat')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("HOME ", style: TextStyle(color: Colors.white, fontSize: height*0.0135, fontFamily: 'Montserrat')),
                Text(widget.currTeamScore.toString(), style: TextStyle(color: Colors.white, fontSize: height*0.0335, fontFamily: 'Montserrat')),
                Text(" / ", style: TextStyle(color: Colors.white, fontSize: height*0.0335, fontFamily: 'Montserrat')),
                Text(widget.opponentTeamScore.toString(), style: TextStyle(color: Colors.white, fontSize: height*0.0335, fontFamily: 'Montserrat')),
                Text(" AWAY", style: TextStyle(color: Colors.white, fontSize: height*0.0135, fontFamily: 'Montserrat')),
              ]
            ),
          ),
          Expanded(
            child: Column(
              children: arenaMessages,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Complete sets.
              Row(children: completeSets),
            ],
          )
        ],
      ),
    );
  }
}
