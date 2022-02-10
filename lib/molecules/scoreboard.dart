import 'package:flutter/material.dart';
import '../atoms/score.dart'

class _ScoreboardState extends State<Scoreboard> {
  Score leftScore = Score(key: const Key("Left"));
  Score rightScore = Score(key: const Key("Right"));
  void build() {}
}

class Scoreboard extends StatefulWidget {
  const Scoreboard({required Key key}) : super(key: key);

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}
