import 'package:flutter/material.dart';
import 'package:literature/screens/howtoplay.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/components/credits.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: IconButton(
        color: Color(0xFF6ad1ff),
        iconSize: width * 0.06,
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

showSettingsDialog(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  Widget title = Row(children: <Widget>[
    Align(alignment: Alignment.centerLeft, child: BackButton()),
  ]);
  Widget music = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(
            color: Color(0xFF6ad1ff))), //             <--- BoxDecoration here
    child: GestureDetector(
      child: Container(
        width: width * 0.8,
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'Music',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      //onTap: () => playMusic(),
    ),
  );
  Widget theme = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(
            color: Color(0xFF6ad1ff))), //             <--- BoxDecoration here
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'Change Theme',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
  );

  AlertDialog alert = AlertDialog(
    actions: [
      title,
      music,
      theme,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  Widget title = Row(children: <Widget>[
    Align(alignment: Alignment.centerLeft, child: BackButton()),
  ]);
  Widget settings = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(color: Color(0xFF6ad1ff))),
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        showSettingsDialog(context);
      },
    ),
  );
  Widget profile = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(color: Color(0xFF6ad1ff))),
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
  );
  Widget devdet = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(color: Color(0xFF6ad1ff))),
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        width: width * 0.8,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              "Developers' Details",
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Credits()));
      },
    ),
  );
  Widget lic = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.025),
      border: Border.all(color: Color(0xFF6ad1ff)),
    ),
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'License',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
  );
  Widget howtoplay = Container(
    margin: EdgeInsets.fromLTRB(
        width * 0.011, width * 0.02, width * 0.011, width * 0.02),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.025),
        border: Border.all(
            color: Color(0xFF6ad1ff))), //             <--- BoxDecoration here
    child: GestureDetector(
      child: Container(
        height: height * 0.078,
        child: Material(
          borderRadius: BorderRadius.circular(width * 0.025),
          shadowColor: Color(0xFF6ad1ff),
          //color: Color(0xFF039be5),
          elevation: width * 0.015,
          child: Center(
            child: Text(
              'How To Play',
              style: TextStyle(color: Colors.black, fontFamily: 'B612'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
      },
    ),
  );
  AlertDialog alert = AlertDialog(
    actions: [
      title,
      profile,
      settings,
      howtoplay,
      devdet,
      lic,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Close socket connection
            // after user presses back.
            game.disconnect();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFF303f9f),
        ),
        backgroundColor: Colors.transparent,
        elevation: width * 0.0,
        title: Text('Literature',
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.04,
                fontWeight: FontWeight.bold,
                color: Color(0xFF303f9f))),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: getAudioIcon(audioController.getMusicPlaying()),
        //     onPressed: () {
        //       // Mute the music
        //       toggleMusicState(audioController.getMusicPlaying());
        //     },
        //     color: Color(0xFF303f9f),
        //   ),
        // ],
        actions: <Widget>[
          GestureDetector(
            child: CircleAvatar(
              radius: width * 0.05,
              backgroundColor: Color(0xFF6ad1ff),
/*              child: Text(
                'OK'
              ),*/
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
