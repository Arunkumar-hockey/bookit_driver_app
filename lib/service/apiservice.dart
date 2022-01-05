import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/helper/appdata.dart';
import 'package:bookit_driver_app/main.dart';
import 'package:bookit_driver_app/model/directiondetails.dart';
import 'package:bookit_driver_app/model/history.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';

import '../allpackages.dart';

class APIService {
  var dio = Dio();

  Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapkey";

    var response = await dio.get(directionUrl);

    if (response.statusCode == 200) {
      DirectionDetails directionDetails = DirectionDetails(
          distanceValue: 0,
          durationValue: 0,
          distanceText: "",
          durationText: "",
          encodedPoints: "");

      directionDetails.encodedPoints =
          response.data["routes"][0]["overview_polyline"]["points"];
      directionDetails.distanceText =
          response.data["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceValue =
          response.data["routes"][0]["legs"][0]["distance"]["value"];
      directionDetails.durationText =
          response.data["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationValue =
          response.data["routes"][0]["legs"][0]["duration"]["value"];

      return directionDetails;
    } else {
      return null;
    }
  }

  int calculateFares(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    if (rideType == "hatchback") {
     return totalFareAmount.truncate();
    } else if (rideType == "sedan") {
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    } else if (rideType == "XUV") {
      double result = (totalFareAmount.truncate()) * 3.0;
      return result.truncate();
    } else {
      return totalFareAmount.truncate();
    }

    //Local Currency
    //1$ = 160 RS
    //double totalLocalAmount = totalFareAmount * 160

    return totalFareAmount.truncate();
  }

  static void disablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentfirebaseUser!.uid);
  }

  static void enablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void retrieveHistoryInfo(context) {
    // Retrieve and display earnings
    driversRef
        .child(currentfirebaseUser?.uid ?? '')
        .child("earnings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    //retrieve and display trip history
    driversRef
        .child(currentfirebaseUser?.uid ?? '')
        .child("history")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Update total number of trip counts to provide
        Map<dynamic, dynamic> keys = snapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      newRequestRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
