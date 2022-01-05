import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/helper/appdata.dart';
import 'package:bookit_driver_app/view/dashboard/historyscreen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: <Widget>[
                Text("Total Earnings", style: TextStyle(color: Colors.white)),
                Text(
                  "\$${Provider.of<AppData>(context, listen: false).earnings}",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Get.to(HistoryScreen());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Row(
                children: <Widget>[
                  Image.asset('assets/sedan.png', width: 45),
                  SizedBox(width: 16),
                  Text("Total Trips", style: TextStyle(fontSize: 16,)),
                  Expanded(
                      child: Container(
                    child: Text(Provider.of<AppData>(context, listen: false).counterTrips.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 18)),
                  ))
                ],
              ),
            )),
        Divider(height: 2, thickness: 2),
      ],
    );
  }
}
