import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/utils/card_previewer.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/functions.dart';

class CustomDialog extends StatefulWidget {
  final String askingTo, whoAsked, buttonText, roomId;
  final Image image;
  final Function cb;
  List<PlayingCard> cards;

  CustomDialog({
    @required this.askingTo,
    @required this.whoAsked,
    @required this.buttonText,
    this.image,
    @required this.roomId,
    this.cards,
    @required this.cb
  });

  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  // Initial state variables
  // that map to card previewer.
  String cardType = 'ace';
  String cardSuit = 'hearts';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.017),
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
        top: containerHeight*0.017,
        bottom: containerHeight*0.017,
        left: containerWidth*0.038,
        right: containerWidth*0.038,
      ),
      height: containerHeight*0.507,
      width: containerWidth*0.921,
      decoration: new BoxDecoration(
        image: DecorationImage(image: ExactAssetImage("assets/game_mat_basic.png"), fit: BoxFit.cover),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            // Blurs the background
            color: Colors.white38,
            blurRadius: containerHeight*0.0111,
            spreadRadius: containerHeight*0.145
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // To make the card compact
        children: <Widget>[
          // Center(child: Text("ASK", style: TextStyle(color: Colors.white, fontSize: containerHeight*0.0334))),
          // Container(
          //   width: 40,
          //   child: RaisedButton(
          //     onPressed: () {
          //       widget.cb();
          //     },
          //     child: Text("X"),
          //   ),
          // ),
          Container(child: Text("You are asking a card to " + widget.askingTo, style: TextStyle(color: Colors.white, fontSize: containerWidth*0.043))),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: containerHeight*0.089,
                    width: containerWidth*0.1932,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/person-fb.jpg'),
                        fit: BoxFit.contain
                      )
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Container(
                    //   child: Text(widget.askingTo, style: TextStyle(color: Colors.white, fontSize: 20)),
                    // ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, containerHeight*0.00559, 0, containerHeight*0.011),
                      height: containerHeight*0.0335,
                      width: containerWidth*0.1811,
                      decoration: BoxDecoration(
                        color: Color(0xfff0673c),
                        borderRadius: BorderRadius.circular(containerHeight*0.00559),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          iconSize: 0,
                          dropdownColor: Color(0xfff0673c),
                          underline: Container(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          value: cardType,
                          onChanged: (String newValue) {
                            setState(() {
                              cardType = newValue;
                            });
                          },
                          items: <String>[
                            "ace",
                            "two",
                            "three",
                            "four",
                            "five",
                            "six",
                            "eight",
                            "nine",
                            "ten",
                            "jack",
                            "queen",
                            "king"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      height: containerHeight*0.0334,
                      width: containerWidth*0.1811,
                      decoration: BoxDecoration(
                        color: Color(0xfff0673c),
                        borderRadius: BorderRadius.circular(containerHeight*0.00559),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Color(0xfff0673c),
                        iconSize: 0,
                        underline: Container(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        value: cardSuit,
                        onChanged: (String newValue) {
                          setState(() {
                            cardSuit = newValue;
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
                    ),
                  ],
                )
              ]
            ),
          ),
          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: new CardPreviewer(
              cardSuit: cardSuit,
              cardType: cardType,
              height: containerHeight*0.380,
              width: containerWidth*0.581),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(containerWidth*0.0966, containerHeight*0.0111, containerWidth*0.0966, containerHeight*0.0111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(containerHeight*0.02),
                  ),
                  color: Color(0xff0AA4EB),
                  onPressed: () {
                    // Closes the dialog.
                    widget.cb();
                    // Checks if the player has a card
                    // from the same set or not, also he should
                    // not have the same card he asked in his hand.
                    if (!hasOneFromSameSet(cardSuit, cardType, widget.cards)) {
                      // Spit out in the arena.
                      print("You probably don't have a card from the same set or you might have that card yourself, move on.");
                    } else {
                      // Ask for the particular card,
                      // send message on socket to server.
                      Map cardAskingDetails = { 
                        "cardSuit": cardSuit,
                        "cardType": cardType,
                        "askingTo": widget.askingTo,
                        "whoAsked": widget.whoAsked,
                        "roomId": widget.roomId
                      };
                      game.send("card_asking_event", json.encode(cardAskingDetails));
                    }
                  },
                  child: Text(widget.buttonText),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(containerHeight*0.02),
                  ),
                  color: Color(0xff0AA4EB),
                  onPressed: () {
                    // Closes the dialog.
                    widget.cb();
                  },
                  child: Text("CANCEL"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

