import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/constants/colorconstants.dart';
import 'package:bookit_driver_app/main.dart';

import 'loginscreen.dart';

class CarInfoScreen extends StatefulWidget {
  CarInfoScreen({Key? key}) : super(key: key);
  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final carmodelController = TextEditingController();
  final carNumberController = TextEditingController();
  final carColorController = TextEditingController();
  final testController = TextEditingController();
  String? selectedCarType;
  List<String> carTypesList = ["hatchback", "sedan", "XUV"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(PRIMARY_COLOUR),
        title: Image.asset('assets/appbarlogo.png',
            fit: BoxFit.contain, width: 200),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.loose,
              overflow: Overflow.visible,
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/topbackground.png'),
                            fit: BoxFit.fitHeight)),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Row(
                          children: const <Widget>[],
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          'Please complete your profile to \n connect to your neighbourhood',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2, color: const Color(PRIMARY_COLOUR))),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/nearlelauncherround.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Enter Car Details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: carmodelController,
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.person, color: Colors.grey, size: 25),
                      border: OutlineInputBorder(),
                      labelText: "Car Model",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: "Type your name here..",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      carmodelController.text = value!;
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        //return 'Enter your name';
                        Fluttertoast.showToast(
                            msg: "",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: carNumberController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail, color: Colors.grey),
                      border: OutlineInputBorder(),
                      labelText: "Car Number",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: "Type your email here..",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      carNumberController.text = value!;
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: carColorController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      border: OutlineInputBorder(),
                      labelText: "Car Color",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: "Type your phone numner here..",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      carColorController.text = value!;
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                            hint: Text("Choose Car Type",style: TextStyle(color: Colors.grey, fontSize: 18),),
                            underline: SizedBox(),
                            value: selectedCarType,
                            items: carTypesList.map((car) {
                              return DropdownMenuItem(
                                child: new Text(car,style: TextStyle(color: Colors.grey, fontSize: 18
                                ),),
                                value: car,
                              );
                            }).toList(),
                            onChanged: (newValue) {
                            setState(() {
                              selectedCarType = newValue;
                            });
                            Fluttertoast.showToast(
                                msg: selectedCarType ?? '',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1);
                            }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: testController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      border: OutlineInputBorder(),
                      labelText: "Test",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: "Type your password here..",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      testController.text = value!;
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    splashColor: Colors.grey,
                    onTap: () {
                      saveDriverInfo(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(SECONDARY_COLOUR)),
                      child: const Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveDriverInfo(context) {
    print('data...');
    String? userId = currentfirebaseUser?.uid ?? '';

    Map carInfoMap = {
      "Car_Model": carmodelController.text,
      "Car_Number": carNumberController.text,
      "Car_Color": carColorController.text,
      "type": selectedCarType,
      "Test": testController.text
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);
    Get.to(LoginScreen());
  }
}
