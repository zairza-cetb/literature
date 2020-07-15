import 'package:flutter/material.dart';

class PlayerFirebase extends ChangeNotifier {
  //name from firebase
  String loginName;
  //photo url
  String photoUrl;
  //phone munber
  String phoneNumber;
  //UID
  String uID;

  // Constructor
  PlayerFirebase({
    this.loginName,
    this.photoUrl,
    this.phoneNumber,
    this.uID
  });

}