import 'package:flutter/material.dart';
import 'package:literature/models/playerfirebase.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/screens/splash.dart';
import 'package:provider/provider.dart';
import 'provider/playerlistprovider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerList>(
          create: (context) => PlayerList()),
        ChangeNotifierProvider<PlayerFirebase>(
          create: (context) => PlayerFirebase()),
      ],
      child: MaterialApp(
        title: 'Literature',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
