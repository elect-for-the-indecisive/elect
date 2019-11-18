import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

import './restaurants.dart';

// Elector is a stateful widget
class Elector extends StatefulWidget {
  // the Elector widget will take in a list of Restaurant objects
  final List<Restaurant> restaurants;

  // constructor for a stateful widget
  Elector({Key key, this.restaurants}) : super(key: key);

  @override
  _ElectorState createState() => _ElectorState();
}

// define the state for the Elector widget
class _ElectorState extends State<Elector> {
  // a StreamController allows you to send events on a stream
  final StreamController _dividerController = StreamController<int>();

  // close the stream
  dispose() {
    _dividerController.close();
  }

  // define the build method for the Elector widget
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // this is widget provided by the flutter_spinning_wheel package
        SpinningWheel(
          Image(image: AssetImage('assets/images/wheel.png')),
          width: 310,
          height: 310,
          dividers: 12,
          onUpdate: _dividerController
              .add, // sends index of current slice to the stream
          onEnd: _dividerController
              .add, // sends index of chosen slice to the stream
          secondaryImage:
              Image(image: AssetImage('assets/images/triangle.png')),
          secondaryImageHeight: 50,
          secondaryImageWidth: 50,
          secondaryImageTop: 0,
        ),
        // StreamBuilder is a widget that builds itself based on the latest snapshot of a Stream
        // a Stream provides a way to receive events
        StreamBuilder(
          stream: _dividerController.stream,
          builder: (context, snapshot) => snapshot.hasData
              ? WheelStatus(snapshot.data, widget.restaurants)
              : Container(),
        )
      ],
    );
  }
}

class WheelStatus extends StatelessWidget {
  // this widget takes in an index as its state
  final int selected;

  final List<Restaurant> restaurants;

  // constructor
  WheelStatus(this.selected, this.restaurants);

  // display the current value of the wheel in a Text widget
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Text(
        '${restaurants[selected].name}',
        style: TextStyle(
          fontSize: 24.0,
          color: Color(0xffBAD7F2),
        ),
      ),
    );
  }
}
