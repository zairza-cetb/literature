import 'package:flutter/material.dart';
import 'package:literature/screens/creategame.dart';
import 'package:literature/utils/audio.dart';


class LiteratureHomePage extends StatefulWidget {
  LiteratureHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LiteratureHomePage createState() => _LiteratureHomePage();
}

class _LiteratureHomePage extends State<LiteratureHomePage> {
  bool _visible = true;

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
            MaterialPageRoute(builder: (context) => CreateGame()),
          );
        },

        child: Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
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
          ),
        ),
      )
    );
  }
}
