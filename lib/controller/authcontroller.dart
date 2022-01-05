import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/view/carinfoscreen.dart';
import 'package:bookit_driver_app/view/dashboard/tabbar.dart' as tabbar;
import 'package:bookit_driver_app/view/loginscreen.dart';

import '../allpackages.dart';
import '../main.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void createUser(String name, String email, String phoneNo,
      String password) async {
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Registering, Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    var credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (credentials.user != null) {
      Map userDataMap = {
        "Name": name.trim(),
        "Email": email.trim(),
        "Phone": phoneNo.trim(),
        "Password": password.trim()
      };

      driversRef.child(credentials.user!.uid).set(userDataMap);

      currentfirebaseUser = credentials.user!;

      Get.to(CarInfoScreen());
      Fluttertoast.showToast(
          msg: "Account Created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
      print('created successfully.......');
    } else {
      Get.back();
      Fluttertoast.showToast(
          msg: "Account creating failed ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);

      print('Failed........');
    }
  }

  void login(String email, String password) async {
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Authenticating, Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    var credentials = await _auth.signInWithEmailAndPassword(
        email: email, password: password).catchError((errMsg) {
      Get.back();
      Fluttertoast.showToast(
          msg: "Error:" + errMsg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    });
    if (credentials.user != null) {
      print('Login Success....');
      Get.to(tabbar.NavigationBar());
      // driversRef.child(credentials.user!.uid).once().then((value) => (DataSnapshot snap) {
      //   if(snap.value != null) {
      //     print('snapshot......');
      //     Get.to(MainScreen(email: '',));
      //     Fluttertoast.showToast(
      //         msg: "You are logged-in now",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         timeInSecForIosWeb: 1);
      //   } else{
      //     print('failed...');
      //     _auth.signOut();
      //     Fluttertoast.showToast(
      //         msg: "No records exists for this user. Please create account now",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.CENTER,
      //         timeInSecForIosWeb: 1);
      //   }
      // });


    } else {
      Fluttertoast.showToast(
          msg: "Error Occured",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
      print('Login Failed');
    }
  }

  void signOut() async {
    await _auth.signOut();
    Get.offAll(LoginScreen());
  }

// void saveDriverInfo(String carModel, String carNumber, String carColor, String test) {
//   String userId =  currentfirebaseUser.uid;
//
//   Map carInfoMap = {
//     "Car_Model": carModel.trim(),
//     "Car_Number": carNumber.trim(),
//     "Car_Color": carColor.trim(),
//     "Test": test.trim()
//   };
//
//   driversRef.child(userId).child("car_details").set(carInfoMap);
//   Get.to(MainScreen(email: ''));
// }


}
