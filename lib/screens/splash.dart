import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/landingpage.dart';
import 'package:literature/utils/auth.dart';
import 'package:provider/provider.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  var provider;
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) provider.addFirebaseUser(user);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => LandingPage()));
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.elasticInOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PlayerList>(context, listen: false);
    return Scaffold(
      body: Center(
        child: new Image.asset(
          'assets/logo.png',
          width: animation.value * 250,
          height: animation.value * 250,
        ),
      ),
    );
  }
}
