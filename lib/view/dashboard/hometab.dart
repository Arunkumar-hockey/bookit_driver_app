import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/main.dart';
import 'package:bookit_driver_app/model/drivers.dart';
import 'package:bookit_driver_app/notification/pushnotificationservice.dart';
import 'package:bookit_driver_app/service/apiservice.dart';
import 'package:flutter/cupertino.dart';

class TabOne extends StatefulWidget {
  TabOne({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<TabOne> createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  String driverStatus = "Offline - Go Online";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    getCurrentDriverInfo();
    super.initState();
  }

  getRideType() {
    driversRef.child(currentfirebaseUser?.uid ?? '').child("car_details").child("type").once().then((DataSnapshot snapshot) {
      if(snapshot.value != null) {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  getRatings() {
    // update ratings
    driversRef
        .child(currentfirebaseUser?.uid ?? '')
        .child("ratings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double ratings = double.parse(snapshot.value.toString());
         setState(() {
           starCounter = ratings;
         });
        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        } else if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });
          return;
        } else if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });
          return;
        } else if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        } else if (starCounter <= 5) {
          setState(() {
            title = "Excellent";
          });
          return;
        } else {
          return null;
        }
      }
    });

  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address =
    // await APIService().searchCoordinateAddress(position, context);
    // print("This is your address ::" + address);
  }

  void getCurrentDriverInfo() async{
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    driversRef.child(currentfirebaseUser!.uid).once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.value != null) {
driversInformation = Drivers.fromSnapshot(dataSnapshot);
      }
    });
    
    PushNotificationService().initFirebaseCM(context);
    PushNotificationService().getToken();
    APIService.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: TabOne._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locatePosition();
          },
        ),

        //online offline driver container
        Container(
          height: 140,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: GestureDetector(
                  onTap: () {
                    if(isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();
                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatus = "Online Now";
                        isDriverAvailable = true;
                      });
                          Fluttertoast.showToast(
                              msg: "You are online now",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1);
                    } else {
                      makeDriverofflineNow();
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatus = "Offline Now - Go Online";
                        isDriverAvailable = false;
                      });
                      Fluttertoast.showToast(
                          msg: "You are offline now",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                    }
                  },
                  child: Container(
                    height: 50,
                    color: driverStatusColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget>[
                        Text(
                          driverStatus,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Icon(
                          Icons.phone_android,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )))
      ],
    );
  }

  void makeDriverOnlineNow() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser?.uid??"", currentPosition?.latitude ?? 0, currentPosition?.longitude?? 0);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {

    });
    print('saved.....');
  }

  void makeDriverofflineNow() {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    //rideRequestRef = null;
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
     currentPosition = position;
     if(isDriverAvailable == true) {
       Geofire.setLocation(currentfirebaseUser!.uid, position.latitude, position.longitude);
     }
     LatLng latLng = LatLng(position.latitude, position.longitude);
     newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));

    });
  }
}
