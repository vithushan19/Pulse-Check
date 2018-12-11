// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SliderDemo extends StatefulWidget {
  static const String routeName = '/material/slider';

  final firestore;

  SliderDemo(this.firestore);

  @override
  _SliderDemoState createState() => _SliderDemoState(firestore);
}

class _SliderDemoState extends State<SliderDemo> {
  double _loveValue = 40.0;
  double _healthValue = 20.0;
  double _workValue = 50.0;
  double _playValue = 80.0;

  final firestore;
  CollectionReference get pulses => firestore.collection('pulses');

  _SliderDemoState(this.firestore);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliders'),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.done),
          tooltip: 'Submit',
          onPressed: _submit,
        )],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Slider(
                  value: _loveValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '${_loveValue.round()}',
                  onChanged: (double value) {
                    setState(() {
                      _loveValue = value;
                    });
                  },
                  activeColor: Colors.red,
                ),
                const Text('Love'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Slider(
                  value: _workValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '${_workValue.round()}',
                  onChanged: (double value) {
                    setState(() {
                      _workValue = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const Text('Work'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Slider(
                  value: _healthValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '${_workValue.round()}',
                  onChanged: (double value) {
                    setState(() {
                      _healthValue = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                const Text('Health'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Slider(
                  value: _playValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '${_workValue.round()}',
                  onChanged: (double value) {
                    setState(() {
                      _playValue = value;
                    });
                  },
                  activeColor: Colors.yellow,
                ),
                const Text('Play'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    await _savePulse();
    Navigator.pop(context);
    return;
  }

  Future<void> _savePulse() async {
    await pulses.add(<String, dynamic>{
      'user': 'vithushan',
      'created_at': FieldValue.serverTimestamp(),
      'love': _loveValue,
      'health': _healthValue,
      'play': _playValue,
      'work': _workValue
    });
  }
}