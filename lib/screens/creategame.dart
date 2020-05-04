import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:literature/screens/joinroom.dart';
import 'package:literature/screens/createroom.dart';
import 'package:literature/utils/audio.dart';


class CreateGame extends StatefulWidget {
  // Initialise AudioPlayer instance
  final AudioController audioController;
  // Passed from "homepage.dart"
  CreateGame(this.audioController);

  _CreateGame createState() => _CreateGame();
}

class _CreateGame extends State<CreateGame> {
  String playerId;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = GlobalAppBar(audioController);
    return Scaffold(
      backgroundColor: Color(0xFFb3e5fc),
      appBar: appBar,
      body: Center(
        child: new ListView(children: <Widget>[
            Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height -100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height/15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white
                    ),
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height/15,
                    width: MediaQuery.of(context).size.width
                  )
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child:
                      new Container(
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/create_room_bg.png'),
                            fit: BoxFit.cover
                          ),
                        ),
                        height: 339.0,
                        width: 241.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  CreateRoom(audioController)
                                ),
                              );
                            },
                            child: Container(
                              height: 50.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Color(0xFFb3e5fc),
                                color: Color(0xFF039be5),
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'Create Room',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )
                          ),

                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  JoinRoom(audioController)
                                ),
                              );
                            },
                            child: Container(
                              height: 50.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Color(0xFF24315E),
                                color: Color(0xffb0bec5),
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'Join Room',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )
                          ),

                          SizedBox(height: 50.0),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  JoinRoom(audioController)
                                ),
                              );
                            },
                            child:Container(
                              height: 40.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child:
                                      ImageIcon(AssetImage('assets/facebook.png')),
                                    ),
                                    SizedBox(width: 10.0),
                                    Center(
                                      child: Text('Invite Friends with Facebook',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat')
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}
