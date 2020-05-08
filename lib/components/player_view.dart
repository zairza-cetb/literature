import 'package:flutter/material.dart';

class PlayerView extends StatefulWidget {
  PlayerView({
    this.currPlayer,
    this.containerHeight,
    this.containerWidth,
    this.finalPlayersList
  });

  final currPlayer;

  final List<dynamic> finalPlayersList;

  double containerHeight;

  double containerWidth;

  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  List<dynamic> playersList;
  void initState() {
    super.initState();

    // Initialise variable to the state.
    playersList = widget.finalPlayersList;
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

    print(pContainerHeight);
    print(pContainerWidth);

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
                      child: _getPlayerInContainer(
                        playersList.length > 0 ? playersList[0] : null,
                        pContainerHeight,
                        pContainerWidth
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
                        pContainerWidth
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
                        pContainerWidth
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
                        pContainerWidth
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
                        pContainerWidth
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
                        pContainerWidth
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
        )
      ]
    );
  }
}

Widget _getPlayerInContainer(player, h, w) {
  var teamColor =  player != null ? player["teamIdentifier"] == "red" ?
                Colors.orange : Colors.blue:
                Colors.transparent;
  return new GestureDetector(
    onDoubleTap: () {
      print("Tap");
    },
    child: new Stack(
      children: [
        new Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: h*0.628,
            child: new Hero(
              tag: 'HeroImage',
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
                        print("Asking for cards");
                      },
                      color: Colors.white,
                      child: Align(alignment: Alignment.centerLeft, child: new Text("Ask")),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ],
    ),
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
