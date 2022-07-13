import 'package:carpooling/screens/ride_request_page.dart';
import 'package:carpooling/screens/search_places_page.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/screens/home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material App
    return const MaterialApp(
        title: 'Car Pooling',
        home: HomePageScreen()
    );
  }
}
