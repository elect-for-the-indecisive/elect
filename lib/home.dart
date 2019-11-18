import 'dart:async';

import 'package:elect/elector.dart';
import 'package:flutter/material.dart';

import './restaurants.dart';
import './filters.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // the state will take in a list of Restaurant objects
  Future<List<Restaurant>> restaurants;
  double radius = 2000;

  _updateRestaurantsState(double newRadius) {
    setState(() {
      radius = newRadius;
      restaurants = fetchRestaurants(radius.toString());
    });
    Navigator.pop(context);
  }

  _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FiltersDialog(updateRestaurants: _updateRestaurantsState, latestRadius: radius);
      },
    );
  }

  // fetch the restaurants using the fetchRestaurants function
  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants(radius.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3E587D),
      appBar: AppBar(
        backgroundColor: Color(0xffBAD7F2),
        title: Text(
          'Elect',
          style: TextStyle(
              fontSize: 24,
              color: Color(0xff3E587D),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          new IconButton(
            icon: Icon(Icons.edit), //filter_list
            onPressed: () => _showFiltersDialog(),
          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xff3E587D)),
      ),
      body: Center(
        child:
            // use the FutureBuilder widget to display the data
            // this widget is provided by Flutter
            // it makes it easy to work with async data sources
            // it takes in two parameters: future and builder
            FutureBuilder<List<Restaurant>>(
                // future refers to the future you want to work with
                // in this case, the future returned from fetchRestaurants
                future: restaurants,
                // builder is a function that tells Flutter what to render
                // depending on the state of the future (loading, success, or error)
                builder: (context, snapshot) {
                  // if data is returned, render the RestaurantList widget
                  if (snapshot.hasData) {
                    return Elector(restaurants: snapshot.data);
                    // if no data is returned, show the error
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // by default, show a loading spinner.
                  return CircularProgressIndicator();
            }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Icon(
                Icons.restaurant,
                size: 80,
                color: Color(0xffffffff),
              ),
              decoration: BoxDecoration(color: Color(0xff99C7B1)),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Color(0xff99C7B1),
              ),
              title: Text(
                'Log In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff99C7B1),
                ),
              ),
              onTap: () {
                // Update the state of the app
              },
            ),
          ],
        ),
      ),
    );
  }
}
