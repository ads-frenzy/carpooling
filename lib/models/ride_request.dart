import 'package:carpooling/models/coordinates.dart';
import 'package:carpooling/models/ride_type.dart';

class RideRequest {
	String userId;
	String? source;
  Coordinates? sourceCoords;
  String? destination;
  Coordinates? destinationCoords;
  DateTime? dateTime;
  RideType? rideType;

  RideRequest({
    required this.userId,
    this.source,
    this.sourceCoords,
    this.destination,
    this.destinationCoords,
    this.dateTime,
    this.rideType,
  });
}
