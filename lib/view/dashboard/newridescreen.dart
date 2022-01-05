import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/main.dart';
import 'package:bookit_driver_app/model/riderequestdetail.dart';
import 'package:bookit_driver_app/service/apiservice.dart';
import 'package:bookit_driver_app/service/mapkitservice.dart';
import 'package:bookit_driver_app/widgets/collectfaredialog.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({Key? key, required this.rideDetails}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newRideGoogleMapController;
  Set<Marker> markersSet = <Marker>{};
  Set<Circle> circlesSet = <Circle>{};
  Set<Polyline> polyLineSet = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions = const LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor? animatingMarkerIcon;
  Position? myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.blueAccent;
  Timer? timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }
  
  void createIconMarker() {
   if(animatingMarkerIcon == null) {
     ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
     BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/caricon.png").then((value) {
       animatingMarkerIcon = value;
     });
   }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = const LatLng(0,0);

    rideStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitService.getMarkerRotation(oldPos.latitude, oldPos.longitude, myPosition?.latitude, myPosition?.longitude);

      Marker animatingMarker =  Marker(
          markerId: const MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon!,
        rotation: rot,
        infoWindow: const InfoWindow(title: "Current Location")
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet.removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });
      oldPos = mPosition;
      updateRideDetails();

      String rideRequestId = widget.rideDetails.ride_request_id;
      Map locMap = {
        "latitude" : currentPosition!.latitude.toString(),
        "longitude" : currentPosition!.longitude.toString(),
      };
      newRequestRef.child(rideRequestId).child("drivers_location").set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          markers: markersSet,
          circles: circlesSet,
          polylines: polyLineSet,
          initialCameraPosition: NewRideScreen._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) async{
            _controllerGoogleMap.complete(controller);
            newRideGoogleMapController = controller;

            setState(() {
              mapPaddingFromBottom = 265;
            });

            var currentLatLng =LatLng(currentPosition!.latitude, currentPosition!.longitude);
            var pickUpLatLng  = widget.rideDetails.pickup;
            
           await getPlaceDirection(currentLatLng, pickUpLatLng);

           getRideLiveLocationUpdates();
          },
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
            height: 260,
            decoration: const BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                children: <Widget>[
                   Text(durationRide,
                      style: TextStyle(fontSize: 14, color: Colors.deepPurple)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  <Widget>[
                      Text(widget.rideDetails.rider_name, style: const TextStyle(fontSize: 24)),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.phone_android),
                      )
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: <Widget>[
                      Image.asset('assets/location.png', height: 16, width: 16),
                      const SizedBox(width: 18),
                      Expanded(
                          child: Container(
                        child: Text(
                          widget.rideDetails.pickup_address,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Image.asset('assets/location_pin.png', height: 16, width: 16),
                      const SizedBox(width: 18),
                      Expanded(
                          child: Container(
                        child: Text(
                          widget.rideDetails.dropoff_address,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () async{
                        if(status == "accepted") {
                          status = "arrived";
                          String rideRequestId = widget.rideDetails.ride_request_id;
                          newRequestRef.child(rideRequestId).child("status").set(status);

                          setState(() {
                            btnTitle = "Start Trip";
                            btnColor = Colors.purple;
                          });

                          Get.defaultDialog(
                            content: Row(
                              children: const <Widget>[
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                                SizedBox(width: 15),
                                Text('Please wait...')
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            title: '',
                          );
                          await getPlaceDirection(widget.rideDetails.pickup, widget.rideDetails.dropoff);

                          Get.back();
                        }
                        else if(status == "arrived") {
                          status = "onride";
                          String rideRequestId = widget.rideDetails.ride_request_id;
                          newRequestRef.child(rideRequestId).child("status").set(status);

                          setState(() {
                            btnTitle = "End Trip";
                            btnColor = Colors.redAccent;
                          });

                          initTimer();
                        }
                        else if (status == "onride") {
                          endTheTrip();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  <Widget>[
                          Text(
                            btnTitle,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 26,
                          )
                        ],
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(btnColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ))),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );

    var details = await APIService()
        .obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    Get.back();

    print("This is Encoded Points::");
    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointResult =
    polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();

    if (decodePolylinePointResult.isNotEmpty) {
      decodePolylinePointResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polylineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newRideGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pickUpLatLng,
      markerId: const MarkerId("pickUpId"),
    );

    Marker dropoffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: const MarkerId("dropoffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropoffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: const CircleId("pickUpId"));

    Circle dropoffLocCircle = Circle(
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
        circleId: const CircleId("dropOffId"));

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropoffLocCircle);
    });
  }

  void acceptRideRequest() {
    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestRef.child(rideRequestId).child("status").set("accepted");
    newRequestRef.child(rideRequestId).child("driver_name").set(driversInformation.name);
    newRequestRef.child(rideRequestId).child("driver_phone").set(driversInformation.phone);
    newRequestRef.child(rideRequestId).child("driver_id").set(driversInformation.id);
    newRequestRef.child(rideRequestId).child("car_details").set("${driversInformation.car_color} - ${driversInformation.car_model}");

    Map locMap = {
      "latitude" : currentPosition!.latitude.toString(),
      "longitude" : currentPosition!.longitude.toString(),
    };
    newRequestRef.child(rideRequestId).child("drivers_location").set(locMap);

    driversRef.child(currentfirebaseUser!.uid).child("history").child(rideRequestId).set(true);
  }

  void updateRideDetails() async{
    if(isRequestingDirection == false) {

      isRequestingDirection == true;

      if(myPosition == null) {
        return;
      }
      var posLatLng = LatLng(myPosition?.latitude ?? 0, myPosition?.longitude ?? 0);
      LatLng destinationLatLng;

      if(status == "accepted") {
        destinationLatLng = widget.rideDetails.pickup;
      } else {
        destinationLatLng = widget.rideDetails.dropoff;
      }

      var directionDetails = await APIService().obtainPlaceDirectionDetails(posLatLng, destinationLatLng);
      if(directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter +1;
    });
  }

  endTheTrip() async{
    timer?.cancel();

    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Please wait...')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    
    var currentLatLng = LatLng(myPosition?.latitude ?? 0, myPosition?.longitude ?? 0);
    
    var directionalDetails = await APIService().obtainPlaceDirectionDetails(widget.rideDetails.pickup, currentLatLng);

    Get.back();
    int fareAmount = APIService().calculateFares(directionalDetails!);

    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestRef.child(rideRequestId).child("fares").set(fareAmount.toString());
    newRequestRef.child(rideRequestId).child("status").set("ended");
    rideStreamSubscription.cancel();

    showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) => CollectFareDialog(paymentMethod: widget.rideDetails.payment_method, fareAmount: fareAmount)
    );

    saveEarnings(fareAmount);

  }

  void saveEarnings(int fareAmount) {
    driversRef.child(currentfirebaseUser!.uid).child("earnings").once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.value != null) {
        double oldEarnings = double.parse(dataSnapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;

        driversRef.child(currentfirebaseUser!.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
      else {
        double totalEarnings = fareAmount.toDouble();
        driversRef.child(currentfirebaseUser!.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
    });
  }

}
