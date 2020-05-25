import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/screens/homepage.dart';
import 'package:literature/utils/audio.dart';
import 'package:literature/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  @override
  void initState() {
    super.initState();
    // Music should start here
    audioController = new AudioController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioController.stopMusic();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _lastLifecycleState = state;
    });
    print(state);
    if (_lastLifecycleState == AppLifecycleState.paused) {
      setState(() {
        audioController.stopMusic();
      });
    } else if (_lastLifecycleState == AppLifecycleState.resumed) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool wasMusicPlayed = prefs.getBool('wasMusicPlayed');
      if (wasMusicPlayed != null) {
        if (wasMusicPlayed == true) {
          setState(() {
            audioController.playMusic();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LiteratureHomePage();
          }
          return CreateGame(audioController);
        } else {
          return Scaffold(
            body: Center(
              child: Loader(),
            ),
          );
        }
      },
    );
  }
}