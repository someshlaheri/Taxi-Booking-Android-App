import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';


String mapKey = "AIzaSyBRy9A_Rb6mBff4RlxSrSm_rrnHOZ1pOtU";

User ?firebaseUser;

Users ?userCurrentInfo;

User ?currentfirebaseUser;

StreamSubscription<Position> ?homeTabPageStreamSubscription;
StreamSubscription<Position> ?rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position ?currentPosition;

Drivers ?driversInformation;

String title="";
double starCounter=0.0;

String rideType="";

