import 'package:flutter/material.dart';
import 'package:literature/screens/joinroom.dart';
import 'package:literature/screens/createroom.dart';

class CreateGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new ListView(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateRoom()),
                  );
                },
                child: Text("Create Room")
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JoinRoom()),
                  );
                },
                child: Text("Join Room")
              ),
            ]
        ),
      ),
    );
  }
}
