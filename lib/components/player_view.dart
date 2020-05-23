import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/components/custom_dialog.dart';

class PlayerView extends StatefulWidget {
  PlayerView({
    this.currPlayer,
    this.containerHeight,
    this.containerWidth,
    this.finalPlayersList,
    this.turnsMapper,
    this.selfOpponents, this.callback,
  });

  final Player currPlayer;

  final List<dynamic> finalPlayersList;

  double containerHeight;

  double containerWidth;

  Map<String, String> turnsMapper;

  Set<String> selfOpponents;

  _PlayerViewState createState() => _PlayerViewState();

  Function callback;
}

class _PlayerViewState extends State<PlayerView> {
  Function cb;
  List<dynamic> playersList;
  bool askingForCard = false;
  Player playerBeingAskedObj;
  // This function rebuilds the state
  // when a player asks for cards.
  setCardAskingProps(Player playerBeingAsked, bool res) {
    // Forces rebuild.
    setState(() {
      askingForCard = true;
      playerBeingAskedObj = playerBeingAsked;
    });
  }
  void initState() {
    super.initState();
    // Initialise variable to the state.
    playersList = widget.finalPlayersList;
    cb = widget.callback;
  }

  closeDialog() {
    setState(() {
      askingForCard = false;
    });
    cb();
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

    return Stack(
      children: [
        Column(
          children: <Widget>[
            // Player 1.
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 0 ? playersList[0] : null),
                      ),
                      // The props to this function
                      // might get confusing so bear with it.
                      child: _getPlayerInContainer(
                        playersList.length > 0 ? playersList[0] : null,
                        // Height and width of each
                        // player's area on the screen.
                        pContainerHeight,
                        pContainerWidth,
                        // This is to find if current player has his turn,
                        // change his portfolio color to green.
                        playersList.length > 0 ? widget.turnsMapper[playersList[0]["name"]] : null,
                        // If current player has turn
                        // and if this player is an opponent,
                        // then only he can ask for the cards. (turnFactor)
                        playersList.length > 0 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[0]["name"]) 
                          : null,
                        // This is a function to set State when
                        // a user is asking for a card.
                        setCardAskingProps,
                        // Default hero tag.
                        "P1",
                        // Updates the parent component
                        // so that it clears the timer.
                        cb
                      )
                    ),
                  ),
                ],
              ),
            ),
            // Second row contains P2, P3
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topLeft,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 1 ? playersList[1] : null),
                      ),
                      child: _getPlayerInContainer(
                        playersList.length > 0 ? playersList[1] : null,
                        pContainerHeight,
                        pContainerWidth,
                        playersList.length > 1 ? widget.turnsMapper[playersList[1]["name"]] : null,
                        playersList.length > 1 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[1]["name"]) 
                          : null,
                        setCardAskingProps,
                        "P2",
                        cb
                      ),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topRight,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 2 ? playersList[2] : null),
                      ),
                      child: _getPlayerInContainer(
                        playersList.length > 2 ? playersList[2] : null,
                        pContainerHeight,
                        pContainerWidth,
                        playersList.length > 2 ? widget.turnsMapper[playersList[2]["name"]] : null,
                        playersList.length > 2 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[2]["name"]) 
                          : null,
                        setCardAskingProps,
                        "P3",
                        cb
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Third row contains P4, P5.
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topLeft,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 3 ? playersList[3] : null),
                      ),
                      child: _getPlayerInContainer(
                        playersList.length > 3 ? playersList[3] : null,
                        pContainerHeight,
                        pContainerWidth,
                        playersList.length > 3 ? widget.turnsMapper[playersList[3]["name"]] : null,
                        playersList.length > 3 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[3]["name"]) 
                          : null,
                        setCardAskingProps,
                        "P4",
                        cb
                      ),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topRight,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 4 ? playersList[4] : null),
                      ),
                      child: _getPlayerInContainer(
                        playersList.length > 4 ? playersList[4] : null,
                        pContainerHeight,
                        pContainerWidth,
                        playersList.length > 4 ? widget.turnsMapper[playersList[4]["name"]] : null,
                        playersList.length > 4 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[4]["name"]) 
                          : null,
                        setCardAskingProps,
                        "P5",
                        cb
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Fourth row contains P6
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      decoration: BoxDecoration(
                        border: _getContainerBorder(playersList.length > 5 ? playersList[5] : null),
                      ),
                      child: _getPlayerInContainer(
                        playersList.length > 5 ? playersList[5] : null,
                        pContainerHeight,
                        pContainerWidth,
                        playersList.length > 5 ? widget.turnsMapper[playersList[5]["name"]] : null,
                        playersList.length > 5 ? 
                          widget.turnsMapper[widget.currPlayer.name] == "hasTurn" 
                            && widget.selfOpponents.contains(playersList[5]["name"]) 
                          : null,
                        setCardAskingProps,
                        "P6",
                        cb
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Should be in the middle of the stack.
        // This is the arena.
        Positioned(
          top: arenaPaddingTop,
          left: arenaPaddingLeft,
          child: new Container(
            height: arenaContainerHeight,
            width: arenaContainerWidth,
            color: Colors.black,
            child: new Text("Arena"),
          ),
        ),
        askingForCard ? Positioned(
          top: 0,
          child: CustomDialog(title: playerBeingAskedObj.name, description: "B", buttonText: "C", cb: closeDialog)
        ) : new Container(),
      ]
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
            child: player == null ? Image.asset("assets/no_person.png") : Image.asset("assets/person.png"),
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
    return Border.all(color: Colors.black, width: 2.0);
  } else {
    if((player["teamIdentifier"]) == "red") {
      return Border.all(color: Colors.orange, width: 4.0);
    }
    else return Border.all(color: Colors.blue, width: 4.0);
  }
}

