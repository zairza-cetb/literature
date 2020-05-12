import 'package:flutter/material.dart';
import 'package:literature/models/player.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/utils/audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LiteratureHomePage extends StatefulWidget {
  LiteratureHomePage({Key key, this.title}) : super(key: key);

  // Title of the application
  final String title;

  @override
  _LiteratureHomePage createState() => _LiteratureHomePage();
}

class _LiteratureHomePage extends State<LiteratureHomePage>
    with WidgetsBindingObserver {
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

  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _login() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse =
            await http.get('https://graph.facebook.com/v2.12/me?fields=name,'
                'picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        userProfile = profile;

        Player p = new Player(
            name: profile["name"],
            photoURL: userProfile["picture"]["data"]["url"]);
        final currPlayerProvider =
            Provider.of<PlayerList>(context, listen: false);
        currPlayerProvider.addCurrPlayer(p);

        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new CreateGame(
                    audioController: audioController,
                    userProfile: userProfile)),
          );
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateGame(
                          audioController: audioController,
                          userProfile: userProfile)),
                );
              },
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFFe1f5fe),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/logo.png'),
                              ),
                              Text(
                                'Literature',
                                style: TextStyle(
                                    fontFamily: 'Monteserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF37474f),
                                    fontSize: 20.0),
                              ),
                            ]),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 100.0,
              width: 100.0,
            ),
            Container(
                child: _isLoggedIn
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(userProfile["name"]),
                          OutlineButton(
                            child: Text("Logout"),
                            onPressed: () {
                              _logout();
                            },
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text(
                              'Login to Go!',
                              style: TextStyle(
                                  fontFamily: 'Monteserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF37474f),
                                  fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _login();
                                  },
                                  child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: const Offset(3.0, 3.0),
                                              blurRadius: 5.0,
                                              spreadRadius: 2.0,
                                            )
                                          ],
                                          border: Border.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40.0)),
                                      child: Center(
                                          child: ImageIcon(AssetImage(
                                              'assets/facebook.png')))),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: const Offset(3.0, 3.0),
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0,
                                          )
                                        ],
                                        border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      child: Center(
                                          child: ImageIcon(AssetImage(
                                              'assets/signup.png')))),
                                ),
                              ],
                            )
                          ])),
          ],
        ),
      ),
    );
  }
}
