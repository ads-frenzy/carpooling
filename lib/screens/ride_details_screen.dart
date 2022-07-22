import 'dart:convert';
import 'package:carpooling/models/ride_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpooling/services/local_push_notification.dart';

sendNotification(String title, String token)async{

  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title
  };

  try{
    http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA6j6QE7Q:APA91bGChvir_pLL5ZIlSEoxH891OVI2RZerRvKAp1ldFkXV9IpckFu4JNgL2mxS7aJdkqNtYgQ1xEwkfOrw1ZRv9xcPKw2dNs6g0l9Us1oacaembnr3uv7pbzi_5HPkTipmPbw3rXdq'
    },
        body: jsonEncode(<String,dynamic>{
          'notification': <String,dynamic> {'title': title,'body': 'Notification'},
          'priority': 'high',
          'data': data,
          'to': token
        })
    );


    if(response.statusCode == 200){
      print("Notification sent successfully");
    }else{
      print("Error");
    }

  }catch(e){
  }
}

storeNotificationToken()async {

  String? token = await FirebaseMessaging.instance.getToken();
  sendNotification("Match Found", token!);
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
      {
        'token': token
      });

}
class RideDetailsScreen extends StatelessWidget {
  final RideRequest ride;

  const RideDetailsScreen({Key? key, required this.ride}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    storeNotificationToken();
    return Scaffold(
        appBar: AppBar(title: const Text("Ride Details")),
        body: Column(children: [
          Text("Ride Type: " + ride.rideType
              .toString()
              .split('.')
              .last),
          Text("Ride from " + (ride.source ?? "") + " to " +
              (ride.destination ?? "")),
          Text("Date time:" + ride.dateTime.toString()),
          Text("Matched people: "),
        ],)
    );
  }
}


