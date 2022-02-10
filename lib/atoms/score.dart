import 'package:flutter/material.dart';

class _ScoreState extends State<Score> {
  int score = 0;
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
  final Function() incrementFromParent;
  Score({required Key key, required this.incrementFromParent})
      : super(key: key);

  @override
  _ScoreState createState() => _ScoreState();
}

class ScoreController extends ChangeNotifier {}
