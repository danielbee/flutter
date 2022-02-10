import 'package:flutter/material.dart';

class _ScoreState extends State<Score> {
  void _onPressed() {}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.incrementCounter(),
      onLongPress: () => widget.decrementCounter(),
      onSecondaryTap: () => widget.decrementCounter(),
      child: Text(
        '${widget.counter}',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class Score extends StatefulWidget {
  final int counter;

  final VoidCallback decrementCounter;
  final VoidCallback incrementCounter;
  Score(
      {required Key key,
      required this.counter,
      required this.incrementCounter,
      required this.decrementCounter})
      : super(key: key);
  @override
  _ScoreState createState() => _ScoreState();
}
