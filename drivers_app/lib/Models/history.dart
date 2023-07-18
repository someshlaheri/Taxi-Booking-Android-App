import 'package:firebase_database/firebase_database.dart';

class History
{
  String paymentMethod='';
  String createdAt='';
  String status='';
  String fares='';
  String dropOff='';
  String pickup='';

  History({required this.paymentMethod, required this.createdAt, required this.status, required this.fares, required this.dropOff, required this.pickup});

  History.fromSnapshot(DataSnapshot snapshot)
  {
    paymentMethod = snapshot.value["payment_method"];
    createdAt = snapshot.value["created_at"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    dropOff = snapshot.value["dropoff_address"];
    pickup = snapshot.value["pickup_address"];
  }
}