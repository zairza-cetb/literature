import 'dart:convert';
import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:literature/components/arena.dart';
import 'package:literature/models/player.dart';
import 'package:literature/components/custom_dialog.dart';
import 'package:literature/components/folding_dialog.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/utils/functions.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/components/arena_animator.dart';
import 'package:provider/provider.dart';

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
    this.arenaMessages,
    this.updateCards,
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

  List arenaMessages;

  List<PlayingCard> cards;

  _PlayerViewState createState() => _PlayerViewState();

  Function callback;

  Function updateCards;
}

class _PlayerViewState extends State<PlayerView> {
  // Wrong guesses
  // During a fold, for whom did you
  // guess wrong.
  List<dynamic> wrongGuesses = new List();
  // Show arena animation?
  bool _showArenaAnimation = false;
  String imageCaption = '';
  String imageSrc = '';
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
  // Current team score.
  int currTeamScore = 0;
  // Opponent team score.
  int opponentTeamScore = 0;

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

  void startAnimationController() {
    // Turn on the animation controller with the respective
    // items.
    Future.delayed(new Duration(milliseconds: 3000), () {
      setState(() {
        _showArenaAnimation = false;
      });
    });
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
            "suit": suit
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
          print(message["data"]["suit"]);
          foldState.forEach((key, value) {
            if (value != "awaitingConfirmation") {
              if (value == "hasAllCards") {
                correctValues = correctValues + 1;
              }
              wrongGuesses.add(key);
              count = count + 1;
            }
          });
          // All states have completed.
          if (count == foldState.length) {
            if (count == correctValues) {
              String str = 'LIKE A BOSS';
              setState(() {
                imageCaption = str;
                imageSrc = "assets/animations/knew_that.gif";
              });
              startAnimationController();
              // Add one point to the team.
              print("Must add one point to the team");
              currTeamScore += 1;
              // revoke foldState for newer values.
              foldState.clear();
              foldGuesses.clear();
              String cardSet = lowerSet(message["data"]["forWhichCards"][0]) ? "lower" : "upper";
              Map toRemove = {"suit": message["data"]["suit"], "cardSet": cardSet, "roomId": message["data"]["roomId"]};
              game.send("remove_cards", json.encode(toRemove));
            } else {
              // Here: Notify who did not have the
              // card you asked for.
              // Change the turn.
              String str = "";
              wrongGuesses?.forEach((element) {
                str += element + ", ";
              });
              str += "do not have the cards";
              setState(() {
                _showArenaAnimation = true;
                imageSrc = 'assets/animations/seriously.gif';
                imageCaption = str;
              });
              startAnimationController();
              opponentTeamScore += 1;
              widget.callback();
              foldState.clear();
              foldGuesses.clear();
            }
          } else {
            // Waiting for more responses.
            print("");
          }
        }
        // revoke the variables to the
        // initial state.
        wrongGuesses?.clear();
        break;
      case "force_remove_cards":
        // remove cards from the cards list.
        widget.updateCards("remove", null, message["data"]["suit"]);
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

  // Sets folding == true.
  setFoldingProps() {
    setState(() {
      _folding = true;
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height*0.3125),
      child: Stack(
        children: [
          // Body of the game.
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Opponent team.
              _getOpponentTeam(
                widget.selfOpponents,
                widget.finalPlayersList,
                pContainerHeight,
                pContainerWidth,
                widget.turnsMapper,
                widget.currPlayer,
                setCardAskingProps,
                context,
                setFoldingProps
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
                child: Arena(widget.turnsMapper, arenaContainerHeight, widget.arenaMessages, currTeamScore, opponentTeamScore)
              ),
              // Your team.
              _getFriendlyTeam(
                widget.selfOpponents,
                widget.finalPlayersList,
                pContainerHeight,
                pContainerWidth,
                widget.turnsMapper,
                widget.currPlayer,
                setCardAskingProps,
                context,
                setFoldingProps
              ),
            ],
          ),
          // Animation screen should last for a few seconds.
          _showArenaAnimation ? Positioned(
            top: 180,
            left: 100,
            child: ArenaAnimator(
              imageSrc: imageSrc,
              imageCaption: imageCaption,
            )
          ): new Container(),
          // Card asking dialog of click.
          askingForCard ? CustomDialog(
              askingTo: playerBeingAskedObj.name,
              whoAsked: widget.currPlayer.name,
              buttonText: "Ask",
              roomId: widget.roomId,
              cards: widget.cards,
              cb: closeDialog)
           : new Container(),
          // Folding dialog on click.
          _folding ? FoldingDialog(
              opponents: widget.selfOpponents,
              playersList: widget.finalPlayersList,
              teamMates: widget.teamMates,
              roomId: widget.roomId,
              updateFoldStats: preFoldMessageSendingAction,
              cb: closeDialog
            )
          : new Container(),
        ],
      ),
    );
  }
}

