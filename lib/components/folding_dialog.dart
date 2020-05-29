import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/components/card_deck.dart';
import 'package:literature/utils/card_previewer.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/utils/functions.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FoldingDialog extends StatefulWidget {
  final Function cb;
  List<PlayingCard> cards;
  final Set<String> opponents;
  final Set<String> teamMates;
  final List<dynamic> playersList;

  FoldingDialog({
    @required this.cb,
    @required this.opponents,
    @required this.playersList,
    @required this.teamMates,
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
                    widget.cb();
                  },
                  child: Text("Submit"),
                ),
              ),
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
            width: 100,
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
            width: 100,
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
            width: 100,
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

// child: Form(
//               key: Key("playerSelect"),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     child: MultiSelectFormField(
//                       autovalidate: false,
//                       titleText: 'My Form',
//                       validator: (value) {
//                         if (value == null || value.length == 0) {
//                           return 'Please select one or more options';
//                         }
//                         return null;
//                       },
//                       dataSource: [
//                         {
//                           "display": "Running",
//                           "value": "Running",
//                         },
//                         {
//                           "display": "Climbing",
//                           "value": "Climbing",
//                         },
//                         {
//                           "display": "Walking",
//                           "value": "Walking",
//                         },
//                         {
//                           "display": "Swimming",
//                           "value": "Swimming",
//                         },
//                         {
//                           "display": "Soccer Practice",
//                           "value": "Soccer Practice",
//                         },
//                         {
//                           "display": "Baseball Practice",
//                           "value": "Baseball Practice",
//                         },
//                         {
//                           "display": "Football Practice",
//                           "value": "Football Practice",
//                         },
//                       ],
//                       textField: 'display',
//                       valueField: 'value',
//                       okButtonLabel: 'OK',
//                       cancelButtonLabel: 'CANCEL',
//                       hintText: 'Select cards this player has',
//                       initialValue: null,
//                       onSaved: (value) {
//                         if (value == null) return;
//                         print(value);
//                       },
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),                
//                     child: RaisedButton(
//                       child: Text('Save'),
//                       onPressed: () {
//                         print("Saving");
//                       },
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     child: Text("H"),
//                   )
//                 ],
//               ),
//             ),
