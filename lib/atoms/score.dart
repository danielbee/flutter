import 'package:flutter/material.dart';
import 'dart:async';

import '../_enums/score_is.dart';

class _ScoreState extends State<Score> {
  int counter = 0;
  var eventSubscription;

  @override
  void initState() {
    super.initState();
    eventSubscription =
        widget.eventController.stream.asBroadcastStream().listen((event) {
      if (event == ScoreIs.incrementing) {
        _incrementCounter();
      }
    });
  }

  @override
  void dispose() {
    eventSubscription.cancel();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });
    widget.eventController.sink.add(ScoreIs.changed);
  }

  void _decrementCounter() {
    setState(() {
      counter--;
    });
    widget.eventController.sink.add(ScoreIs.changed);
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
  const Score({required Key key, required this.eventController})
      : super(key: key);
  @override
  _ScoreState createState() => _ScoreState();
}
