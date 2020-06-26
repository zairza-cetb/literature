import 'package:flutter/material.dart';

class Arena extends StatefulWidget {
  Arena(this.turnsMapper, this.height, this.messages);
  final turnsMapper;
  double height;
  final List messages;
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
    setsComplete = new List();
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    List<Widget> arenaMessages = widget.messages.map((m) {
      return Container(
        child: Text(m, style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: height*0.0223)),
      );
    }).toList();
    whoseTurn = _getCurrentTurn(widget.turnsMapper);
    List<Widget> completeSets = setsComplete.map((e) {
      return Container(

      );
    }).toList();
    return Container(
      padding: EdgeInsets.fromLTRB(width*0.1087, height*0.0522, width*0.1087, height*0.0522),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height*0.01116),
            child: Text(score, style: TextStyle(color: Colors.white, fontSize: height*0.0335, fontFamily: 'Montserrat')),
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
              Column(children: completeSets),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  )
                ),
                child: Text(whoseTurn, style: TextStyle(color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }
}
