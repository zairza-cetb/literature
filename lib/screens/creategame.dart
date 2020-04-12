import 'package:flutter/material.dart';
import 'package:literature/screens/joinroom.dart';
import 'package:literature/screens/createroom.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';


class CreateGame extends StatefulWidget {
  // Initialise players
  static AudioCache cachePlayer = AudioCache(fixedPlayer: audioPlayer);
  static AudioPlayer audioPlayer = AudioPlayer();

  _CreateGame createState() => _CreateGame();
}

class _CreateGame extends State<CreateGame> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFb3e5fc),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFF303f9f),
        ),
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
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
            color: Color(0xFF303f9f),
          ),
        ],
      ),

      body: Center(
        child: new ListView(children: <Widget>[
            Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent
                ),

                Positioned(
                  top: 75.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white
                    ),
                    height: MediaQuery.of(context).size.height ,
                    width: MediaQuery.of(context).size.width
                  )
                ),


                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child:
                      new Container(
                        margin: EdgeInsets.only(top: 30.0),
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
                                MaterialPageRoute(builder: (context) => CreateRoom()),
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
                                MaterialPageRoute(builder: (context) => JoinRoom()),
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
                                MaterialPageRoute(builder: (context) => JoinRoom()),
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

                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                CreateGame.cachePlayer.play('theme_song.mp3');                              });
                            },
                            child:Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              height: 50.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Center(
                                    child:ImageIcon(AssetImage('assets/speaker_icon.png')),
                                  ),
                                ]
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                CreateGame.audioPlayer?.stop();
                              });
                            },
                            child:Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              height: 50.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Center(
                                    child:ImageIcon(AssetImage('assets/mute_icon.png')),
                                  ),
                                ]
                              ),
                            ),
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
