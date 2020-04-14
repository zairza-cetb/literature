import 'package:flutter/material.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/utils/audio.dart';


class LiteratureHomePage extends StatefulWidget {
  LiteratureHomePage({Key key, this.title}) : super(key: key);

  // Title of the application
  final String title;

  @override
  _LiteratureHomePage createState() => _LiteratureHomePage();
}

class _LiteratureHomePage extends State<LiteratureHomePage> {

  @override
  void initState() {
    super.initState();
    // Music should start here
    audioController = new AudioController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {});
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGame(audioController)),
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
                    Image(image: AssetImage('assets/logo.png'),
                    ),
                    Text('Literature',
                    style: TextStyle(fontFamily:'Monteserrat',
                      fontWeight: FontWeight.bold,color:
                      Color(0xFF37474f),fontSize: 20.0),
                    ),
                    Text('Tap to Go!',style: TextStyle(color:
                      Color(0xFF37474f))
                    ),
                  ]
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
                    Container(
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
                    SizedBox(
                      width: 30.0,
                    ),
                    Container(
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
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
