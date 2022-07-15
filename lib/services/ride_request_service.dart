import 'package:carpooling/models/ride_request.dart';
import 'package:carpooling/models/ride_type.dart';

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
}
