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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // screen constants.
    var pContainerHeight = widget.containerHeight*0.176;
    var pContainerWidth = widget.containerWidth*0.241;
    var arenaContainerHeight = widget.containerHeight*0.353;
    var arenaContainerWidth = widget.containerWidth*0.483;
    var arenaPaddingTop = widget.containerHeight*0.188;
    var arenaPaddingLeft = widget.containerWidth*0.261;

    return Stack(
      children: [
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      color: Colors.pink,
                      height: pContainerHeight,
                      width: pContainerWidth,
                      child: _getPlayerInContainer()
                    ),
                  ),
                ],
              ),
            ),
            // 2nd
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topLeft,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      color: Colors.amber,
                      child: _getPlayerInContainer(),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topRight,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      color: Colors.green,
                      child: _getPlayerInContainer(),
                    ),
                  ),
                ],
              ),
            ),
            // 3rd row.
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topLeft,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      color: Colors.cyan,
                      child: _getPlayerInContainer(),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topRight,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      color: Colors.yellow,
                      child: _getPlayerInContainer(),
                    ),
                  ),
                ],
              ),
            ),
            // 4th row
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      height: pContainerHeight,
                      width: pContainerWidth,
                      color: Colors.deepOrange,
                      child: _getPlayerInContainer(),
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

Widget _getPlayerInContainer() {
  return new GestureDetector(
    onDoubleTap: () {
      print("Tap");
    },
    child: new Hero(
      tag: 'HeroImage',
      child: Image.asset("assets/person.png"),
    ),
  );
}
