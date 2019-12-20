import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

//void main() {
//  runApp(new MaterialApp(
//    home: new MyAppHome(), // becomes the route named '/'
//    routes: <String, WidgetBuilder> {
//      '/a': (BuildContext context) => new MyPage(title: 'page A'),
//      '/b': (BuildContext context) => new MyPage(title: 'page B'),
//      '/c': (BuildContext context) => new MyPage(title: 'page C'),
//    },
//  ));
//}


void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: new ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  Widget getRow(int i) {
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i]["title"]}")
    );
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}

//class SampleApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Sample Shared App Handler',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new SampleAppPage(),
//    );
//  }
//}
//
//class SampleAppPage extends StatefulWidget {
//  SampleAppPage({Key key}) : super(key: key);
//
//  @override
//  _SampleAppPageState createState() => new _SampleAppPageState();
//}
//
//class _SampleAppPageState extends State<SampleAppPage> {
//  static const platform = const MethodChannel('app.channel.shared.data');
//  String dataShared = "No data";
//
//  @override
//  void initState() {
//    super.initState();
//    getSharedText();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(body: new Center(child: new Text(dataShared)));
//  }
//
//  getSharedText() async {
//    var sharedData = await platform.invokeMethod("getSharedText");
//    if (sharedData != null) {
//      setState(() {
//        dataShared = sharedData;
//      });
//    }
//  }
//}
