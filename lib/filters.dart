import 'package:flutter/material.dart';

typedef updateRestaurantsCallback = void Function(String radius);

class FiltersDialog extends StatefulWidget {
  final updateRestaurantsCallback updateRestaurants;

  FiltersDialog({Key key, this.updateRestaurants}) : super(key: key);

  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  double _radius = 2000;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Filters'),
      contentPadding: EdgeInsets.all(32),
      children: [
        Slider(
          label: 'Radius',
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
            widget.updateRestaurants(_radius.toString()),
            Navigator.pop(context),
          },
          color: Color(0xff99C7B1),
          textColor: Color(0xffffffff),
        ),
      ],
    );
  }
}
