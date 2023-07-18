import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails
{
  String pickup_address;
  String dropoff_address;
  LatLng pickup;
  LatLng dropoff;
  String ride_request_id;
  String payment_method;
  String rider_name;
  String rider_phone;

  RideDetails({required this.pickup_address, required this.dropoff_address, required this.pickup, required this.dropoff, required this.ride_request_id, required this.payment_method, required this.rider_name, required this.rider_phone});
}