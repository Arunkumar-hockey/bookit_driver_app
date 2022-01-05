import 'package:bookit_driver_app/allpackages.dart';

class Drivers {
  late String name;
  late String phone;
  late String email;
  late String id;
  late String car_color;
  late String car_model;
  late String car_number;

  Drivers({
    required this.name,
    required this.phone,
    required this.email,
    required this.id,
    required this.car_color,
    required this.car_model,
    required this.car_number
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;
    phone = dataSnapshot.value["Phone"];
    email = dataSnapshot.value["Email"];
    name = dataSnapshot.value["Name"];
    car_color = dataSnapshot.value["car_details"]["Car_Color"];
    car_model = dataSnapshot.value["car_details"]["Car_Model"];
    car_number = dataSnapshot.value["car_details"]["Car_Number"];
  }
}