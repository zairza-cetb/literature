import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/playing_cards.dart';
import 'package:literature/screens/homepage.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:literature/components/card_deck.dart';
import 'package:literature/utils/loader.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:literature/components/player_view.dart';

class GameScreen extends StatefulWidget {
  // Game
  GameScreen({
    Key key,
    this.player,
    this.playersList,
    this.roomId
  }): super(key: key);

  ///
  /// Name of the opponent
  ///
  final Player player;

  ///
  /// List of players in the room
  ///
  List<dynamic> playersList;

  ///
  /// RoomId
  ///
  String roomId;

  // Timer
  Timer timer;

  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  List<PlayingCard> _cards = new List<PlayingCard>();
  List<dynamic> finalPlayersList = new List();
  bool _ready = false;
  // List<Player> teamRed = new List<Player>();
  // List<Player> teamBlue = new List<Player>();
  double radius = 150.0;
  Map<String, String> turnsMapper = new Map<String, String>();
  Map<String, String> foldingState = new Map<String, String>();
  Set<String> selfOpponents = new Set();
  Set<String> teamMates = new Set();
  List arenaMessages = new List();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    game.addListener(_gameScreenListener);
    _addMessage(arenaMessages, "Welcome to Literature");
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    game.removeListener(_gameScreenListener);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // disconnect, let everyone leave the room and clean
      // the room from the db.
      Map closeMessage = { "name": widget.player.name, "roomId": widget.roomId };
      game.send("force_close", json.encode(closeMessage));
      game.disconnect();
    }
  }

  // Starts the timer and resets it
  // in the end.
  startTimer() {
    print("Starting the timer");
    // cancel any existing timers.
    widget.timer?.cancel();
    // This runs asynchronously.
    // Sends a message to the server automatically
    // that the user has finished his turn after 60 seconds.
    widget.timer = new Timer(Duration(seconds: 60), () {
      // send a new message to the server.
      Map turnDetails = {"name": widget.player.name, "roomId": widget.roomId};
      game.send("finished_turn", json.encode(turnDetails));
    });
  }

  _gameScreenListener(message) {
    switch(message["action"]) {
      // Gets cards from the server.
      case "pre_game_data":
        List cards = (message["data"])["cards"];
        List players = (message["data"]["playersWithTeamIds"]);
        // Add to _cards list in the state
        cards.forEach((card) {
          _cards.add(new PlayingCard(
            cardSuit: EnumToString.fromString(CardSuit.values, card["suit"]),
            cardType: EnumToString.fromString(CardType.values ,card["card"]),
            name: widget.player.name,
            opened: false)
          );
        });
        // Override playersList.
        finalPlayersList = players;
        // build a map of players and turns.
        finalPlayersList.forEach((player) {
          turnsMapper.putIfAbsent(player["name"], () => "waiting");
          // Sets the current player team.
          if (player["name"] == widget.player.name) {
            widget.player.teamIdentifier = player["teamIdentifier"];
          }
        });
        // set opponents of that player.
        finalPlayersList.forEach((player) {
          if (player["teamIdentifier"] != widget.player.teamIdentifier) {
            selfOpponents.add(player["name"]);
          } else {
            teamMates.add(player["name"]);
          }
        });
        // Force rebuild
        setState(() { _ready = true; });
        break;
      case "make_move":
        var name = message["data"]["playerName"];
        // set turnsMapper value as true.
        // and force rebuild.
        // turnsMapper[name] = "true";
        turnsMapper.forEach((key, value) {
          if (key == name) {
            turnsMapper[key] = "hasTurn";
          } else turnsMapper[key] = "waiting";
        });
        // Starts the timer.
        // startTimer();
        setState(() {});
        break;
      // Please check if you have this card.
      // Cause someone requested it from you.
      case "send_card_on_request":
        var name = message["data"]["recipient"];
        // return early.
        if (name == widget.player.name) {
          // You're the recipient.
          var cardSuit = message["data"]["cardSuit"],
            cardType = message["data"]["cardType"];
          _addMessage(arenaMessages, message["data"]["inquirer"] + " asked you for " + cardType + " of " + cardSuit);
          bool haveCard = _cards.any((card) {
            return (EnumToString.parse(card.cardSuit) == cardSuit
              &&
              EnumToString.parse(card.cardType) == cardType
            );
          });
          // Ideally, update the arena here.
          if (haveCard == false) {
            print("No such card");
          } else {
            print("I have it");
          }
          // Send message that will transfer card.
          // from -> recipient.
          Map cardTransferDetails = { 
            "cardSuit": cardSuit,
            "cardType": cardType,
            "from": widget.player.name,
            "recipient": message["data"]["inquirer"],
            "roomId": widget.roomId,
            "result": haveCard == false ? "false" : "true"
          };
          game.send("card_transfer", json.encode(cardTransferDetails));
        } else {
          _addMessage(arenaMessages, message["data"]["inquirer"]
          + " asked " + message["data"]["recipient"] +
          " for " + message["data"]["cardType"] + " of " + message["data"]["cardSuit"]);
        }
        break;
      case "card_transfer_result":
        var recipient = message["data"]["recipient"];
        var transferFrom = message["data"]["inquirer"];
        var result = message["data"]["result"];
        var cardSuit = message["data"]["cardSuit"];
        var cardType = message["data"]["cardType"];
        if (recipient == widget.player.name || transferFrom == widget.player.name) {
          if (result == "true" && transferFrom == widget.player.name) {
            _addMessage(arenaMessages, "Correct guess");
            // remove the card from the current person.
            for (var i=0; i < _cards.length; i++) {
              if (EnumToString.parse(_cards[i].cardSuit) == cardSuit && EnumToString.parse(_cards[i].cardType) == cardType) {
                _cards.remove(_cards[i]);
                break;
              }
            }
            // Force rebuild
            setState(() {
              _cards = _cards;           
            });
          } else if (result == "true" && recipient == widget.player.name) {
            _addMessage(arenaMessages, "Correct guess");
            // add the resulting card to this person.
            _cards.add(
              new PlayingCard(
                cardSuit: EnumToString.fromString(CardSuit.values, cardSuit),
                cardType: EnumToString.fromString(CardType.values, cardType),
                name: null
              ),
            );
            // Force rebuild
            setState(() {
              _cards = _cards;           
            });
          } else {
            // result is false, just update that wrong guess,
            // end turn here. (important).
            _addMessage(arenaMessages, "Wrong guess, changing turn");
            print("No such card found");
            // End turn of the player who asked, not everyone.
            if (recipient == widget.player.name) {
              Map turnDetails = {"name": widget.player.name, "roomId": widget.roomId};
              game.send("finished_turn", json.encode(turnDetails));
            }
            setState(() {});
          }
        } else {
          // We get here if this player does not take place in the whole 
          // transaction. Just update the arena that x asked y about z card.
          // and the result is r.
        }
        break;
      case "force_close_app":
        var name = message["data"]["whoClosed"];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Player disconnected'),
              content: Text('$name has disconnected. The game will be closed now.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: ()  {
                    game.disconnect();
                    Navigator.pushReplacement(context,MaterialPageRoute(
                      builder: (context) =>
                      LiteratureHomePage()
                    ));
                  },
                  child: Text("Okay")
                ),
              ],
            );
          }
        );
        break;
      default:
        print("Default case");
        break;
    }
  }

  _addMessage(List l, String m) {
    l.add(m);
    if (l.length > 4) {
      var index = 0;
      while (l.length != 4) {
        l.removeAt(index);
        index+=1;
      }
    }
    return l;
  }


  void callback() {
    print("Cancelling the timer");
    widget.timer?.cancel();
    // cancels the timer.
    // Force rebuild.
    Map turnDetails = {"name": widget.player.name, "roomId": widget.roomId};
    game.send("finished_turn", json.encode(turnDetails));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        // Disable going to the waiting page
        // cause there won't be any forwarding
        // from there on.
        // appBar: new AppBar(),
        appBar: AppBar(
          title: new Text("Literature"),
          leading: new Container(),
          backgroundColor: Color(0xff0D0D1F),
        ),
        body:  _ready ? SlidingUpPanel(
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              Align(
                alignment: Alignment.center,
                child: new Container(
                  height: MediaQuery.of(context).size.height*0.95,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      // We can add random game mats
                      // as per store purchases of the user.
                      image: new ExactAssetImage("assets/game_mat_basic.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                    child: new PlayerView(
                      containerHeight: MediaQuery.of(context).size.height*0.85,
                      containerWidth: MediaQuery.of(context).size.width,
                      currPlayer: widget.player,
                      finalPlayersList: finalPlayersList,
                      turnsMapper: turnsMapper,
                      selfOpponents: selfOpponents,
                      teamMates: teamMates,
                      roomId: widget.roomId,
                      cards: _cards,
                      arenaMessages: arenaMessages,
                      callback: this.callback
                    ),
                  ),
                ),
              ),
              // Allocate bottom with a few spaces
            ]
          ),
          minHeight: MediaQuery.of(context).size.height*0.2455,
          maxHeight: MediaQuery.of(context).size.height*0.2455,
          panel: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: new Container(
              width:  MediaQuery.of(context).size.width*0.2536 + MediaQuery.of(context).size.width*0.0773*_cards.length.toDouble(),
              child: CardDeck(cards: _cards, containerHeight: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.5212)
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ) :
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Loader(),
        ),
      ),
    );
  }
}
