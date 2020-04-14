import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GlobalLoader extends StatefulWidget {
  @override
  _GlobalLoaderState createState() => _GlobalLoaderState();
}

class _GlobalLoaderState extends State<GlobalLoader> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Colors.lightBlue,
          size: 50.0,
        ),
      ),
    );
  }
}
