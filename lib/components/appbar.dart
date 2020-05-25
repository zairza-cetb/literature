import 'package:flutter/material.dart';
import 'package:literature/utils/audio.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget  {
  final AudioController audioController;

  GlobalAppBar(this.audioController);

  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  
   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ImageIcon getAudioIcon(musicPlaying) {
    if (musicPlaying == false) {
      return ImageIcon(AssetImage('assets/speaker_icon.png'));
    }
    return ImageIcon(AssetImage('assets/mute_icon.png'));
  }

  toggleMusicState(musicPlaying) async {
    final SharedPreferences prefs = await _prefs;
    if (musicPlaying == true) {
      prefs.setBool('wasMusicPlayed',false).then((bool success){
          setState(() {
            audioController.stopMusic();
          });
      });
    } else {
      prefs.setBool('wasMusicPlayed',true).then((bool success){
          setState(() {
                audioController.playMusic();
              });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Literature',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303f9f))
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: getAudioIcon(audioController.getMusicPlaying()),
            onPressed: () {
              // Mute the music
              toggleMusicState(audioController.getMusicPlaying());
            },
            color: Color(0xFF303f9f),
          ),
        ],
      ),
    );
  }
}
