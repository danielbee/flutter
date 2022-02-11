import 'package:flutter/material.dart';
import '_enums/score_is.dart';
import '_enums/timer_button_is.dart';
import 'dart:async';
import 'atoms/score.dart';
import 'atoms/timer.dart';
import 'atoms/timer_button.dart';

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  //this broadcasts enums out to both scores and the timer. they do things when they receive it
  //(and fire things back to tell the timer to stop)
  StreamController<ScoreIs> scoreController =
      StreamController<ScoreIs>.broadcast();

// no need to be broadcast cause only the button and the timer are talkin to each other
  StreamController<TimerButtonIs> timerAnimationController =
      StreamController<TimerButtonIs>.broadcast();

  @override
  void dispose() {
    scoreController.close();
    timerAnimationController.close();
    super.dispose();
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
                      eventController: scoreController,
                      key: const Key("Left"),
                    ),
                    Text('-', style: Theme.of(context).textTheme.headline4),
                    Score(
                      eventController: scoreController,
                      key: const Key("Right"),
                    ),
                  ],
                ),
              ),
              // todo: style and size this better
              ElevatedButton(
                onPressed: () =>
                    {scoreController.sink.add(ScoreIs.incrementing)},
                child: const Text("Double"),
              ),
              FencingTimer(
                key: const Key("Timer"),
                scoreController: scoreController,
                buttonController: timerAnimationController,
              )
            ],
          ),
        ),
        floatingActionButton: TimerButton(
          key: const Key("TimerButton"),
          eventController: timerAnimationController,
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
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
