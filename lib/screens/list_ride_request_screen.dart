import 'package:carpooling/models/ride_request.dart';
import 'package:carpooling/services/ride_request_service.dart';
import 'package:flutter/material.dart';

class ListRideRequestScreen extends StatefulWidget {
  const ListRideRequestScreen({Key? key}) : super(key: key);

  @override
  State<ListRideRequestScreen> createState() => _ListRideRequestScreenState();
}

class _ListRideRequestScreenState extends State<ListRideRequestScreen> {
  List<RideRequest> rideRequestList = RideRequestService.getMyRideRequests();

  Widget getRideRequestTile(BuildContext context, int index) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(),
        title: Text(rideRequestList[index].rideType.toString().split('.').last),
        subtitle: Text("Ride from " + (rideRequestList[index].source ?? "") + " to " + (rideRequestList[index].destination ?? "")),
        isThreeLine: true,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: getRideRequestTile,
      itemCount: rideRequestList.length,
    );
  }
}
