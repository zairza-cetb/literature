import 'package:flutter/material.dart';

class Arena extends StatefulWidget {
  Arena(this.turnsMapper, this.height);
  final turnsMapper;
  double height;
  _ArenaState createState() => _ArenaState();
}

class _ArenaState extends State<Arena> {
  // Score is of the format, red vs blue.
  String score = "0-0";
  String message = "Welcome to Literature";
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
    whoseTurn = _getCurrentTurn(widget.turnsMapper);
    List<Widget> completeSets = setsComplete.map((e) {
      return Container(

      );
    }).toList();
    return Container(
      padding: EdgeInsets.all(45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(score, style: TextStyle(color: Colors.white, fontSize: 30)),
          ),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.white)),
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
