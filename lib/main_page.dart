import 'package:flutter/material.dart';
import '_enums/score_is.dart';
import '_enums/timer_button_is.dart';
import 'dart:async';
import 'atoms/score.dart';
import 'atoms/timer.dart';
import 'atoms/timer_button.dart';
import 'atoms/person.dart';

// TODO: move this somewhere else?
// TODO: add teamName and scoreHistory
class PersonScoreSheet { 
  String name;
  int score = 0;
  String id;
   PersonScoreSheet({required this.name, this.score = 0, required this.id}) ;
}

 typedef  ScoreSheet = List<PersonScoreSheet>;

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  //this broadcasts enums out to both scores and the timer. they do things when they receive it
  //(and fire things back to tell the timer to stop)
  StreamController<ScoreIs> scoreController =
      StreamController<ScoreIs>.broadcast();

// no need to be broadcast cause only the button and the timer are talkin to each other
  StreamController<TimerButtonIs> timerAnimationController =
      StreamController<TimerButtonIs>.broadcast();
  ScoreSheet _scoreSheet = [PersonScoreSheet(name: "Fencer A", id:"left"), PersonScoreSheet(name: "Fencer B", id: "right")];

  @override
  void dispose() {
    scoreController.close();
    timerAnimationController.close();
    super.dispose();
  }
  // Function to return a given attribute about a certain fencer Key
  // E.g. getFencerNameLeft == getAttr(Attributes.name, "left")
  dynamic _getAttr(String attr, String id){ 
    // first person who matches the key
    PersonScoreSheet person =  _scoreSheet.firstWhere((element) => element.id == id); // todo error check this if not found
    switch (attr) {
      case "name":
        return person.name;
        break;
      case "score":
        return person.score;
        break;
      default:
        throw ArgumentError(["Request to update $attr failed as no attribute exists for that. ", "attr"]);
    }
    //if (!found) { 
    //  throw RangeError(["Request to update name failed because person does not exist with key of $key", "key"]);
    //}
  }
  void _updateAttr(String attr, String id, dynamic value){ 
    PersonScoreSheet person =  _scoreSheet.firstWhere((element) => element.id == id); // todo error check this if not found
    
    switch (attr) {
      case "name":

        if (value is String) { 
              setState(() {
                person.name = value;
              });
        } else { 
            throw ArgumentError(["Request to update name failed because value is the wrong type (${value.runtimeType}) expected String", "value"]);
        }
        break;
      case "score": 
        if (value is int) { 
          setState(() {
            person.score = value;
          });
        } else { 
            throw ArgumentError(["Request to update name failed because value is the wrong type (${value.runtimeType}) expected int", "value"]);
        }
        break;
      default:
        throw ArgumentError(["Request to update $attr failed as no attribute exists for that. ", "attr"]);
    }
    //if (!found) { 
    //  throw RangeError(["Request to update name failed because person does not exist with key of $key", "key"]);
    //}
    
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
            // Apply padding and max-width(todo) to all elements in the column
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
                      PersonWidget(
                        defaultName: "Fencer A", 
                        getName: () => _getAttr("name", "left"), 
                        updateName: (String value) => _updateAttr("name", "left", value), 
                        key: const Key("left"),
                      ),
                      PersonWidget(
                        defaultName: "Fencer B", 
                        getName: () => _getAttr("name", "right"),
                        updateName: (String value) => _updateAttr("name", "right", value), 
                        key: const Key("right"),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Score(
                      eventController: scoreController,
                      key: const Key("left"),
                    ),
                    Text('-', style: Theme.of(context).textTheme.headline4),
                    Score(
                      eventController: scoreController,
                      key: const Key("right"),
                    ),
                  ],
                ),
                // todo: style and size this better
                ElevatedButton(
                  onPressed: () =>
                      {scoreController.sink.add(ScoreIs.incrementing)},
                  child: const Text("Double"),
                ),
                FencingTimer(
                  key: const Key("timer"),
                  scoreController: scoreController,
                  buttonController: timerAnimationController,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: TimerButton(
          key: const Key("timerButton"),
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
