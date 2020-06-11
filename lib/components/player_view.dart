import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/components/custom_dialog.dart';
import 'package:literature/components/folding_dialog.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:badges/badges.dart';
import 'package:literature/utils/functions.dart';
import 'package:literature/utils/game_communication.dart';

class PlayerView extends StatefulWidget {
  PlayerView({
    this.currPlayer,
    this.containerHeight,
    this.containerWidth,
    this.finalPlayersList,
    this.turnsMapper,
    this.selfOpponents,
    this.teamMates,
    this.roomId,
    this.cards,
    this.callback,
  });

  final Player currPlayer;

  final List<dynamic> finalPlayersList;

  double containerHeight;

  double containerWidth;

  Map<String, String> turnsMapper;

  Set<String> selfOpponents;

  Set<String> teamMates;

  final String roomId;

  List<PlayingCard> cards;

  _PlayerViewState createState() => _PlayerViewState();

  Function callback;
}

class _PlayerViewState extends State<PlayerView> {
  // This callback function
  // changes the turn.
  Function cb;
  List<dynamic> playersList;
  bool askingForCard = false;
  bool _folding = false;
  Player playerBeingAskedObj;
  // The idea is having a foldState of
  // the form {"name" -> "awaitingResponse" or "hasCard" or "hasNoCard"}
  // So we gotta verify those against the name when we get responses
  // from each user and we update the score after each one has been
  // validated.
  Map foldState = new Map();
  // We need to keep track
  // of what the current user has guessed for
  // each player, who contains what.
  // We need to keep track because we need to validate against
  // it.
  Map foldGuesses = new Map();

  void initState() {
    super.initState();
    // Initialise variable to the state.
    game.addListener(_playerViewListener);
    playersList = widget.finalPlayersList;
    cb = widget.callback;
  }

  void dispose() {
    super.dispose();
    game.removeListener(_playerViewListener);
  }

  _playerViewListener(message) {
    switch(message["action"]) {
      case "verify_for_folding_authenticity":
        var teamMateRescueLists = message["data"];
        if (takesPartInTransaction(widget.currPlayer, teamMateRescueLists) == "false") {
          break;
        } else {
          // This player takes part in the transaction.
          // Check if he has the cards specified or not,
          // then send a message to the server, regarding
          // a success or failure.
          List toCheckSpecificCards = getSelections(widget.currPlayer, teamMateRescueLists);
          String suit = message["data"][0]["suit"];
          bool hasAllCards = true;
          toCheckSpecificCards.forEach((cardType) {
            if (widget.cards.any((card) {
              return (EnumToString.parse(card.cardSuit) == suit
                &&
                EnumToString.parse(card.cardType) == cardType
              );
              })
            ) 
            {
              print("");
            } else {
              // If I do not have a card of
              // particular type then guess is wrong.
              hasAllCards = false;
            }
          });
          // Send the respective message to the server.
          Map foldingConfirmation = { 
            "name": widget.currPlayer.name,
            "confirmation": hasAllCards,
            "forWhichCards": toCheckSpecificCards,
            "roomId": widget.roomId,
            "whoAsked": message["data"][0]["whoAsked"],
          };
          game.send("folding_confirmation", json.encode(foldingConfirmation));
        }
        break;
      case "update_foldState":
        // return early.
        if (widget.currPlayer.name != message["data"]["whoAsked"]) {
          break;
        } else {
          var nameToBeUpdated = message["data"]["name"];
          if (message["data"]["confirmation"] == true) {
            foldState[nameToBeUpdated] = "hasAllCards";
          } else foldState[nameToBeUpdated] = "notHaveAllCards";
          // Check if all the states have completed occuring.
          var count = 0;
          var correctValues = 0;
          foldState.forEach((key, value) {
            if (value != "awaitingConfirmation") {
              if (value == "hasAllCards") {
                correctValues = correctValues + 1;
              }
              count = count + 1;
            }
          });
          // All states have completed.
          if (count == foldState.length) {
            if (count == correctValues) {
              // Add one point to the team.
              print("Must add one point to the team");
              // revoke foldState for newer values.
              foldState.clear();
              foldGuesses.clear();
            } else {
              // Change the turn.
              widget.callback();
              foldState.clear();
              foldGuesses.clear();
            }
          } else {
            // Waiting for more responses.
            print("");
          }
        }
        break;
      default:
        break;
    }
  }

  // This function rebuilds the state
  // when a player asks for cards.
  setCardAskingProps(Player playerBeingAsked, bool res) {
    // Forces rebuild.
    setState(() {
      askingForCard = true;
      playerBeingAskedObj = playerBeingAsked;
    });
  }

