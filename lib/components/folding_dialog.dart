import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/card_previewer.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/functions.dart';

class FoldingDialog extends StatefulWidget {
  final Function cb;
  List<PlayingCard> cards;
  final Set<String> opponents;
  final List<dynamic> playersList;

  FoldingDialog({
    @required this.cb,
    @required this.opponents,
    @required this.playersList
  });

  _FoldingDialogState createState() => _FoldingDialogState();
}

class _FoldingDialogState extends State<FoldingDialog> {
  // Initial state variables
  // that map to card previewer.
  String selectedSuit = "hearts";
  String selectedSet = "L";
  // String cardType = 'ace';
  // String cardSuit = 'hearts';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context)
    );
  }

  dialogContent(BuildContext context) {
    var containerHeight = MediaQuery.of(context).size.height;
    var containerWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: Consts.padding,
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding,
      ),
      height: containerHeight*0.587,
      width: containerWidth*0.821,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40,
                child: OutlineButton(
                  onPressed: () {
                    widget.cb();
                  },
                  child: Text("X"),
                ),
              ),
            ],
          ),
          SizedBox(height: containerHeight*0.0188),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedSuit,
                onChanged: (String newValue) {
                  setState(() {
                    selectedSuit = newValue;
                  });
                },
                items: <String>[
                  "spades",
                  "hearts",
                  "diamonds",
                  "clubs",
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedSet,
                onChanged: (String newValue) {
                  setState(() {
                    selectedSet = newValue;
                  });
                },
                items: <String>[
                  "L",
                  "H",
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ]
          ),
          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomCenter,
            // child: new CardPreviewer(
            //   cardSuit: selectedSuit,
            //   cardType: cardType,
            //   height: containerHeight*0.587,
            //   width: containerWidth*0.821,),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
