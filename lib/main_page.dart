import 'package:flutter/material.dart';
import '_enums/timer_state.dart';
import 'dart:ui';
import 'dart:async';
import 'atoms/score.dart';

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _counter = 0;
  int _left_count = 0;
  int _right_count = 0;
  TimerIs _timer_state = TimerIs.paused;
  Duration _max_time = Duration(minutes: 0, seconds: 20);
  late Timer _timer;
  Stopwatch _stopwatch = Stopwatch();

  late AnimationController myTimerAnimation;
  @override
  void initState() {
    super.initState();
    myTimerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  IconData getTimerIconForTimerState(TimerIs timer_state) {
    IconData ret_icon;
    switch (timer_state) {
      case TimerIs.none:
        ret_icon = Icons.question_mark;
        break;
      case TimerIs.finished:
        ret_icon = Icons.restore;
        break;
      case TimerIs.paused:
        ret_icon = Icons.play_arrow;
        break;
      case TimerIs.running:
        ret_icon = Icons.pause;
        break;
      default:
        ret_icon = Icons.question_mark;
        break;
    }
    return ret_icon;
  }

  void _incrementLeftCount() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _left_count++;
      safePauseTimer();
    });
  }

  void _incrementRightCount() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _right_count++;
      safePauseTimer();
    });
  }

  void _decrementLeftCount() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _left_count--;
      safePauseTimer();
    });
  }

  void _decrementRightCount() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _right_count--;
      safePauseTimer();
    });
  }

  /* Pauses timer if and only if it is running */
  void safePauseTimer() {
    setState(() {
      if (_timer_state != TimerIs.running) {
        return;
      }
      myTimerAnimation.reverse();
      _timer_state = TimerIs.paused;
      _stopwatch.stop();
      _timer.cancel();
    });
  }

  void _handleTimer() {
    setState(() {
      switch (_timer_state) {
        case TimerIs.none:
          break;
        case TimerIs.finished:
          _timer_state = TimerIs.paused;
          _stopwatch.reset();
          _timer.cancel();
          break;
        case TimerIs.paused:
          myTimerAnimation.forward();
          _timer_state = TimerIs.running;
          _stopwatch.start();
          Duration period = Duration(seconds: 1);
          if (getElapsedFromMaxTime() <= Duration(seconds: 10)) {
            period = Duration(milliseconds: 1);
          }
          _timer = new Timer.periodic(period, (timer) {
            //something
            if (getElapsedFromMaxTime() <= Duration(seconds: 10)) {
              _timer.cancel();
              _timer = new Timer.periodic(Duration(milliseconds: 1), (timer) {
                if (getElapsedFromMaxTime() <= Duration(seconds: 0)) {
                  timer.cancel();
                  setState(() {
                    _stopwatch.stop();
                    _timer_state = TimerIs.finished;
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

  void _triggerSetTimer(context) async {
    print("time is $_max_time");
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
        _max_time =
            Duration(minutes: chosenTime.hour, seconds: chosenTime.minute);
        _stopwatch.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              // todo: https://stackoverflow.com/a/65273656
              padding: const EdgeInsets.fromLTRB(30.0, 4.0, 30.0, 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Score(
                    counter: _left_count,
                    incrementCounter: _incrementLeftCount,
                    decrementCounter: _decrementLeftCount,
                    key: const Key("1"),
                  ),
                  Text('-', style: Theme.of(context).textTheme.headline4),
                  Score(
                    counter: _right_count,
                    incrementCounter: _incrementRightCount,
                    decrementCounter: _decrementRightCount,
                    key: const Key("2"),
                  ),
                ],
              ),
            ),
            // todo: style and size this better
            ElevatedButton(
              onPressed: () => {_incrementLeftCount(), _incrementRightCount()},
              child: const Text("Double"),
            ),
            GestureDetector(
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleTimer,
        tooltip: 'Increment',
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: myTimerAnimation,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Duration getElapsedFromMaxTime() {
    Duration milliseconds_elapsed =
        Duration(milliseconds: _stopwatch.elapsedMilliseconds);
    Duration elapsed_from_max_time = _max_time - milliseconds_elapsed;
    return elapsed_from_max_time;
  }

  String getFormattedTime() {
    Duration elapsed_from_max_time = getElapsedFromMaxTime();
    if ((elapsed_from_max_time) >= Duration(seconds: 10)) {
      return "${elapsed_from_max_time.inMinutes}:${elapsed_from_max_time.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    } else if (elapsed_from_max_time > Duration(seconds: 0)) {
      return "${elapsed_from_max_time.inSeconds.remainder(60)}.${elapsed_from_max_time.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    } else {
      return "0";
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}