  closeDialog() {
    setState(() {
      askingForCard = false;
      _folding = false;
    });
    // cb();
  }

  // This function as a whole updates
  // the foldState and player selections
  // in the current state.
  preFoldMessageSendingAction(String name, var selections) {
    foldState.putIfAbsent(name, () => "awaitingConfirmation");
    foldGuesses.putIfAbsent(name, () => selections);
  }

  @override
  Widget build(BuildContext context) {
    // screen constants.
    var pContainerHeight = widget.containerHeight*0.176;
    var pContainerWidth = widget.containerWidth*0.241;
    var arenaContainerHeight = widget.containerHeight*0.353;
    var arenaContainerWidth = widget.containerWidth*0.483;
    var arenaPaddingTop = widget.containerHeight*0.188;
    var arenaPaddingLeft = widget.containerWidth*0.246;

    return Padding(
      // Important.
      padding: EdgeInsets.fromLTRB(0, 0, 0, 180),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Opponent team.
          _getOpponentTeam(
            widget.selfOpponents,
            widget.finalPlayersList,
            pContainerHeight,
            pContainerWidth,
            widget.turnsMapper,
            widget.currPlayer
          ),
          // Arena.
          Container(
            height: arenaContainerHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: new DecorationImage(
                // We can add random game mats
                // as per store purchases of the user.
                image: new ExactAssetImage("assets/frame_purple.png"),
                fit: BoxFit.contain,
              ),
            ),
            child: Center(child: Text("0-0", style: TextStyle(color: Colors.white, fontSize: 40))),
          ),
          // Your team.
          _getOpponentTeam(
            widget.selfOpponents,
            widget.finalPlayersList,
            pContainerHeight,
            pContainerWidth,
            widget.turnsMapper,
            widget.currPlayer
          ),
        ],
      ),
    );

    // return Stack(
    //   children: [
    //     Column(
    //       children: <Widget>[
    //         // Player 1.
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 10.0),
    //           child: Stack(
    //             children: <Widget>[
    //               new Align(
    //                 alignment: Alignment.topCenter,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 0 ? playersList[0] : null),
    //                   ),
    //                   // The props to this function
    //                   // might get confusing so bear with it.
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 0 ? playersList[0] : null,
    //                     // Height and width of each
    //                     // player's area on the screen.
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     // This is to find if current player has his turn,
    //                     // change his portfolio color to green.
    //                     playersList.length > 0 ? widget.turnsMapper[playersList[0]["name"]] : null,
    //                     // If current player has turn
    //                     // and if this player is an opponent,
    //                     // then only he can ask for the cards. (turnFactor)
    //                     playersList.length > 0 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[0]["name"]) 
    //                       : null,
    //                     // This is a function to set State when
    //                     // a user is asking for a card.
    //                     setCardAskingProps,
    //                     // Default hero tag.
    //                     "P1",
    //                     // Updates the parent component
    //                     // so that it clears the timer.
    //                     cb
    //                   )
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // Second row contains P2, P3
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 10.0),
    //           child: Stack(
    //             children: <Widget>[
    //               new Align(
    //                 alignment: Alignment.topLeft,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 1 ? playersList[1] : null),
    //                   ),
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 0 ? playersList[1] : null,
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     playersList.length > 1 ? widget.turnsMapper[playersList[1]["name"]] : null,
    //                     playersList.length > 1 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[1]["name"]) 
    //                       : null,
    //                     setCardAskingProps,
    //                     "P2",
    //                     cb
    //                   ),
    //                 ),
    //               ),
    //               new Align(
    //                 alignment: Alignment.topRight,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 2 ? playersList[2] : null),
    //                   ),
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 2 ? playersList[2] : null,
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     playersList.length > 2 ? widget.turnsMapper[playersList[2]["name"]] : null,
    //                     playersList.length > 2 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[2]["name"]) 
    //                       : null,
    //                     setCardAskingProps,
    //                     "P3",
    //                     cb
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // Third row contains P4, P5.
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 10.0),
    //           child: Stack(
    //             children: <Widget>[
    //               new Align(
    //                 alignment: Alignment.topLeft,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 3 ? playersList[3] : null),
    //                   ),
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 3 ? playersList[3] : null,
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     playersList.length > 3 ? widget.turnsMapper[playersList[3]["name"]] : null,
    //                     playersList.length > 3 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[3]["name"]) 
    //                       : null,
    //                     setCardAskingProps,
    //                     "P4",
    //                     cb
    //                   ),
    //                 ),
    //               ),
    //               new Align(
    //                 alignment: Alignment.topRight,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 4 ? playersList[4] : null),
    //                   ),
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 4 ? playersList[4] : null,
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     playersList.length > 4 ? widget.turnsMapper[playersList[4]["name"]] : null,
    //                     playersList.length > 4 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[4]["name"]) 
    //                       : null,
    //                     setCardAskingProps,
    //                     "P5",
    //                     cb
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // Fourth row contains P6
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 10.0),
    //           child: Stack(
    //             children: <Widget>[
    //               new Align(
    //                 alignment: Alignment.topCenter,
    //                 child: new Container(
    //                   height: pContainerHeight,
    //                   width: pContainerWidth,
    //                   decoration: BoxDecoration(
    //                     border: _getContainerBorder(playersList.length > 5 ? playersList[5] : null),
    //                   ),
    //                   child: _getPlayerInContainer(
    //                     playersList.length > 5 ? playersList[5] : null,
    //                     pContainerHeight,
    //                     pContainerWidth,
    //                     playersList.length > 5 ? widget.turnsMapper[playersList[5]["name"]] : null,
    //                     playersList.length > 5 ? 
    //                       widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
    //                         && widget.selfOpponents.contains(playersList[5]["name"]) 
    //                       : null,
    //                     setCardAskingProps,
    //                     "P6",
    //                     cb
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //     // Should be in the middle of the stack.
    //     // This is the arena.
    //     Positioned(
    //       top: arenaPaddingTop,
    //       left: arenaPaddingLeft,
    //       child: new Container(
    //         height: arenaContainerHeight,
    //         width: arenaContainerWidth,
    //         color: Colors.white24,
    //         child: Padding(
    //           padding: const EdgeInsets.all(2.0),
    //           child: Center(
    //             child: new Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Container(
    //                   width: arenaContainerWidth,
    //                   child: new Text(
    //                     "Message",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 14,
    //                       fontFamily: "Raleway",
    //                       color: Colors.white
    //                     ),
    //                   ),
    //                 ),
    //                 new Text(
    //                   "0-0",
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     fontSize: 40,
    //                     fontFamily: "Raleway",
    //                     color: Colors.white
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: <Widget>[
    //                     new Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         // Ideally return a GridView.
    //                         Badge(
    //                           badgeColor: Colors.deepPurple,
    //                           shape: BadgeShape.square,
    //                           borderRadius: 20,
    //                           toAnimate: false,
    //                           badgeContent:
    //                               Text('L-Clubs', style: TextStyle(color: Colors.white)),
    //                         ),
    //                       ],
    //                     ),
    //                     new Align(
    //                       alignment: Alignment.topRight,
    //                       child: new Container(
    //                         child: new OutlineButton(
    //                           onPressed: () {
    //                             // Set folding to true.
    //                             if (widget.turnsMapper[widget.currPlayer.name] == "hasTurn") {
    //                               setState(() {
    //                                 _folding = true;
    //                               });
    //                             }
    //                           },
    //                           borderSide: BorderSide(
    //                             color: Colors.amber,
    //                           ),
    //                           child: new Text(
    //                             "Fold",
    //                             style: TextStyle(
    //                               color: Colors.amber
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ]
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     askingForCard ? Positioned(
    //       top: 0,
    //       child: CustomDialog(
    //         askingTo: playerBeingAskedObj.name,
    //         whoAsked: widget.currPlayer.name,
    //         buttonText: "Ask",
    //         roomId: widget.roomId,
    //         cards: widget.cards,
    //         cb: closeDialog)
    //     ) : new Container(),
    //     _folding ? Positioned(
    //       top: 0,
    //       child: FoldingDialog(
    //         opponents: widget.selfOpponents,
    //         playersList: widget.finalPlayersList,
    //         teamMates: widget.teamMates,
    //         roomId: widget.roomId,
    //         updateFoldStats: preFoldMessageSendingAction,
    //         cb: closeDialog
    //       )
    //     ) : new Container(),
    //   ]
    // );
  }
}

