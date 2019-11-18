import 'dart:async';
import 'dart:convert';

import 'package:elect/elector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

// render our app
void main() {
  runApp(App());
}

// this function gets a list of Restuarant objects from the Places API
Future<List<Restaurant>> fetchRestaurants() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  String location = '${position.latitude},${position.longitude}';
  // load api key from secrets.json file
  String secrets = await rootBundle.loadString('assets/secrets.json');
  String apiKey = json.decode(secrets)['google_maps_api_key'];
  // set up the URI for the places API
  var uri =
      Uri.https('maps.googleapis.com', '/maps/api/place/nearbysearch/json', {
    'location': location,
    'radius': '2000',
    'type': 'restaurant',
    'keyword': 'restaurant',
    'key': '$apiKey'
  }).toString();
  print(uri);
  // send an http request using http.get
  // http.get returns a future that contains a response
  final response = await http.get(uri);
  // if we get a response, return a list of restaurants
  // otherwise, throw an error
  if (response.statusCode == 200) {
    // convert the response body into a JSON map
    var data = json.decode(response.body);
    // get the restaurants from the JSON data
    var restaurantsJson = data['results'] as List;
    // map through the restaurants and create a list of Restaurant objects
    List<Restaurant> restaurantsList = restaurantsJson
        .map<Restaurant>((restaurant) => Restaurant.fromJson(restaurant))
        .toList();
    return restaurantsList;
  } else {
    throw Exception('Failed to load restaurants');
  }
}

// this is a class that contains the data from an http request to the places api
// an instance of this class is a plain old dart object for a particular restaurant
class Restaurant {
  final String name;

  Restaurant({this.name});

  // this is factory constructor that creates a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // the state will take in a list of Restaurant objects
  Future<List<Restaurant>> restaurants;

  // fetch the restaurants using the fetchRestaurants function
  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: Scaffold(
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
      ),
    );
  }
}
