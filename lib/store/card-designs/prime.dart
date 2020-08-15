import 'package:flutter/material.dart';
import 'package:literature/models/playing_cards.dart';

// ignore: must_be_immutable
class PrimeCardDesign extends StatelessWidget {
  PrimeCardDesign({
    this.cards
  });

  List<PlayingCard> cards;


  @override
  Widget build(BuildContext context) {
    return new Text("Prime");
  }
}
