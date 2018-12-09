import 'package:flutter/material.dart';
import 'package:pulse_check/slider_demo.dart';
import 'package:pulse_check/selection_callback_example.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'Pulse Check',
    options: const FirebaseOptions(
      googleAppID: '1:600826542746:android:7a3c5d9fdfd492c9',
      gcmSenderID: '600826542746',
      apiKey: 'AIzaSyA3F0VGb94n-9FjiHwTr5AuGupnBvL8JuA',
      projectID: 'pulse-check-d94a9',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MaterialApp(
      title: 'Firestore Example',
      home: MyHomePage(
          title: 'Pulse Check',
          firestore: firestore)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pulse Check'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.firestore}) : super(key: key);

  final String title;
  final Firestore firestore;

  @override
  _MyHomePageState createState() => _MyHomePageState(firestore);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.firestore);

  final firestore;


  void _handleButtonPress() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SliderDemo(firestore)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title)),
      body: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(children: <Widget>[
            new SizedBox(height: 550.0, child:  Graph.withSampleData()),
          ])),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add), onPressed: _handleButtonPress),
    );
  }
}
