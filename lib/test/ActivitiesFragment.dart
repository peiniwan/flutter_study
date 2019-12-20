import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(new Center(child: new LifecycleWatcher()));//生命周期
}

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => new _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState _lastLifecyleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecyleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (_lastLifecyleState == null)
//      return new Text('This widget has not observed any lifecycle changes.',
//          textDirection: TextDirection.ltr);
//    return new Text(
//        'The most recent lifecycle state this widget observed was: $_lastLifecyleState.',
//        textDirection: TextDirection.ltr);

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Row One'),
        new Text('Row Two'),
        new Text('Row Three'),
        new Text('Row Four'),
      ],
    );
  }
}

//动画
//AnimationController controller;
//CurvedAnimation curve;
//
//@override
//void initState() {
//  controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
//  curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
//}
//
//class SampleApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        body: new Center(
//          child: new GestureDetector(
//            child: new RotationTransition(
//                turns: curve,
//                child: new FlutterLogo(
//                  size: 200.0,
//                )),
//            onDoubleTap: () {
//              if (controller.isCompleted) {
//                controller.reverse();
//              } else {
//                controller.forward();
//              }
//            },
//          ),
//        ));
//  }
//}
