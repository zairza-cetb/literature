import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  // Name of the player
  String name;
  // ID of a player
  String email;
  // Profile Pic
  String photoURL;
  // Uid
  String uid;

  // Constructor
  User({
    @required this.uid,
    this.name,
    this.email,
    this.photoURL,
  });

}