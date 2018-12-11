import 'package:charts_common/src/data/series.dart';
import 'package:flutter/material.dart';
import 'package:pulse_check/slider_demo.dart';
import 'package:pulse_check/graph.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

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
      home: MyHomePage(title: 'Pulse Check', firestore: firestore)));
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

  final Firestore firestore;

  void _handleButtonPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SliderDemo(firestore)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title)),
      body: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(children: <Widget>[
            new SizedBox(
                height: 550.0,
                child: new Container(
                    child: new FutureBuilder(
                        future: getData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    List<
                                        charts
                                            .Series<TimeSeriesData, DateTime>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              return new Graph(snapshot.data, animate: true);
                            } else {
                              return new CircularProgressIndicator();
                            }
                          } else {
                            return new CircularProgressIndicator();
                          }
                        })))
          ])),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add), onPressed: _handleButtonPress),
    );
  }

  Future<List<charts.Series<TimeSeriesData, DateTime>>> getData() {
    Future<QuerySnapshot> snapshots = firestore.collection('pulses').getDocuments();
    return snapshots.then(transform);
  }

  List<charts.Series<TimeSeriesData, DateTime>> transform(QuerySnapshot snapshots) {
    List<DocumentSnapshot> documents = snapshots.documents;

    List<TimeSeriesData> play_data = [];
    List<TimeSeriesData> health_data = [];
    List<TimeSeriesData> work_data = [];
    List<TimeSeriesData> love_data = [];

    for (DocumentSnapshot document in documents) {
      DateTime datetime = new DateTime.fromMillisecondsSinceEpoch(1000 * document.data['created_at'].seconds);
      play_data.add(new TimeSeriesData(datetime, (document.data['play']).toInt()));
      work_data.add(new TimeSeriesData(datetime, (document.data['work']).toInt()));
      health_data.add(new TimeSeriesData(datetime, (document.data['health']).toInt()));
      love_data.add(new TimeSeriesData(datetime, (document.data['love']).toInt()));
    }

    List<charts.Series<TimeSeriesData, DateTime>> result = [
      new charts.Series<TimeSeriesData, DateTime>(
        id: 'Play',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: play_data,
      ),
      new charts.Series<TimeSeriesData, DateTime>(
        id: 'Health',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: health_data,
      ),
      new charts.Series<TimeSeriesData, DateTime>(
        id: 'Work',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: work_data,
      ),
      new charts.Series<TimeSeriesData, DateTime>(
        id: 'Love',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: love_data,
      )

    ];

    return result;
  }
}

/// Sample time series data type.
class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}
