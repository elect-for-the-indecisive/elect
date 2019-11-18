import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

// this function gets a list of Restuarant objects from the Places API
Future<List<Restaurant>> fetchRestaurants(radius) async {
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
    'radius': radius,
    'type': 'restaurant',
    'keyword': 'restaurant',
    'key': '$apiKey'
  }).toString();
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