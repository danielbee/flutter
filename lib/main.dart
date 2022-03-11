import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'person.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class MyScore extends StatefulWidget{ 
  final int counter;
  
  final VoidCallback decrementCounter;
  final VoidCallback incrementCounter;
  MyScore({
    required Key key,
    required this.counter,
    required this.incrementCounter,
    required this.decrementCounter
  }) : super(key: key);
  @override 
  _MyScoreState createState() => _MyScoreState();
}
class _MyScoreState extends State<MyScore> { 
  void _onPressed() { 
    
  }
  @override 
  Widget build(BuildContext context) { 
    return 
      GestureDetector(
        onTap:() => widget.incrementCounter(),
        onLongPress: () => widget.decrementCounter(),
        onSecondaryTap: ()=> widget.decrementCounter(),
        child:
          Text(
            '${widget.counter}',
            style: Theme.of(context).textTheme.headline2,
          ),
      );
  }
}
enum TimerState {
   none, 
   running, 
   paused, 
   finished 
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const initialtime = Duration(minutes: 0, seconds: 20);
  var _score = { 
    "right" : 0, 
    "left" : 0,
  };
  var _name = { 
    "left" : "Fencer left", 
    "right" : "Fencer right", 
  };
  late var _fightConfig = { 
    "names" : _name,
    "boutScore" : 5,
    "boutTime" : initialtime
  };
  // Initialise scoreHistory with defaults. 
  // TODO, deal with weird user behaviour like logging some points, resetting the time and then logging some more points.
  var _scoreHistory = [
    {
      "score": { 
        "right" : 0, 
        "left" : 0,
      },
      "time": initialtime,
    },
  ];

  TimerState _timer_state = TimerState.paused;
  Duration _max_time = initialtime;
  late Timer _timer;
  Stopwatch _stopwatch = Stopwatch();

  IconData getTimerIconForTimerState(TimerState timer_state) { 
    IconData ret_icon;
    switch (timer_state) {
      case TimerState.none:
        ret_icon =  Icons.question_mark;
        break;
      case TimerState.finished: 
        ret_icon = Icons.restore;
        break;
      case TimerState.paused:
        ret_icon = Icons.play_arrow;
        break;
      case TimerState.running: 
        ret_icon = Icons.pause;
        break;
      default:
        ret_icon = Icons.question_mark;
        break;
    }
    return ret_icon;
  }
  void _incrementScore(key) {
    setState(() {
     _score[key] = _score[key]! + 1;
    });
  }
  void _decrementScore(key) {
    setState(() {
     _score[key] = _score[key]! - 1;
    });
  }

