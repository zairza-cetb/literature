import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:literature/screens/creategame.dart';

class LiteratureHomePage extends StatefulWidget {
  LiteratureHomePage({Key key, this.title}) : super(key: key);

  // Title of the application
  final String title;

  @override
  _LiteratureHomePage createState() => _LiteratureHomePage();
}

class _LiteratureHomePage extends State<LiteratureHomePage> with WidgetsBindingObserver {

  AppLifecycleState _lastLifecycleState;
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //google signin
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  //facebook login
  final FacebookLogin facebookSignIn = new FacebookLogin();

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
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    print(user.email+' '+user.photoUrl);
    return user;
  }

  //Facebook Login
  Future<FirebaseUser> _handleFacebookLogin() async {
    final FacebookLoginResult facebookLoginResult = await facebookSignIn.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;

    final AuthCredential authCredential = FacebookAuthProvider.getCredential(
      accessToken: facebookAccessToken.token
      );
    FirebaseUser fbUser = (await _auth.signInWithCredential(authCredential)).user;
    print("signed in "+ fbUser.displayName);
    print(fbUser.email+' '+fbUser.photoUrl);
    return fbUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
                child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFe1f5fe),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/logo.png'),
                    ),
                    Text('Literature',
                    style: TextStyle(fontFamily:'B612',
                      fontWeight: FontWeight.bold,color:
                      Color(0xFF37474f),fontSize: 20.0),
                    ),
                    Text('Tap to Go!',style: TextStyle(fontFamily:'B612',color:
                      Color(0xFF37474f))
                    ),
                  ]
                ),
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
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      child: Center(
                        child:
                        ImageIcon(AssetImage('assets/facebook.png')
                        )
                      )
                    ),
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
                          child:
                          ImageIcon(AssetImage('assets/google.png')
                          )
                      )
                    ),
                    onTap: () {
                      _handleGoogleSignIn()
                        .then((FirebaseUser user) => print(user))
                        .catchError((e) => print(e));
                    },
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
