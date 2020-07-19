import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
  

class Credits extends StatelessWidget {
  @override
Widget build(BuildContext context){  
   return SingleChildScrollView(
   child:Container(
     color: Colors.white,
     child:Column( 
    children: <Widget>[
        Row(
        children: <Widget>[ 
     GestureDetector(
       onTap: () {  
          Navigator.of(context).pop(); 
        },  
       child:Container(
        child: Icon(Icons.arrow_back_ios),
      ),
      ),
      Container(
 
        height: 100,
    margin: const EdgeInsets.only(left:69.0),
    alignment: Alignment.center, 
    child: Text(
      "Developers",
      style:TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w100, 
        fontFamily: 'B612',
        color: Colors.black
        ),
      ),  
    ),
        ]
      ),
    Center( 
        child:Container(
          margin: const EdgeInsets.all(2.0),
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(10.00),
            border: Border.all( 
              color: Colors.blueAccent
                )
              ),     
            child:Container(
              height: 100.0,
              width: 100.0,
              child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Color(0xFFb3e5fc),
              //color: Color(0xFF039be5),
              elevation: 7.0,
                  child:GestureDetector(
                    onTap: (){
                      launch('https://zairza.in/');
                          },
                    child: Container(                 
                    //margin:EdgeInsets.fromLTRB(1.0,10.0,150.0,10.0) ,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                        'assets/zairza_logo.jpg'),
                        fit: BoxFit.fill
                            ),
                            borderRadius: BorderRadius.circular(10),             
                    )
                    )
                ),
              ),
              ),  
          ), 
        ),  
      Container( 
          color: Colors.white,
          margin: const EdgeInsets.all(15.0),
          alignment: Alignment.center, 
          child: Text(
            "ZAIRZA, a society, a cult for CETIANS who want to be ahead in the game. The club is managed by its students and alumni. The society was founded in the year 2005 and got officially recognised in the year 2007 as a technical society of CET.",
            style:TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w100, 
              fontFamily: 'B612',
              color: Colors.black
              ),
            ), 
          ),  
      
  SingleChildScrollView(
    child: Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(2.0),
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(10.00),
            border: Border.all( 
              color: Colors.blueAccent
              )
            ),
            child:Container(
              height: 50.0,
              child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Color(0xFFb3e5fc),
              //color: Color(0xFF039be5),
              elevation: 7.0,
              child: Center(
                child: Stack(
                children:<Widget> [
                  Container(
                    width: 150,
                    //color: Colors.amber,
                    margin: EdgeInsets.fromLTRB(70.0,15.80,20.0,5.0),
                  child:Text(
                  'Aquib Baig',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'B612'
                    ),
                  ),
                  ),
                  Align(
              alignment: Alignment.centerLeft,
            child:Container(
              margin: EdgeInsets.only(left:16),
              child:CircleAvatar(
                radius: 20,
                //backgroundColor: Colors.lime,
                ),
              ),
            ),
                  ]
                ),
              ),
              ),  
          ),
              ),
            ]
          ), 
        ),
  Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Colors.blueAccent
        )
      ),
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFFb3e5fc),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Stack(
          children:<Widget> [
            Container(
              width: 150,
              //color: Colors.amber,
              margin: EdgeInsets.fromLTRB(69.0,15.80,20.0,5.0),
            child:Text(
            'Harish Umaid',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
            ),
            Align(
              alignment: Alignment.centerLeft,
            child:Container(
              margin: EdgeInsets.only(left:16),
              child:CircleAvatar(
                radius: 20,
                //backgroundColor: Colors.lime,
                ),
              ),
            ),
            ]
          ),
         ),
        ),  
    ), 
  ),
  Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Colors.blueAccent
        )
      ),
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFFb3e5fc),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Stack(
          children:<Widget> [
            Container(
              width: 150,
              //color: Colors.amber,
              margin: EdgeInsets.fromLTRB(70.0,15.80,20.0,5.0),
            child:Text(
            'Animesh Kar',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
            ),
            Align(
              alignment: Alignment.centerLeft,
            child:Container(
              margin: EdgeInsets.only(left:16),
              child:CircleAvatar(
                radius: 20,
                //backgroundColor: Colors.lime,
                ),
              ),
            ),
            ]
          ),
         ),
        ),  
    ), 
  ),
  Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Colors.blueAccent
        )
      ),
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFFb3e5fc),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Stack(
          children:<Widget> [
            Container(
              width: 150,
              //color: Colors.amber,
              margin: EdgeInsets.fromLTRB(70.0,15.80,20.0,5.0),
            child:Text(
            'Prateek Mohanty',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
            ),
            Align(
              alignment: Alignment.centerLeft,
            child:Container(
              margin: EdgeInsets.only(left:16),
              child:CircleAvatar(
                radius: 20,
                //backgroundColor: Colors.lime,
                ),
              ),
            ),
            ]
          ),
         ),
        ),  
    ), 
  ),
 /* Container(
    margin: const EdgeInsets.all(2.0),
    decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(10.00),
      border: Border.all( 
        color: Colors.blueAccent
        )
      ),
      child:Container(
        height: 50.0,
        child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Color(0xFFb3e5fc),
        //color: Color(0xFF039be5),
        elevation: 7.0,
        child: Center(
          child: Stack(
          children:<Widget> [
            Container(
              width: 150,
              color: Colors.amber,
              margin: EdgeInsets.fromLTRB(70.0,15.80,20.0,5.0),
            child:Text(
            '5',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'B612'
              ),
            ),
            ),
            Container(
              margin:EdgeInsets.fromLTRB(10.0,10.0,20.0,10.0) ,
              child:CircleAvatar(
                radius: 22,
                backgroundColor: Colors.lime,
                ),
              ),
            ]
          ),
         ),
        ),  
    ), 
  ),*/  
    ],  
  ),
   ),
   );  
} 
}
