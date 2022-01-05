import 'package:bookit_driver_app/allpackages.dart';
import 'package:bookit_driver_app/constants/colorconstants.dart';
import 'package:bookit_driver_app/controller/tabcontroller.dart';
import 'package:bookit_driver_app/view/dashboard/profiletab.dart';
import 'package:bookit_driver_app/view/dashboard/hometab.dart';
import 'package:bookit_driver_app/view/dashboard/ratingstab.dart';
import 'package:bookit_driver_app/view/dashboard/earningstab.dart';


class NavigationBar extends StatelessWidget {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
  const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, controller) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            backgroundColor: const Color(PRIMARY_COLOUR),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.home,
                    size: 20.0,
                  ),
                ),
                label: 'Home',
                backgroundColor: const Color(PRIMARY_COLOUR),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.credit_card,
                    size: 20.0,
                  ),
                ),
                label: 'Earnings',
                backgroundColor: Color(PRIMARY_COLOUR),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.star,
                    size: 20.0,
                  ),
                ),
                label: 'Ratings',
                backgroundColor: const Color(PRIMARY_COLOUR),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.person,
                    size: 20.0,
                  ),
                ),
                label: 'Profile',
                backgroundColor: const Color(PRIMARY_COLOUR),
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController(), permanent: false);
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: buildBottomNavigationMenu(context, controller),
          body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [TabOne(), EarningsScreen(), TabThree(), TabFour()],
          )),
        ));
  }
}