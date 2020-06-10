import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';

class Store extends StatefulWidget {
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        // Disable going to the waiting page
        // cause there won't be any forwarding
        // from there on.
        // appBar: new AppBar(),
        appBar: AppBar(
          title: new Text("Store", style: TextStyle(color: Color(0xFF303f9f))),
          elevation: 0,
          leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFF303f9f),
        ),
          backgroundColor: Colors.lightBlue[100],
        ),
      ),
    );
  }
}