  void _handleTimer() { 
    
    setState(() {
      switch (_timer_state) {
        case TimerState.none:
          break;
        case TimerState.finished: 
          _timer_state = TimerState.paused;
          _stopwatch.reset();
          _timer.cancel();
          break;
        case TimerState.paused:
          _timer_state = TimerState.running;
          _stopwatch.start();
          Duration period = Duration(seconds:1);
          if (getElapsedFromMaxTime() <= Duration(seconds:10)){ 
            period = Duration(milliseconds: 1);
          }
          _timer = new Timer.periodic(period, (timer) { 
              //something 
              if (getElapsedFromMaxTime() <= Duration(seconds:10)){ 
                _timer.cancel();
                _timer = new Timer.periodic(
                  Duration(milliseconds: 1), (timer) { 
                    if (getElapsedFromMaxTime() <= Duration(seconds:0)){
                      
                      timer.cancel();
                      setState(() {
                        _stopwatch.stop();
                        _timer_state = TimerState.finished;
                      });
                    }
                    setState(() {});
                  }
                );
              }

          setState(() {}); 
          });
          break;
        case TimerState.running: 
          _pauseTimer();
          break;
        default:
          break;
    }
      
    });

  }
  void _pauseTimer(){ 
    if (_timer_state == TimerState.running) {
      _timer_state = TimerState.paused;
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  void _triggerSetTimer(context) async { 
    print("time is $_max_time");
    // TODO: extend TimePicker and TimeOfDay better suit requirements (90 minute match)
    TimeOfDay currentTime = TimeOfDay(
        hour: getElapsedFromMaxTime().inMinutes, 
        minute: getElapsedFromMaxTime().inSeconds.remainder(60)
      );
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
        _max_time = Duration(minutes: chosenTime.hour, seconds: chosenTime.minute);
        _stopwatch.reset();

      });
    }
  }
  void _handleScoreChange(action, key){ 
    _pauseTimer();
    _changeScore(action, key);
    setState(() {
      _scoreHistory.add({
        "score" : _score, 
        "time" : getElapsedFromMaxTime(),
      });
      
    });
    print(_scoreHistory);
    print(_fightConfig);
  }
  var _fightHistory = [];
  void _checkScore(){ 
    if (_score["left"] == _fightConfig["boutScore"] || _score["right"] == _fightConfig["boutScore"]) { 
      print("Fight is finished");
      // TODO; delay this into Reset fight in timer code so that doubles don't trigger end. 
      setState(() {
        _fightHistory.add({"config" : _fightConfig, "scores" : _scoreHistory, "finalScore" : _score});
      });
    }
  }
  void _changeScore(action, key){ 
    switch (action) {
      case "increment":
        _incrementScore(key);
        break;
      case "decrement": 
        _decrementScore(key);
        break;
      case "reset": 
        _resetScore(key);
        break;
      default:
    }
    _checkScore();
  }
  void _resetScore(key) {
    setState(() {
      _score[key] = 0;
    });
  }
  Widget _genScoreWidget(String key) { 
    return 
    Column(
      children: [
        PersonWidget(
          key: Key("name${key}"),
          defaultName: "Fencer ${key}", 
          getName: () {return _name[key];}, 
          updateName: (name) { 
            setState(() {
              _name[key] = name;
            });
          }
        ),
        MyScore(
          counter: _score[key]!, 
          incrementCounter: () => _handleScoreChange("increment", key),
          decrementCounter: () => _handleScoreChange("decrement", key), 
          key:  Key("score${key}"),
        ),

      ],
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_fightHistory.isNotEmpty) Text (
              "${_fightHistory.last['config']['names']['left']} - ${_fightHistory.last['finalScore']['left']} v ${_fightHistory.last['finalScore']['right']} - ${_fightHistory.last['config']['names']['right']}"
              ),
            Padding(
              // todo: https://stackoverflow.com/a/65273656
              padding: const EdgeInsets.fromLTRB(30.0, 4.0, 30.0, 4.0),
              child:
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _genScoreWidget("left"),
                    Text('-', style: Theme.of(context).textTheme.headline4), 
                    _genScoreWidget("right"),                  ],
                ),
            ),
            // todo: style and size this better
            ElevatedButton(
              onPressed: () => {
                _handleScoreChange("increment", "left"),
                _handleScoreChange("increment", "right")
              }, 
              child: const Text("Double"), 
            ),
            GestureDetector(
              onTap:_handleTimer,
              onLongPress: () => {
                _triggerSetTimer(context)
              },
              //onSecondaryTap: _triggerSetTimer,
              child:
                  Text(
                  getFormattedTime(),
                  style: Theme.of(context).textTheme.headline1!.merge(
                      const TextStyle(
                        fontFeatures: [
                          FontFeature.tabularFigures(), // Ensure equal spacing between numbers  https://stackoverflow.com/a/60132909
                        ]
                      )
                    ),
                ),
            ),
        
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleTimer,
        tooltip: 'Increment',
        child: Icon(getTimerIconForTimerState(_timer_state)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Duration getElapsedFromMaxTime(){ 
    Duration milliseconds_elapsed = Duration(milliseconds: _stopwatch.elapsedMilliseconds);
    Duration elapsed_from_max_time = _max_time - milliseconds_elapsed;
    return elapsed_from_max_time;
  }
  String getFormattedTime(){
    Duration elapsed_from_max_time = getElapsedFromMaxTime();
    // Format the time differently in the last ten seconds. 
    if ((elapsed_from_max_time) >= Duration(seconds: 10)){    
      return "${elapsed_from_max_time.inMinutes}:${elapsed_from_max_time.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    } else if (elapsed_from_max_time > Duration(seconds: 0)) { 
      return "${elapsed_from_max_time.inSeconds.remainder(60)}.${elapsed_from_max_time.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    } else { 
      return "0";
    }
  }

}
