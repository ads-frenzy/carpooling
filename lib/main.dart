import 'package:carpooling/screens/list_ride_request_screen.dart';
import 'package:carpooling/screens/ride_request_page.dart';
import 'package:carpooling/screens/search_places_page.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/screens/home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Car Pooling';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: BaseAppWidget(),
    );
  }
}

class BaseAppWidget extends StatefulWidget {
  const BaseAppWidget({Key? key}) : super(key: key);

  @override
  State<BaseAppWidget> createState() => _BaseAppWidgetState();
}


class _BaseAppWidgetState extends State<BaseAppWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePageScreen(),
    ListRideRequestScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carpool'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Rides',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
