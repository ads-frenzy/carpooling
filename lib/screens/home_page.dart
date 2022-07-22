import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carpooling/screens/ride_request_page.dart';



class HomePageScreen extends StatelessWidget{
  const HomePageScreen({Key? key}) : super(key: key);

  Widget rideOptionButton(BuildContext context, final String rideType, int buttonColor){


    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideRequestScreen(rideType: rideType),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(buttonColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        size: 40,
                        color: Color(buttonColor),
                      )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '$rideType Ride',
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }
  Widget imageSection(){
    return Row(
      children: <Widget>[
        Expanded(flex:1, child:Image.asset('assets/images/carpool.jpeg',fit: BoxFit.fill)),
      ]
    );
  }
  Widget optionsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          rideOptionButton(context, "Offer", 0xFF5c6bc0),
          rideOptionButton(context, "Share", 0xFFec407a)
        ]
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.only(right: 10.0,left: 10.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              imageSection(),
              optionsSection(context)
            ]
          )
    );
  }
}