import 'package:carpooling/models/coordinates.dart';
import 'package:carpooling/models/ride_type.dart';
class MatchedRides{
  String userId;
  String requestId;
  MatchedRides(
  {
    required this.userId,
    required this.requestId
  });
}

class RideRequest {
	String userId;
	String? source;
  Coordinates? sourceCoords;
  String? destination;
  Coordinates? destinationCoords;
  DateTime? dateTime;
  RideType? rideType;
  bool? isMatched;
  List<MatchedRides>? matchedRides;
  RideRequest({
    required this.userId,
    this.source,
    this.sourceCoords,
    this.destination,
    this.destinationCoords,
    this.isMatched,
    this.dateTime,
    this.rideType,
    this.matchedRides,
  });
}
