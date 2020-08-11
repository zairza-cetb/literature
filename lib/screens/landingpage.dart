import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/screens/homepage.dart';
import 'package:literature/utils/loader.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayerList>(context);
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            provider.user = null;
            return LiteratureHomePage();
          }
          provider.addFirebaseUser(user);
          return CreateGame();
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
