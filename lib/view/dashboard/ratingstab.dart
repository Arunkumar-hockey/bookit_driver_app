import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/baseconstants.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

class TabThree extends StatefulWidget {
  const TabThree({Key? key}) : super(key: key);

  @override
  State<TabThree> createState() => _TabThreeState();
}

class _TabThreeState extends State<TabThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 22),
              const Text(
                "Your Ratings",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(height: 22),
              const Divider(height: 2, thickness: 2),
              const SizedBox(height: 16),
              // SmoothStarRating(
              //   rating: starCounter,
              //   color: Colors.amber,
              //   allowHalfRating: true,
              //   starCount: 5,
              //   size: 45,
              //   isReadOnly: true,
              // ),
              RatingBarIndicator(
                rating: starCounter,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 50.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(fontSize: 55, color: Colors.amber),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
