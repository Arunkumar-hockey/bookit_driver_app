import 'package:bookit_driver_app/allpackages.dart';

class HomeController extends GetxController{

  RxInt tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

}