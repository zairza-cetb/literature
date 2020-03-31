import 'package:flutter/material.dart';

class JoinRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new ListView(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(child: new Text('Joining a room, Enter Room ID...'))
            ]
        ),
      ),
    );
  }
}
