import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import '../_enums/score_is.dart';
import '../_enums/timer_is.dart';
import '../_enums/timer_button_is.dart';

class _TimerState extends State<FencingTimer> {
  TimerIs _state = TimerIs.paused;
  Duration _maxTime = const Duration(minutes: 0, seconds: 20);
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();
  var scoreSubscription;
  var timerButtonSubscription;

  @override
  void initState() {
    super.initState();
    scoreSubscription =
        widget.scoreController.stream.asBroadcastStream().listen((event) {
      if (event == ScoreIs.changed) {
        safePauseTimer();
        widget.scoreController.sink.add(ScoreIs.unchanging);
      }
    });
    timerButtonSubscription =
        widget.buttonController.stream.asBroadcastStream().listen((event) {
      if (event == TimerButtonIs.needingThingsHandled) {
        _handleTimer();
      }
    });
  }

  @override
  void dispose() {
    scoreSubscription.cancel();
    timerButtonSubscription.cancel();
    super.dispose();
  }

  /* Pauses timer if and only if it is running */
  void safePauseTimer() {
    setState(() {
      if (_state != TimerIs.running) {
        return;
      }
      widget.buttonController.sink.add(TimerButtonIs.stopping);
      //timerAnimation.reverse();
      _state = TimerIs.paused;
      _stopwatch.stop();
      _timer.cancel();
    });
  }

  void _handleTimer() {
    setState(() {
      switch (_state) {
        case TimerIs.none:
          break;
        case TimerIs.finished:
          _state = TimerIs.paused;
          _stopwatch.reset();
          _timer.cancel();
          break;
        case TimerIs.paused:
          widget.buttonController.sink.add(TimerButtonIs.starting);
          //timerAnimation.forward();
          _state = TimerIs.running;
          _stopwatch.start();
          Duration period = const Duration(seconds: 1);
          if (getElapsedFromMaxTime() <= const Duration(seconds: 10)) {
            period = const Duration(milliseconds: 1);
          }
          _timer = Timer.periodic(period, (timer) {
            //something
            if (getElapsedFromMaxTime() <= const Duration(seconds: 10)) {
              _timer.cancel();
              _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
                if (getElapsedFromMaxTime() <= const Duration(seconds: 0)) {
                  timer.cancel();
                  setState(() {
                    _stopwatch.stop();
                    _state = TimerIs.finished;
                  });
                }
                setState(() {});
              });
            }

            setState(() {});
          });
          break;
        case TimerIs.running:
          safePauseTimer();
          break;
        default:
          break;
      }
    });
  }

  Duration getElapsedFromMaxTime() {
    Duration millisecondsElapsed =
        Duration(milliseconds: _stopwatch.elapsedMilliseconds);
    Duration elapsedFromMaxTime = _maxTime - millisecondsElapsed;
    return elapsedFromMaxTime;
  }

  String getFormattedTime() {
    Duration elapsedFromMaxTime = getElapsedFromMaxTime();
    if ((elapsedFromMaxTime) >= const Duration(seconds: 10)) {
      return "${elapsedFromMaxTime.inMinutes}:${elapsedFromMaxTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    } else if (elapsedFromMaxTime > const Duration(seconds: 0)) {
      return "${elapsedFromMaxTime.inSeconds.remainder(60)}.${elapsedFromMaxTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    } else {
      return "0";
    }
  }

  void _triggerSetTimer(context) async {
    // TODO: extend TimePicker and TimeOfDay better suit requirements (90 minute match)
    TimeOfDay currentTime = TimeOfDay(
        hour: getElapsedFromMaxTime().inMinutes,
        minute: getElapsedFromMaxTime().inSeconds.remainder(60));
    TimeOfDay? chosenTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      hourLabelText: "Minute",
      minuteLabelText: "Second",
    );
    if (chosenTime != null && chosenTime != currentTime) {
      setState(() {
        _maxTime =
            Duration(minutes: chosenTime.hour, seconds: chosenTime.minute);
        _stopwatch.reset();
      });
    }
  }

  IconData getTimerIconForTimerState(TimerIs state) {
    IconData retIcon;
    switch (state) {
      case TimerIs.none:
        retIcon = Icons.question_mark;
        break;
      case TimerIs.finished:
        retIcon = Icons.restore;
        break;
      case TimerIs.paused:
        retIcon = Icons.play_arrow;
        break;
      case TimerIs.running:
        retIcon = Icons.pause;
        break;
      default:
        retIcon = Icons.question_mark;
        break;
    }
    return retIcon;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTimer,
      onLongPress: () => {_triggerSetTimer(context)},
      //onSecondaryTap: _triggerSetTimer,
      child: Text(
        getFormattedTime(),
        style: Theme.of(context)
            .textTheme
            .headline1!
            .merge(const TextStyle(fontFeatures: [
              FontFeature
                  .tabularFigures(), // Ensure equal spacing between numbers  https://stackoverflow.com/a/60132909
            ])),
      ),
    );
  }
}

class FencingTimer extends StatefulWidget {
  final StreamController<ScoreIs> scoreController;
  final StreamController<TimerButtonIs> buttonController;
  const FencingTimer(
      {required Key key,
      required this.scoreController,
      required this.buttonController})
      : super(key: key);
  @override
  _TimerState createState() => _TimerState();
}
