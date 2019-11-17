// provides StatelessWidget class
import 'package:flutter/material.dart';

// provides Restaurant class
import './main.dart';

// RestaurantList is a stateless widget
class RestaurantList extends StatelessWidget {
  // it will take in a list of Restuarant objects
  final List<Restaurant> restaurants;
  // constructor (uses shorthand notation)
  RestaurantList(this.restaurants);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: restaurants.length,
        padding: EdgeInsets.all(4),
        itemBuilder: (context, position) {
          return Text('${restaurants[position].name}');
        },
      ),
    );
  }
}