// Gets the opponent team.
Widget _getOpponentTeam(Set<String> opponents, List<dynamic> players, h, w, turnsMapper, Player cplayer, setCardAskingProps, context, setFoldingProps) {
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
          _getPlayer(players[i], h, w, turnsMapper, "opp", setCardAskingProps, context, setFoldingProps, cplayer)
        );
      }
      // player exists but same team, render nothing.
    }
    // player doesn't exist.
  }
  // Fills in the remaining gaps
  while(children.length < 3) {
    children.add(_getPlayer(null, h, w, turnsMapper, "opp", setCardAskingProps, context, setFoldingProps, cplayer));
  }
  return Row(
    children: children.toList(),
    mainAxisAlignment: MainAxisAlignment.spaceBetween
  );
}

// Friendly team
Widget _getFriendlyTeam(Set<String> opponents, List<dynamic> players, h, w, turnsMapper, Player cplayer, setCardAskingProps, context, setFoldingProps) {
  // Ideal case.
  // players.map((player) {
  //   if (opponents.contains(player["name"])) {
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
      if (players[i]["teamIdentifier"] == cplayer.teamIdentifier) {
        children.add(
          _getPlayer(players[i], h, w, turnsMapper, "team", setCardAskingProps, context, setFoldingProps, cplayer)
        );
      }
      // player exists but same team, render nothing.
    }
    // player doesn't exist.
  }
  // Fills in the remaining gaps
  while(children.length < 3) {
    children.add(_getPlayer(null, h, w, turnsMapper, "team", setCardAskingProps, context, setFoldingProps, cplayer));
  }
  return Row(
    children: children.toList(),
    mainAxisAlignment: MainAxisAlignment.spaceBetween
  );
}

// Gets a specific player in the game.
Widget _getPlayer(player, h, w, turnsMapper, side, setCardAskingProps, context, setFoldingProps, cplayer) {
  final playerProvider = Provider.of<PlayerList>(context, listen: false);
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
            borderRadius: BorderRadius.circular(h*0.2),
            color: Color(0xffd6d2de)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, h*0.1, 0, h*0.067),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.40),
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
                    height: h*0.187,
                    width: w*0.55,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(h*0.08)
                    ),
                    child: Center(child: Text("5")),
                  ),
                  GestureDetector(
                    child: Container(
                      width: w*0.55,
                      height: h*0.187,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(h*0.08)
                      ),
                    ),
                    onTap: () {},
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
            borderRadius: BorderRadius.circular(h*0.2),
            color: Color(0xffd6d2de)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, h*0.1, 0, h*0.067),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(h*0.08),
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
                    height: h*0.187,
                    width: w*0.55,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(h*0.08)
                    ),
                    child: Center(child: Text("5")),
                  ),
                  Container(
                    width: w*0.55,
                    height: h*0.187,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(h*0.08)
                    ),
                    child: Center(
                      child: Container(
                        width: w*0.55,
                        height: h*0.187,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(h*0.08)
                        ),
                        child: (side == "opp") && turnsMapper[playerProvider.currPlayer.name] == "hasTurn" ?
                        Center(
                          child: GestureDetector(
                          onTap: () {
                            // Ask for the card.
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
                              ), true
                            );
                          },
                          child: Text("ASK", style: TextStyle(fontSize: h*0.09), softWrap: false, overflow: TextOverflow.visible)
                          ),
                        ):
                        (turnsMapper[playerProvider.currPlayer.name] == "hasTurn" && side == "team") ? Center(
                          child: GestureDetector(
                            onTap: () {
                              // Fold.
                              setFoldingProps();
                            },
                            child: Text("FOLD", style: TextStyle(fontSize: h*0.09), softWrap: false, overflow: TextOverflow.visible),
                          ),
                        ):Container(),
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
