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
                    padding: EdgeInsets.symmetric(vertical: width * 0.1),
                    //alignment: Alignment.centerLeft,
                    margin: EdgeInsetsDirectional.only(start: width * 0.02),
                    child: Icon(Icons.arrow_back_ios),
                  )),
              Expanded(
                child: Material(
                    color: Colors.white,
                    child: Container(
                      //color: Colors.green,
                      height: height * 0.1,
                      margin: EdgeInsetsDirectional.fromSTEB(
                          width * 0.15, width * 0.055, width * 0.1, width * 0),
                      child: Text(
                        "DEVELOPERS",
                        style: TextStyle(
                            fontSize: height * 0.04,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'helvetica',
                            color: Colors.black),
                      ),
                    )),
              )
            ]),
            Center(
              child: Container(
                margin: EdgeInsets.all(width * .01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.2),
                    border: Border.all(
                        color: Colors.blueAccent, width: width * 0.01)),
                child: Container(
                  height: height * 0.18,
                  width: width * 0.3,
                  child: Material(
                    borderRadius: BorderRadius.circular(width * 0.2),
                    shadowColor: Color(0xFFb3e5fc),
                    //color: Color(0xFF039be5),
                    elevation: width * 0.01,
                    child: GestureDetector(
                        onTap: () {
                          launch('https://zairza.in/');
                        },
                        child: Container(
                            decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/zairza_logo.jpg'),
                            //fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(width * 0.2),
                        ))),
                  ),
                ),
              ),
            ),
            Material(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all( width * 0.05),
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(
                      width * .04, width * 0, width * .04, width * 0),
                  alignment: Alignment.center,
                  child: Text(
                    "ZAIRZA, a society, a cult for CETIANS who want to be ahead in the game. The club is managed by its students and alumni. The society was founded in the year 2005 and got officially recognised in the year 2007 as a technical society of CET.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'helvetica',
                        color: Colors.black),
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(
                  width * 0.032, width * 0.02, width * 0.032, width * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.068),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height * 0.15,
              child: Material(
                borderRadius: BorderRadius.circular(width * 0.068),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: width * 0.02,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: CircleAvatar(
                          radius: width * 0.08,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width * 0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Aquib Baig',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'helvetica',
                            fontSize: height * 0.022,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  width * 0.032, width * 0.02, width * 0.032, width * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.068),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height * 0.15,
              child: Material(
                borderRadius: BorderRadius.circular(width * 0.068),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: width * 0.02,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: CircleAvatar(
                          radius: width * 0.08,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width * 0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Harish Umaid',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'helvetica',
                            fontSize: height * 0.022,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  width * 0.032, width * 0.02, width * 0.032, width * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.068),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height * 0.15,
              child: Material(
                borderRadius: BorderRadius.circular(width * 0.068),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: width * 0.02,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: CircleAvatar(
                          radius: width * 0.08,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width * 0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Animesh Kar',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'helvetica',
                            fontSize: height * 0.022,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  width * 0.032, width * 0.02, width * 0.032, width * 0.04),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.068),
                  border: Border.all(color: Color(0xFF6ad1ff))),
              height: height * 0.15,
              child: Material(
                borderRadius: BorderRadius.circular(width * 0.068),
                shadowColor: Color(0xFFb3e5fc),
                //color: Color(0xFF039be5),
                elevation: width * 0.02,
                child: Center(
                  child: Row(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: CircleAvatar(
                          radius: width * 0.08,
                          //backgroundColor: Colors.lime,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: width * 0.6,
                        //color: Colors.amber,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Prateek Mohanty',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'helvetica',
                            fontSize: height * 0.022,
                          ),
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
