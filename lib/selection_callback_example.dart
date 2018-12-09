// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Timeseries chart with example of updating external state based on selection.
///
/// A SelectionModelConfig can be provided for each of the different
/// [SelectionModel] (currently info and action).
///
/// [SelectionModelType.info] is the default selection chart exploration type
/// initiated by some tap event. This is a different model from
/// [SelectionModelType.action] which is typically used to select some value as
/// an input to some other UI component. This allows dual state of exploring
/// and selecting data via different touch events.
///
/// See [SelectNearest] behavior on setting the different ways of triggering
/// [SelectionModel] updates from hover & click events.
// EXCLUDE_FROM_GALLERY_DOCS_START
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Graph(this.seriesList, {this.animate});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory Graph.withSampleData() {
    return new Graph(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesData, DateTime>> _createSampleData() {
    final play_data = [
      new TimeSeriesData(new DateTime(2017, 9, 19), 5),
      new TimeSeriesData(new DateTime(2017, 9, 26), 25),
      new TimeSeriesData(new DateTime(2017, 10, 3), 78),
      new TimeSeriesData(new DateTime(2017, 10, 10), 54),
    ];

    final health_data = [
      new TimeSeriesData(new DateTime(2017, 9, 19), 15),
      new TimeSeriesData(new DateTime(2017, 9, 26), 33),
      new TimeSeriesData(new DateTime(2017, 10, 3), 68),
      new TimeSeriesData(new DateTime(2017, 10, 10), 48),
    ];

    final work_data = [
      new TimeSeriesData(new DateTime(2017, 9, 19), 15),
      new TimeSeriesData(new DateTime(2017, 9, 26), 15),
      new TimeSeriesData(new DateTime(2017, 10, 3), 28),
      new TimeSeriesData(new DateTime(2017, 10, 10), 34),
    ];

    final love_data = [
      new TimeSeriesData(new DateTime(2017, 9, 19), 45),
      new TimeSeriesData(new DateTime(2017, 9, 26), 43),
      new TimeSeriesData(new DateTime(2017, 10, 3), 58),
      new TimeSeriesData(new DateTime(2017, 10, 10), 68),
    ];

    return [
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
  }
}

class _SelectionCallbackState extends State<Graph> {
  DateTime _time;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.value;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 360.0,
          child: new charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            behaviors: [
              new charts.PanAndZoomBehavior(),
            ],
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 24.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(
        new Padding(
          padding: new EdgeInsets.only(top: 4.0),
          child: new Text('${series}: ${value}')));

    });

    return new Column(children: children);
  }
}

/// Sample time series data type.
class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}
