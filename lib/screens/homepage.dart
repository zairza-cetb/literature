import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:literature/models/player.dart';
import 'package:literature/models/user.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/utils/audio.dart';
import 'package:literature/utils/loader.dart';

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
  bool loading = false;
  var firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: Loader(),
              )
            : GestureDetector(
                onTap: () => _handleSignIn("A"),
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
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Tap to Go!',
                                style: TextStyle(
                                  color: Color(0xFF37474f),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () => _handleSignIn("FB"),
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
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Center(
                                    child: ImageIcon(
                                      AssetImage('assets/facebook.png'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              InkWell(
                                onTap: () => _handleSignIn("G"),
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
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Center(
                                    child: ImageIcon(
                                      AssetImage('assets/google.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ));
  }

  Future<int> _handleSignIn(String type) async {
    setState(() {
      loading = true;
    });
    switch (type) {
      case "FB":
        FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
        final accessToken = facebookLoginResult.accessToken.token;
        if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
          final facebookAuthCred =
              FacebookAuthProvider.getCredential(accessToken: accessToken);
          final user =
              await firebaseAuth.signInWithCredential(facebookAuthCred);
          print("User : " + user.user.uid);
          await firestore.collection('users').document(user.user.uid).setData({
            "name": user.user.displayName,
            "photoURL": user.user.photoUrl,
            "email": user.user.email
          }).then((_) {
            print("Successfully Stored in Firebase");
          });
          return 1;
        } else
          return 0;
        break;
      case "G":
        try {
          GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
          final googleAuth = await googleSignInAccount.authentication;
          final googleAuthCred = GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          final user = await firebaseAuth.signInWithCredential(googleAuthCred);
          print("User : " + user.user.photoUrl);
          await firestore.collection('users').document(user.user.uid).setData({
            "name": user.user.displayName,
            "photoURL": user.user.photoUrl,
            "email": user.user.email
          }).then((_) {
            print("Successfully Stored in Firebase");
          });
          return 1;
        } catch (error) {
          return 0;
        }
        break;
      case "A":
        try {
          final user = await firebaseAuth.signInAnonymously();
          print("User : " + user.user.uid);
          firestore.collection('users').document(user.user.uid).setData({
            "name": "Anonymous",
            "photoURL": "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          }, merge: true).then((_) {
            print("Successfully Stored in Firebase");
          });
          return 1;
        } catch (error) {
          return 0;
        }
    }
    return 0;
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  Future<GoogleSignInAccount> _handleGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }
}
