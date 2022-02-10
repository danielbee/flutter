import 'package:flutter/material.dart';
import 'dart:async';
import '../_enums/score_is.dart';

class ScoreState extends State<Score> {
  int score = 0;
  var eventSubscription;
  @override
  void initState() {
    super.initState();
    eventSubscription =
        widget.eventController.stream.asBroadcastStream().listen((event) {
      if (event == ScoreIs.INCREMENTING) {
        incrementScore();
        widget.eventController.sink.add(ScoreIs.INCREMENTED);
      }
    });
  }

  @override
  void dispose() {
    this.eventSubscription.cancel();
    super.dispose();
  }

  void incrementScore() {
    setState(() {
      score += 1;
    });
  }

  void decrementScore() {
    setState(() {
      score -= 1;
    });
  }

  //needed to call methods from outside i think???
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {incrementScore()},
      onLongPress: () => {decrementScore()},
      onSecondaryTap: () => {decrementScore()},
      child: Text(
        '$score',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class Score extends StatefulWidget {
  final StreamController<ScoreIs> eventController;
  Score({required Key key, required this.eventController}) : super(key: key);

  @override
  ScoreState createState() => ScoreState();
}
