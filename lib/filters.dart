import 'package:flutter/material.dart';

typedef updateRestaurantsCallback = void Function(double radius);

class FiltersDialog extends StatefulWidget {
  final updateRestaurantsCallback updateRestaurants;
  final double latestRadius;

  FiltersDialog({Key key, this.updateRestaurants, this.latestRadius})
      : super(key: key);

  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  double _radius;

  @override
  void initState() {
    super.initState();
    _radius = widget.latestRadius;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Radius',
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.all(32),
      children: [
        Slider(
          activeColor: Color(0xff99C7B1),
          min: 1000.0,
          max: 5000.0,
          value: _radius,
          onChanged: (newRadius) {
            setState(() {
              _radius = newRadius;
            });
          },
        ),
        RaisedButton(
          child: Text('Apply'),
          onPressed: () => {
            widget.updateRestaurants(_radius),
          },
          color: Color(0xff99C7B1),
          textColor: Color(0xffffffff),
        ),
      ],
    );
  }
}
