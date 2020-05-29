import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/components/card_deck.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/utils/card_previewer.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/functions.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';

class FoldingDialog extends StatefulWidget {
  final Function cb;
  List<PlayingCard> cards;
  final Set<String> opponents;
  final Set<String> teamMates;
  final List<dynamic> playersList;
  final Function updateFoldStats;
  final String roomId;

  FoldingDialog({
    @required this.cb,
    @required this.opponents,
    @required this.playersList,
    @required this.teamMates,
    @required this.updateFoldStats,
    @required this.roomId,
  });

  _FoldingDialogState createState() => _FoldingDialogState();
}

class _FoldingDialogState extends State<FoldingDialog> {
  // Initial state variables
  // that map to card previewer.
  String selectedSuit = "hearts";
  String selectedSet = "L";
  List<dynamic> selectedSetList = new List<dynamic>();
  List<dynamic> teamMates = new List<dynamic>();
  var playerOneFoldSelections;
  var playerTwoFoldSelections;
  var playerThreeFoldSelections;
  // String cardType = 'ace';
  // String cardSuit = 'hearts';
  @override
  void initState() {
    super.initState();

    // Initialize with default values.
    selectedSetList = buildSetWithSelectedValues(selectedSuit, selectedSet);
    widget.playersList.forEach((player) {
      if (widget.teamMates.contains(player["name"])) {
        teamMates.add(player);
      }
    });
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
                height: 40.0,
                child: _cardSuitToImage(selectedSuit),
              ),
              Container(
                child: OutlineButton(
                  onPressed: () {
                    // send details to the
                    // server about folding.
                    // validate the form here.
                    // General format of messages.
                    // { "name" ,"selections", "suit" }
                    List message = new List();
                    final currPlayer = Provider.of<PlayerList>(context, listen: false).currPlayer;
                    if (playerOneFoldSelections != null && teamMates.length > 0) {
                      message.add(
                        {
                          // teamMates[0]["name"] : [{ "selections": playerOneFoldSelections }, { "suit" : selectedSuit }],
                          "name": teamMates[0]["name"],
                          "selections": playerOneFoldSelections,
                          "suit": selectedSuit,
                          "whoAsked": currPlayer.name
                        }
                      );
                      // Update the parent component.
                      widget.updateFoldStats(teamMates[0]["name"], playerOneFoldSelections);
                    }
                    if (playerTwoFoldSelections != null && teamMates.length > 1) {
                      message.add(
                        {
                          // teamMates[1]["name"] : [{ "selections": playerTwoFoldSelections }, { "suit" : selectedSuit }],
                          "name": teamMates[1]["name"],
                          "selections": playerTwoFoldSelections,
                          "suit": selectedSuit,
                          "whoAsked": currPlayer.name
                        }
                      );
                      widget.updateFoldStats(teamMates[1]["name"], playerTwoFoldSelections);
                    }
                    if (playerThreeFoldSelections != null && teamMates.length > 2) {
                      message.add(
                        {
                          // teamMates[2]["name"] : [{ "selections": playerThreeFoldSelections }, { "suit" : selectedSuit }],
                          "name": teamMates[2]["name"],
                          "selections": playerThreeFoldSelections,
                          "suit": selectedSuit,
                          "whoAsked": currPlayer.name
                        }
                      );
                      widget.updateFoldStats(teamMates[2]["name"], playerThreeFoldSelections);
                    }
                    Map foldingResult = {"roomId": widget.roomId, "foldedResults": message};
                    // Sends a message of the form [ name -> foldSelections, name -> foldSelections, name -> foldSelections ].
                    game.send("folding_result_initial", json.encode(foldingResult));
                    widget.cb();
                    // Also clear out variables for next group of requests.
                    playerOneFoldSelections = null;
                    playerTwoFoldSelections = null;
                    playerThreeFoldSelections = null;
                  },
                  child: Text("Submit"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.0966,
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
              Text(
                "Declare a set.",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
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
                    selectedSetList = buildSetWithSelectedValues(selectedSuit, selectedSet);
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
          // Select which of your team mates has what
          // card?
          Align(
            alignment: Alignment.bottomCenter,
            child: getTeamMatesForm(
              teamMates
            ),
          ),
        ],
      ),
    );
  }

  // Widget to guess cards from your teamMates.
  Widget getTeamMatesForm(List<dynamic> teamMates) {
    return new Container(
      // width: 120,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width*0.2415,
            color: Colors.red,
            child: new Column(
              children: <Widget>[
                new Hero(
                  tag: teamMates.length > 0 ? teamMates[0]["name"]: 'T1',
                  child: teamMates.length > 0 ? Image.asset("assets/person-fb.jpg") : Image.asset("assets/person-fb.jpg"),
                ),
                // Form field corresponding to P1
                MultiSelectFormField(
                  autovalidate: false,
                  titleText: teamMates.length > 0 ? teamMates[0]["name"] : '',
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                    return null;
                  },
                  dataSource: selectedSetList,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintText: 'Select',
                  initialValue: null,
                  onSaved: (value) {
                    if (value == null) return;
                    playerOneFoldSelections = value;
                    // Force rebuild to
                    // update all multi select values.
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width*0.2415,
            color: Colors.blue,
            child: new Column(
              children: <Widget>[
                new Hero(
                  tag: teamMates.length > 1 ? teamMates[1]["name"] : 'T2',
                  child: teamMates.length > 1 ? Image.asset("assets/person-fb.jpg") : Image.asset("assets/person-fb.jpg"),
                ),
                // Form field corresponding to P2.
                MultiSelectFormField(
                  autovalidate: false,
                  titleText: teamMates.length > 1 ? teamMates[1]["name"] : '',
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                    return null;
                  },
                  dataSource: selectedSetList,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintText: 'Select',
                  initialValue: null,
                  onSaved: (value) {
                    if (value == null) return;
                    playerTwoFoldSelections = value;
                    // Force rebuild to
                    // update all multi select values.
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width*0.2415,
            color: Colors.green,
            child: new Column(
              children: <Widget>[
                new Hero(
                  tag: teamMates.length > 2 ? teamMates[2]["name"] : 'T2',
                  child: teamMates.length > 2 ? Image.asset("assets/person-fb.jpg") : Image.asset("assets/person-fb.jpg"),
                ),
                // Form field corresponding to P3.
                MultiSelectFormField(
                  autovalidate: false,
                  titleText: teamMates.length > 2 ? teamMates[2]["name"] : '',
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                    return null;
                  },
                  dataSource: selectedSetList,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintText: 'Select',
                  initialValue: null,
                  onSaved: (value) {
                    if (value == null) return;
                    playerThreeFoldSelections = value;
                    // Force rebuild to
                    // update all multi select values.
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns an image from cardsuit.
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

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
