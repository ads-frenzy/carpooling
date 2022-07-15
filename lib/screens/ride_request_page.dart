import 'dart:async';
import 'package:carpooling/models/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carpooling/screens/search_places_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:carpooling/models/ride_request.dart';
import 'package:carpooling/models/coordinates.dart';
import 'package:carpooling/models/ride_type.dart';
import 'package:carpooling/services/ride_request_service.dart';
import '../utils/map_utils.dart';
import 'list_ride_request_screen.dart';

class RideRequestScreen extends StatefulWidget {
  final String rideType;
  const RideRequestScreen({Key? key, required this.rideType}) : super(key: key);
  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final formKey = GlobalKey<FormState>();
  late final DetailsResult? selectedLocation;
  late CameraPosition _initialPosition;
  final TextEditingController pickupLocation = TextEditingController();
  final TextEditingController dropLocation = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();
  final double amazonOfficeLatitude = 17.42015436;
  final double amazonOfficeLongitude = 78.3455879;
  late double selectedLocationLatitude;
  late double selectedLocationLongitude;
  final String amazonLocationName = "Amazon Hyderabad Campus(HYD13)";
  late Set<Marker> markers;
  late BitmapDescriptor mapMarker;
  Set<Polyline> polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  DateTime? pickeddate;
  TimeOfDay? pickedTime;
  late Coordinates source;
  late Coordinates destination;

