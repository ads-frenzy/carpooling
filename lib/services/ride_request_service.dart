import 'package:carpooling/models/ride_request.dart';
import 'package:carpooling/models/ride_type.dart';
import 'package:http/http.dart' as http;

class RideRequestService {
  static List<RideRequest> getMyRideRequests() {
    List<RideRequest> rideRequestList = List.from([
      RideRequest(
        userId: "msahiam",
        rideType: RideType.offerRide,
        source: "Amazon office",
        destination: "PBEL City",
        dateTime: DateTime.now()
      ),
      RideRequest(
        userId: "msahiam",
        rideType: RideType.requestRide,
        source: "Gachibowli",
        destination: "Amazon Office",
        dateTime: DateTime.now()
      )
    ]);
    return rideRequestList;
  }

  static Future<http.Response> submitRideRequest(RideRequest rideRequest){
    var params = Map<String, String>();
    var time = (rideRequest.dateTime?.hour.toString() ?? "00") + ":" + (rideRequest.dateTime?.minute.toString()?? "00");
    params['name'] = 'msahiam';
    params['lattitute'] = (rideRequest.destinationCoords?.latitude ?? 0.0).toString();
    params['longitude'] = (rideRequest.destinationCoords?.longitude ?? 0.0).toString();
    params['time'] = time;

    var uri = Uri.https('bddmbgcwwe.execute-api.us-east-1.amazonaws.com', '/beta/carpoolmatch', params);
    var response = http.get(uri);
    print("Response: " + response.toString());
    return response;
  }
}