// Gets the opponent team.
Widget _getOpponentTeam(Set<String> opponents, List<dynamic> players, h, w, turnsMapper, Player cplayer) {
  // Ideal case.
  // players.map((player) {
  //   if (!opponents.contains(player["name"])) {
  //     return new Container();
  //   } else return new Container(
  //     child: _getPlayer(player, h, w, turnsMapper),
  //   );
  // } ).toList();
  List<Widget> children = new List();
  for (var i=0; i<6; i++) {
    // If player exists
    if (players.length > i) {
      // if player is opponent.
      if (players[i]["teamIdentifier"] != cplayer.teamIdentifier) {
        children.add(
          _getPlayer(players[i], h, w, turnsMapper)
        );
      }
      // player exists but same team, render nothing.
    }
    // player doesn't exist.
  }
  // Fills in the remaining gaps
  while(children.length < 3) {
    children.add(_getPlayer(null, h, w, turnsMapper));
  }
  return Row(
    children: children.toList(),
    mainAxisAlignment: MainAxisAlignment.spaceBetween
  );
}

// Gets a specific player in the game.
Widget _getPlayer(player, h, w, turnsMapper) {
  if (player == null) {
    return Column(
      children: <Widget>[
        Container(
          child: Text("N/A", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        // Image and asking props.
        Container(
          height: h*1,
          width: w*1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffd6d2de)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: h*0.458,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/person.png'),
                        fit: BoxFit.contain
                      )
                    ),
                  ),
                ),
              ),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 28,
                    width: w*0.55,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Center(child: Text("5")),
                  ),
                  GestureDetector(
                    child: Container(
                      width: w*0.55,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Center(
                        child: Text("ASK", style: TextStyle(fontSize: 14), softWrap: false, overflow: TextOverflow.visible),
                      ),
                    ),
                    onTap: () {
                      print("Tapped");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  } else {
    // Player exists.
    return Column(
      children: <Widget>[
        Container(
          child: Text(player["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        // Image and asking props.
        Container(
          height: h*1,
          width: w*1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffd6d2de)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: h*0.458,
                    child: Hero(
                      tag: player["name"],
                      child: Image.asset("assets/person-fb.jpg")
                    )
                  ),
                ),
              ),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 28,
                    width: w*0.55,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Center(child: Text("5")),
                  ),
                  Container(
                    width: w*0.55,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          // This method
                      //     // opens up the modal for
                      //     // asking for a card.
                      //     // Also binds the widget
                      //     // to the current player you are
                      //     // asking the card to.
                      //     // setCardAskingProps(
                      //     //   new Player(
                      //     //     name: player["name"],
                      //     //     teamIdentifier: player["teamIdentifier"],
                      //     //     id: player["id"],
                      //     //   ), true);
                        },
                        child: Text("ASK", style: TextStyle(fontSize: 14), softWrap: false, overflow: TextOverflow.visible)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Gets a specific player at a specific position.
Widget _getPlayerInContainer(player, h, w, turn, turnFactor, setCardAskingProps, p, cb) {
  var teamColor =  player != null ? 
    turn == "hasTurn" ? Colors.green : player["teamIdentifier"] == "red" ?
      Colors.orange : Colors.blue:
      Colors.transparent;
  return new Stack(
    children: [
      new Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: h*0.628,
          child: new Hero(
            tag: p,
            child: player == null ? Image.asset("assets/person-fb.jpg") : Image.asset("assets/person-fb.jpg"),
          ),
        ),
      ),
      // This container keeps
      // track of how many cards
      // a user has.
      new Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: h*0.359,
          color: Colors.white,
          // Number of cards
          // and ask button.
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.topLeft,
                child: new Container(
                  width: w*0.221,
                  height: h*0.359,
                  decoration: new BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  // Gives the number of cards.
                  child: new Center(child: new Text("6")),
                ),
              ),
              new Align(
                alignment: Alignment.topRight,
                child: new Container(
                  // Player name container
                  // color is as per his team.
                  color: teamColor,
                  width: w*0.689, // 106 - 44
                  height: h*0.179,
                  child: (player != null ?
                    new Text(
                      player["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ):
                    new Text("")
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.bottomRight,
                child: new Container(
                  width: w*0.689, // 106 - 44
                  height: h*0.185,
                  child: new RaisedButton(
                    onPressed: (){
                      // This method
                      // opens up the modal for
                      // asking for a card.
                      // Also binds the widget
                      // to the current player you are
                      // asking the card to.
                      setCardAskingProps(
                        new Player(
                          name: player["name"],
                          teamIdentifier: player["teamIdentifier"],
                          id: player["id"],
                        ), true);
                    },
                    color: Colors.white,
                    child: ( turnFactor == true  ? new Container(
                      child: new Text("Ask"),
                    ):new Container())
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    ],
  );
}

// Gets container border as
// per a player's team
Border _getContainerBorder(player) {
  if (player == null) {
    return Border.all(color: Colors.yellowAccent[700], width: 4.0);
  } else {
    if((player["teamIdentifier"]) == "red") {
      return Border.all(color: Colors.yellowAccent[700], width: 4.0);
    }
    else return Border.all(color: Colors.yellowAccent[700], width: 4.0);
  }
}

