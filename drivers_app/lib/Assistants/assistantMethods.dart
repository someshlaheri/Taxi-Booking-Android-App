import 'package:drivers_app/Models/history.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/Assistants/requestAssistant.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/Models/address.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:drivers_app/Models/directDetails.dart';
import 'package:drivers_app/configMaps.dart';

class AssistantMethods
{
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed")
    {
      return null;
    }

    DirectionDetails directionDetails = new DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 5;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 5;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //Local Currency
    //1$ = 75 RS
    //double totalLocalAmount = totalFareAmount * 75;
    if (rideType == "uber-x") {
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    }
    else if (rideType == "uber-go") {
      return totalFareAmount.truncate();
    }
    else if (rideType == "bike") {
      double result = (totalFareAmount.truncate()) / 2.0;
      return result.truncate();
    }
    else {
      return totalFareAmount.round();
    }
  }


  static void disableHomeTabLiveLocationUpdates()
  {
    homeTabPageStreamSubscription?.pause();
    Geofire.removeLocation(currentfirebaseUser?.uid);
  }

  static void enableHomeTabLiveLocationUpdates()
  {
    homeTabPageStreamSubscription?.resume();
    Geofire.setLocation(currentfirebaseUser?.uid, currentPosition?.latitude, currentPosition?.longitude);
  }

  static void retrieveHistoryInfo(context)
  {
    //retrieve and display Earnings
    driversRef.child(currentfirebaseUser?.uid).child("earnings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        String earnings = dataSnapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    //retrieve and display Trip History
    driversRef.child(currentfirebaseUser!.uid).child("history").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        //update total number of trip counts to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
       Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
       obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
    {
      newRequestsRef.child(key).once().then((DataSnapshot snapshot) {
        if(snapshot.value != null)
        {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}