import 'package:flutter/material.dart';
import 'package:literature/utils/game_communication.dart';
import 'package:literature/components/credits.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget  {
  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
class BackButton extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Container(
      child: IconButton(
        color: Color(0xFF6ad1ff),  
        iconSize: 15,
        icon: Icon(Icons.arrow_back_ios),  
        onPressed: () {  
          Navigator.of(context).pop(); 
        },  
      ),  
    );  
  }  
}  


showAboutDialog(BuildContext context) { 
  Widget title =Row( 
    children: <Widget>[
       Align(
    alignment: Alignment.centerLeft,
    child: BackButton()
      ),
       Align(
         alignment: AlignmentDirectional.center,
      child:Container(
    margin: const EdgeInsets.only(left:40.0),
    alignment: Alignment.center, 
    child: Text(
      "About"
      ),
      ),
       ), 
    ]
  );   
  Widget devdet=Container(
        margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ),
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            "Developers' Details",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
         ),
        ),
      ),  
      onTap: () {  
        Navigator.push(context,MaterialPageRoute(builder: 
        (context) => Credits()
        ));
     }, 
    ), 
  );
  Widget lic=Container(
        margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
      ),
    ),
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'License',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
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
      title, devdet, lic,
    ],  
  );  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
showSettingsDialog(BuildContext context) {  
Widget title =Row( 
    children: <Widget>[
       Align(
    alignment: Alignment.centerLeft,
    child: BackButton()
      ),
       Align(
         alignment: AlignmentDirectional.center,
      child:Container(
    margin: const EdgeInsets.only(left:40.0),
    alignment: Alignment.center, 
    child: Text(
      "Settings"
      ),
      ),
       ), 
    ]
  );  
  Widget music=Container(
      margin: const EdgeInsets.all(2.0),
      decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ),
        child:Container(
          height: 50.0,
          width: 260.0,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
              child: Stack(
                children:<Widget>[
                  Container(
                    //color: Colors.green,
                    height: 30.0,
                    width: 50.0,
                    margin: const EdgeInsets.fromLTRB(40.0,10.0,20.0,10.0),
                    alignment: Alignment(0.0,0.0),
                    child:Text(
                      'Music',
                      style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'B612'
                          ),
                        ),
                    ),
                  GestureDetector(
                    child:Container(
                      //color: Colors.blueGrey,
                      height: 30.0,
                      width: 50.0,
                      margin: const EdgeInsets.fromLTRB(150.0,10.0,20.0,10.0),
                      alignment: Alignment(1.0,0.0),
                      child:FlatButton(
                        child: Text("On"
                          ),
                        onPressed: null,
                        ),
                      ),
                    onTap: () {
                       Navigator.of(context).pop();   //Insert Audio and toggle
                       } ,
                    ), 
                ]
              ),           
          ),
        ),   
  );
  Widget theme=Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ), //             <--- BoxDecoration here
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'Change Theme',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
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
      title, music, theme,
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
  Widget title =Row( 
    children: <Widget>[
       Align(
    alignment: Alignment.centerLeft,
    child: BackButton()
      ),
       Align(
         alignment: AlignmentDirectional.center,
      child:Container(
    margin: const EdgeInsets.only(left:40.0),
    alignment: Alignment.center, 
    child: Text(
      "Options"
      ),
      ),
       ), 
    ]
  );  
  Widget settings=Container(
        margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ),
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
         ),
        ),
      ),  
      onTap: () {  
      showSettingsDialog(context);  
     }, 
    ), 
  );
  Widget profile=Container(
        margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ),
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
         ),
        ),
      ),  
      onTap: () {  
      Navigator.of(context).pop();  
     }, 
    ), 
  );
    Widget about=Container(
        margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ),
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'About',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
         ),
        ),
      ),  
      onTap: () {  
      showAboutDialog(context);  
     }, 
    ), 
  );
  Widget howtoplay=Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Color(0xFF6ad1ff)
        )
      ), //             <--- BoxDecoration here
    child:GestureDetector(
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFF6ad1ff),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Text(
            'How To Play',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
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
      title, profile, settings, howtoplay, about,
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
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
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
        elevation: 0.0,
        title: Text('Literature',
        style: TextStyle(
          fontFamily: 'B612',
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303f9f))
        ),
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
        actions:<Widget>[ 
          GestureDetector(
            child: CircleAvatar(
              radius: 20,  
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
