import 'package:flutter/material.dart';
import 'dart:async';
import '../_enums/timer_button_is.dart';

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  late AnimationController timerAnimation;
  var eventSubscription;

  @override
  void initState() {
    super.initState();
    timerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    //handling calls from timer to tell us when to change the button
    eventSubscription =
        widget.eventController.stream.asBroadcastStream().listen((event) {
      if (event == TimerButtonIs.starting) {
        timerAnimation.forward();
      } else if (event == TimerButtonIs.stopping) {
        timerAnimation.reverse();
      }
    });
  }

  @override
  void dispose() {
    eventSubscription.cancel();
    super.dispose();
  }

  void _callForTimerToBeHandled() {
    widget.eventController.sink.add(TimerButtonIs.needingThingsHandled);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _callForTimerToBeHandled,
      tooltip: 'Increment',
      child: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: timerAnimation,
      ),
    );
  }
}

class TimerButton extends StatefulWidget {
  StreamController<TimerButtonIs> eventController;
  TimerButton({required Key key, required this.eventController})
      : super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}
