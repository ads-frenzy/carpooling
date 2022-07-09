class RideRequest {
	String userId;
	String? source;
  String? destination;
  DateTime? dateTime;
  String? rideType;

  RideRequest({
    required this.userId,
    this.source,
    this.destination,
    this.dateTime,
    this.rideType,
  });
}
