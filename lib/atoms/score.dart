import 'package:flutter/material.dart';
import 'dart:async';

import '../_enums/score_is.dart';

class _ScoreState extends State<Score> {
  int counter = 0;
  void _onPressed() {}

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _incrementCounter(),
      onLongPress: () => _decrementCounter(),
      onSecondaryTap: () => _decrementCounter(),
      child: Text(
        '$counter',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class Score extends StatefulWidget {
  final StreamController<ScoreIs> eventController;
  Score({required Key key, required this.eventController}) : super(key: key);
  @override
  _ScoreState createState() => _ScoreState();
}
