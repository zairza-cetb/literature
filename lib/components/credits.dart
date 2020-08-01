import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back_ios),
                )),
              Flexible(
                child: Material(
                    color: Colors.white,
                    child: Container(
                      height: height*0.1,
                      //margin: const EdgeInsets.only(left: 69.0),
                      alignment: Alignment.center,
                      child: Text(
                        "DEVELOPERS",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'helvetica',
                            color: Colors.black),
                      ),
                    )),
              )
            ]),
            Center(
              child: Container(
                margin: const EdgeInsets.all(2.0),
                /* decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.00),
                    border: Border.all(color: Colors.blueAccent, width: 4)),*/
                child: Container(
                  height: height*0.18,
                  width: width*0.3,
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Color(0xFFb3e5fc),
                    //color: Color(0xFF039be5),
                    elevation: 7.0,
                    child: GestureDetector(
                        onTap: () {
                          launch('https://zairza.in/');
                        },
                        child: Container(
                            //margin:EdgeInsets.fromLTRB(1.0,10.0,150.0,10.0) ,
                            decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/zairza_logo.jpg'),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(10),
                        ))),
                  ),
                ),
              ),
            ),
            Material(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  color: Colors.white,
                  margin: const EdgeInsets.all(15.0),
                  alignment: Alignment.center,
                  child: Text(
                    "ZAIRZA, a society, a cult for CETIANS who want to be ahead in the game. The club is managed by its students and alumni. The society was founded in the year 2005 and got officially recognised in the year 2007 as a technical society of CET.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'helvetica',
                        color: Colors.black),
                  ),
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 6, 10, 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.00),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height*0.15,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: 7.0,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: CircleAvatar(
                          radius: 30,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width*0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Aquib Baig',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'helvetica', fontSize: 14),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 6, 10, 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.00),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height*0.15,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: 7.0,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: CircleAvatar(
                          radius: 30,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width*0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Harish Umaid',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'helvetica', fontSize: 14),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 6, 10, 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.00),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height*0.15,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: 7.0,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: CircleAvatar(
                          radius: 30,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width*0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Animesh Kar',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'helvetica', fontSize: 14),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 6, 10, 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.00),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height*0.15,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: 7.0,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: CircleAvatar(
                          radius: 30,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width*0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Prateek Mohanty',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'helvetica', fontSize: 14),
                        ),
                      ),
                    )
                  ]),
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
