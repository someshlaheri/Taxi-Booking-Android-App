import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/Models/allUsers.dart';

String mapKey = "AIzaSyBRy9A_Rb6mBff4RlxSrSm_rrnHOZ1pOtU";

late User firebaseUser;

late Users userCurrentInfo;

int driverRequestTimeOut = 40;

String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";

double starCounter=0.0;
String title="";
String carRideType="";


String serverToken = "key=AAAAoWfoEb0:APA91bEMrve1tM24jWpUp7xVfBdp7PFNf5q7javezM1Rigwd9MBUHhXXwuiRXV4gTFMbCa5l5NqTtxtbCBMxqHmHu51RFpS37887q6hoc8u2lauuWGzrgvvwCAeVqb8sehUi3yWaX9p4";