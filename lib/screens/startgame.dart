import 'package:flutter/material.dart';

class StartGame extends StatelessWidget {
  StartGame({
    Key key,
    this.opponentName,
    this.character, role,
  }): super(key: key);

  ///
  /// Name of the opponent
  ///
  final String opponentName;
  
  ///
  /// Character to be used by the player for his/her moves ("X" or "O")
  ///
  final String character;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Center(
        child: new ListView(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(child: new Text('Start Game'))
            ]
        ),
      ),
    );
  }
}