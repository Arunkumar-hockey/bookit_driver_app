import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/model/allusers.dart';
import 'package:bookit_driver_app/model/drivers.dart';

String mapkey = "AIzaSyD6F_4FcuK6pNtgVPcNDfkJDhl6Sl_VIe4";

late User firebaseUser;

late Users userCurrentInfo;

User? currentfirebaseUser;

late StreamSubscription<Position> homeTabPageStreamSubscription;

late StreamSubscription<Position> rideStreamSubscription;

final player = AudioPlayer();

Position? currentPosition;

late Drivers driversInformation;
String title = '';
double starCounter = 0.0;

String rideType = '';

