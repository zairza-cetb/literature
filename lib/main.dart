import 'package:flutter/material.dart';
import 'package:literature/screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Literature',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LiteratureHomePage(),
    );
  }
}

// For vertical and horizontally centered Scaffolds, use:
// </> https://stackoverflow.com/questions/52991376/flutter-how-to-center-widget-inside-list-view
// Scaffold(
//   appBar: new AppBar(),
//   body: Center(
//     child: new ListView(
//       shrinkWrap: true,
//         padding: const EdgeInsets.all(20.0),
//         children: [
//           Center(child: new Text('ABC'))
//         ]
//     ),
//   ),
// );
