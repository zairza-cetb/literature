import 'package:flutter/material.dart';
import 'package:literature/utils/game_communication.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool backbtn;

  const GlobalAppBar({this.backbtn});
  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //     // Close socket connection
        //     // after user presses back.
        //     game.disconnect();
        //   },
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: Color(0xFF303f9f),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Literature',
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF303f9f))),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: getAudioIcon(audioController.getMusicPlaying()),
        //     onPressed: () {
        //       // Mute the music
        //       toggleMusicState(audioController.getMusicPlaying());
        //     },
        //     color: Color(0xFF303f9f),
        //   ),
        // ],
      ),
    );
  }
}
