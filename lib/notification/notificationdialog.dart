import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/main.dart';
import 'package:bookit_driver_app/model/riderequestdetail.dart';
import 'package:bookit_driver_app/service/apiservice.dart';
import 'package:bookit_driver_app/view/dashboard/newridescreen.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;
  const NotificationDialog({Key? key, required this.rideDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            Image.asset('assets/car.png', width: 120),
            const SizedBox(height: 18),
            const Text('New Ride Request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/location.png', height: 25, width: 25),
                      const SizedBox(width: 20),
                      Expanded(
                          child: Container(
                        child: Text(
                          rideDetails.pickup_address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/location_pin.png',
                          height: 16, width: 16),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.dropoff_address,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 2.0,
              color: Colors.black,
              thickness: 2.0,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      player.stop();
                      Get.back();
                    },
                    child: Text("Cancel".toUpperCase(),
                        style: const TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ))),
                  ),
                  const SizedBox(width: 25),
                  ElevatedButton(
                    onPressed: () {
                      player.stop();
                      checkAvailabilityOfRide(context);
                    },
                    child: Text("Accept".toUpperCase(),
                        style: const TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context) {
    rideRequestRef.once().then((DataSnapshot dataSnapshot) {
      Get.back();
      String theRideId = "";
      if (dataSnapshot.value != null) {
        theRideId = dataSnapshot.value.toString();
      } else {
        Fluttertoast.showToast(
            msg: "Ride not exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      }
      if (theRideId == rideDetails.ride_request_id) {
        rideRequestRef.set(
          "accepted",
        );
        APIService.disablehomeTabLiveLocationUpdates();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewRideScreen(rideDetails: rideDetails)));
        print(rideDetails.pickup);
      } else if (theRideId == "cancelled") {
        Fluttertoast.showToast(
            msg: "Ride has been cancelled",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      } else if (theRideId == "timeout") {
        Fluttertoast.showToast(
            msg: "Ride has time out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      } else {
        Fluttertoast.showToast(
            msg: "Ride not exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      }
    });
  }
}
