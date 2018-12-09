import 'package:flutter/material.dart';
import 'package:pulse_check/slider_demo.dart';
import 'package:pulse_check/selection_callback_example.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pulse Ckheck'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _handleButtonPress() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SliderDemo()));
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
          child: new Icon(Icons.refresh), onPressed: _handleButtonPress),
    );
  }
}
