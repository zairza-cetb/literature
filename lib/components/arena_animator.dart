import 'package:flutter/material.dart';

class ArenaAnimator extends StatefulWidget {
  ArenaAnimator({
    this.imageSrc,
    this.imageCaption
  });
  final imageSrc;
  final imageCaption;

  _ArenaAnimatorState createState() => _ArenaAnimatorState();
}

class _ArenaAnimatorState extends State<ArenaAnimator> {
  Widget build(BuildContext ctx) {
    return Container(
      color: Colors.transparent,
      height: 300,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(widget.imageSrc),
          Text(
            widget.imageCaption,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ]
      ),
    );
  }
}
