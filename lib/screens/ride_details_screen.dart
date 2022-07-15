import 'package:carpooling/models/ride_request.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideRequest ride;
  const RideDetailsScreen({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Ride Details")),
      body: Column(children: [
        Text("Ride Type: " + ride.rideType.toString().split('.').last),
        Text("Ride from " + (ride.source ?? "") + " to " + (ride.destination ?? "")),
        Text("Date time:" + ride.dateTime.toString()),
        Text("Matched people: "),
      ],)
    ); 
  }
}

