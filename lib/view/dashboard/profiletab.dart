import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
import 'package:bookit_driver_app/main.dart';
import 'package:bookit_driver_app/view/loginscreen.dart';

class TabFour extends StatelessWidget {
  const TabFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Text(
                "Profile Info",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey[200],
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              InfoCard(
                  text: driversInformation.name,
                  icon: Icons.person,
                  onPressed: () async {
                    print('This is Phone');
                  }),
              InfoCard(
                  text: driversInformation.phone,
                  icon: Icons.phone,
                  onPressed: () async {
                    print('This is Phone');
                  }),
              InfoCard(
                  text: driversInformation.email,
                  icon: Icons.email,
                  onPressed: () async {
                    print('This is Email');
                  }),
              InfoCard(
                  text: driversInformation.car_color +
                      "" +
                      driversInformation.car_model +
                      "" +
                      driversInformation.car_number,
                  icon: Icons.car_repair,
                  onPressed: () async {
                    print('This is car info');
                  }),
              GestureDetector(
                onTap: () {
                  Geofire.removeLocation(currentfirebaseUser?.uid ?? '');
                  rideRequestRef.onDisconnect();
                  rideRequestRef.remove();
                  //rideRequestRef = null;
                  FirebaseAuth.instance.signOut();
                  Get.to(LoginScreen());
                },
                child: Card(
                  color: Colors.red,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 110),
                  child: ListTile(
                    trailing: Icon(
                      Icons.follow_the_signs_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Sign Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  InfoCard(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title:
              Text(text, style: TextStyle(color: Colors.black87, fontSize: 16)),
        ),
      ),
    );
  }
}
