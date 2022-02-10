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
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  int _left_count = 0;
  int _right_count = 0;
  TimerState _timer_state = TimerState.paused;
  Duration _max_time = Duration(minutes: 0, seconds: 20);
  late Timer _timer;
  Stopwatch _stopwatch = Stopwatch();
  String _personLeft = "Fencer A";
  String _personRight = "Fencer B";

  late AnimationController myTimerAnimation;
  @override 
  void initState(){ 
    super.initState();
    myTimerAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  }
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
  void _incrementLeftCount() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _left_count++;
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
    });
  }
  
  String _getPersonLeft() { 
    return _personLeft;
  }
  String _getPersonRight() { 
    return _personRight;
  }
  void _updatePersonLeft(String newName) { 
    _personLeft = newName;
  }
  void _updatePersonRight(String newName) { 
    _personRight = newName;
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
          myTimerAnimation.forward();
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
          myTimerAnimation.reverse();
          _timer_state = TimerState.paused;
          _stopwatch.stop();
          _timer.cancel();
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
        child: Padding(
          // todo: https://stackoverflow.com/a/65273656
          padding: const EdgeInsets.fromLTRB(30.0, 4.0, 30.0, 4.0),
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
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PersonWidget(getName: _getPersonLeft, updateName: _updatePersonLeft),
                  PersonWidget(getName: _getPersonRight,updateName: _updatePersonRight),
                ],
              ),
              Column(
                children: <Widget>[

                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MyScore(counter: _left_count, incrementCounter: _incrementLeftCount, decrementCounter: _decrementLeftCount, key: const Key("1"),),

                      Text('-', 
                      style: Theme.of(context).textTheme.headline4), 
                      MyScore(counter: _right_count, incrementCounter: _incrementRightCount, decrementCounter: _decrementRightCount, key: const Key("2"),),
                    ],
                  ),
                  // todo: style and size this better
                  ElevatedButton(
                    onPressed: () => {
                      _incrementLeftCount(),
                      _incrementRightCount()
                    }, 
                    child: const Text("Double"), 
                  ),
                  ]
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleTimer,
        tooltip: 'Increment',
        child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: myTimerAnimation,),
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
    if ((elapsed_from_max_time) >= Duration(seconds: 10)){    
      return "${elapsed_from_max_time.inMinutes}:${elapsed_from_max_time.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    } else if (elapsed_from_max_time > Duration(seconds: 0)) { 
      return "${elapsed_from_max_time.inSeconds.remainder(60)}.${elapsed_from_max_time.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    } else { 
      return "0";
    }
  }

}