  Future<void> selectDate(BuildContext context) async {
    pickeddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5)
    );
    if (pickeddate != null) {
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(pickeddate!);
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      setState(() {
        time.text = pickedTime!.format(context);
      });
    }
  }

  void setCustomMarker() async{
    mapMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/images/source_icon_2-removebg-preview.png');
  }
  void setMarkers(sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude){
    setState(() {
      markers = {
        Marker(
            markerId: const MarkerId('source'),
            position: LatLng(sourceLatitude, sourceLongitude),
            icon: mapMarker
        ),
        Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(destinationLatitude, destinationLongitude)
        )
      };
    });
  }
  _addPolylines() {
    PolylineId id = const PolylineId("poly");
    polylines.add(
        Polyline(
            width: 5,
            polylineId: id,
            points: polylineCoordinates,
            color: Colors.green
        )
    );
  }
  _getPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCZ_vHda4OAfuaV_9E81pjZb9XqJPphEDg",
        PointLatLng(amazonOfficeLatitude, amazonOfficeLongitude),
        PointLatLng(selectedLocationLatitude, selectedLocationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _addPolylines();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(amazonOfficeLatitude, amazonOfficeLongitude),
      zoom: 14,
    );
    markers = {};
    polylinePoints = PolylinePoints();
    source = new Coordinates(latitude: 0, longitude: 0);
    destination = new Coordinates(latitude: 0, longitude: 0);
    setCustomMarker();
  }

  void _combineSelectedDateAndTime(){
    pickeddate = DateTime(pickeddate!.year, pickeddate!.month, pickeddate!.day, pickedTime!.hour, pickedTime!.minute);
  }

  RideRequest createRideRequestObject(){
    final rideType = widget.rideType == "Offer" ?  RideType.offerRide : RideType.requestRide;
    final rideRequest =  RideRequest(
      userId: "yuktha",
      source: pickupLocation.text,
      sourceCoords: source,
      destination: dropLocation.text,
      destinationCoords: destination,
      dateTime: pickeddate,
      rideType: rideType
    );
    return rideRequest;
  }

  @override
  Widget build(BuildContext context) {
    final width =  MediaQuery.of(context).size.width;
    final height =  MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: height * 0.6,
                  child: GoogleMap(
                    polylines: polylines,
                    initialCameraPosition: _initialPosition,
                    markers: Set.from(markers),
                    onMapCreated: (GoogleMapController controller) {
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        controller.animateCamera(CameraUpdate.newLatLngBounds(
                            MapUtils.boundsFromLatLngList(
                                markers.map((loc) => loc.position).toList()),
                            1));
                      });
                    },
                  ),
                ),
                SizedBox(
                    height: height * 0.4,
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Row(
                                    children: [
                                      Column(
                                          children:[
                                            SizedBox(
                                              width: width * 0.9,
                                              height: height * 0.072,
                                              child: TextField(
                                                  controller: pickupLocation,
                                                  enabled: true,
                                                  readOnly: true,
                                                  onTap: () async{
                                                    selectedLocation = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const SearchPlacesScreen()),
                                                    );
                                                    setState(() {
                                                      pickupLocation.text = selectedLocation!.name!;
                                                      selectedLocationLatitude = selectedLocation!.geometry!.location!.lat!;
                                                      selectedLocationLongitude = selectedLocation!.geometry!.location!.lng!;
                                                      dropLocation.text = amazonLocationName;
                                                      source.latitude = selectedLocationLatitude;
                                                      source.longitude = selectedLocationLongitude;
                                                      destination.latitude = amazonOfficeLatitude;
                                                      destination.longitude = amazonOfficeLongitude;
                                                    });
                                                    setMarkers(
                                                        selectedLocationLatitude,
                                                        selectedLocationLongitude,
                                                        amazonOfficeLatitude,
                                                        amazonOfficeLongitude
                                                    );
                                                    _getPolylines();
                                                  },
                                                  style: GoogleFonts.lato(
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  decoration: const InputDecoration(
                                                    hintText: "Enter pickup location",
                                                    icon: Icon(Icons.location_on, color: Colors.green), //icon at head of input
                                                  )
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.9,
                                              height: height * 0.072,
                                              child: TextField(
                                                  enabled: true,
                                                  readOnly: true,
                                                  controller: dropLocation,
                                                  onTap: () async{
                                                    selectedLocation = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const SearchPlacesScreen()),
                                                    );
                                                    setState(() {
                                                      dropLocation.text = selectedLocation!.name!;
                                                      pickupLocation.text = amazonLocationName;
                                                      selectedLocationLatitude = selectedLocation!.geometry!.location!.lat!;
                                                      selectedLocationLongitude = selectedLocation!.geometry!.location!.lng!;
                                                      source.latitude = amazonOfficeLatitude;
                                                      source.longitude = amazonOfficeLongitude;
                                                      destination.latitude = selectedLocationLatitude;
                                                      destination.longitude = selectedLocationLongitude;
                                                    });
                                                    setMarkers(
                                                      amazonOfficeLatitude,
                                                      amazonOfficeLongitude,
                                                      selectedLocationLatitude,
                                                      selectedLocationLongitude,
                                                    );
                                                    _getPolylines();
                                                  },
                                                  style: GoogleFonts.lato(
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  decoration: const InputDecoration(
                                                    hintText: "Enter drop location",
                                                    icon: Icon(Icons.location_on, color: Colors.red), //icon at head of input
                                                  )
                                              ),
                                            )
                                          ]
                                      )
                                    ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: width * 0.35,
                                        height: height * 0.072,
                                        child: TextField(
                                            controller: date,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600
                                            ),
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons.calendar_today_rounded, color: Colors.blue),
                                                labelText: "Select Date"
                                            ),
                                            readOnly: true,
                                            onTap: () async{
                                              selectDate(context);
                                            }
                                        )
                                    ),
                                    SizedBox(
                                        width: width * 0.35,
                                        height: height * 0.072,
                                        child: TextField(
                                            controller: time,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600
                                            ),
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons.timer_outlined, color: Colors.deepPurple),
                                                labelText: "Select Time"
                                            ),
                                            onTap: () async{
                                              selectTime(context);
                                            }
                                        )
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: SizedBox(
                                      width: width * 0.35,
                                      height: height * 0.072,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xFF17a2b8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        ),
                                        child: Text(
                                          "Request",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        onPressed: () {
                                          _combineSelectedDateAndTime();
                                          final rideRequest = createRideRequestObject();
                                          RideRequestService.submitRideRequest(rideRequest);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ListRideRequestScreen()),
                                          );
                                        },
                                      ),
                                    )
                                )
                              ],
                            )
                        )
                    )
                )
              ]
          )
        )
    );
  }
}

