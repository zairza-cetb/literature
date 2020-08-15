import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/creategame.dart';
import 'package:provider/provider.dart';

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
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //google signin
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  //facebook login
  final FacebookLogin facebookSignIn = new FacebookLogin();

  var provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Google Login
  Future<FirebaseUser> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);
      print(user.email + ' ' + user.photoUrl);
      provider.addFirebaseUser(user);
      return user;
    } on Exception catch (e) {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          title: "Error in Log In",
          desc: "You have cancelled the process",
          dismissOnTouchOutside: true,
          headerAnimationLoop: false,
          dismissOnBackKeyPress: true)
        ..show();
    }
  }

  //Facebook Login
  Future<FirebaseUser> _handleFacebookLogin() async {
    try {
      final FacebookLoginResult facebookLoginResult =
          await facebookSignIn.logIn(['email', 'public_profile']);

      FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;

      final AuthCredential authCredential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);
      FirebaseUser fbUser =
          (await _auth.signInWithCredential(authCredential)).user;
      print("signed in " + fbUser.displayName);
      print(fbUser.email + ' ' + fbUser.photoUrl);
      provider.addFirebaseUser(fbUser);
      return fbUser;
    } on Exception catch (e) {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          title: "Error in Log In",
          desc: "You have cancelled the process",
          dismissOnTouchOutside: true,
          headerAnimationLoop: false,
          dismissOnBackKeyPress: true)
        ..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    provider = Provider.of<PlayerList>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          InkWell(
            child: Container(
              width: 200,
              height: height * 0.5,
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
                    Text('Tap to Go!',
                        style: TextStyle(color: Color(0xFF37474f))),
                  ]),
            ),
            onTap: () {
              setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGame()),
              );
            },
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
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Center(
                          child: ImageIcon(AssetImage('assets/facebook.png')))),
                  onTap: () {
                    _handleFacebookLogin()
                        .then((FirebaseUser fbUser) => print(fbUser))
                        .catchError((e) => print(e));
                  },
                ),
                SizedBox(
                  width: 30.0,
                ),
                InkWell(
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
                          child: ImageIcon(AssetImage('assets/google.png')))),
                  onTap: () {
                    _handleGoogleSignIn()
                        .then((FirebaseUser user) => print(user))
                        .catchError((e) => print(e));
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
