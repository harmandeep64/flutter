import 'package:get/get.dart';

class SplashController extends GetxController{
  final int splashDuration = 1;

  @override
  void onInit() {
    checkLoggedIn();
  }

  checkLoggedIn() async{
    await Future.delayed(Duration(seconds: splashDuration));

    if(await Storage.hasData(key: "restaurantId")) {
      Get.offAllNamed("/home");
    }else{
      Get.offAllNamed("/auth/login");
    }
  }
}