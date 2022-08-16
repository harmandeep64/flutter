import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import 'package:lifter_life_restaurant_pos/views/authenticate/restaurant_view_all.dart';
import 'package:lifter_life_restaurant_pos/views/authenticate/verify_restaurant_pin.dart';
import 'package:lifter_life_restaurant_pos/views/pos/pos_home.dart';
import 'package:lifter_life_restaurant_pos/views/pos/sync_menu_meals.dart';
import 'package:lifter_life_restaurant_pos/views/splash.dart';

class MainRoutes {
  static List<GetPage> routes = [
    GetPage(
        name: '/',
        page: () => Splash()
    ),
    GetPage(
        name: '/auth/login',
        page: () => Splash(),
        transitionDuration: Duration(milliseconds: Constants.animationDuration)
    ),
    GetPage(
        name: '/home',
        page: () => Splash(),
        transitionDuration: Duration(milliseconds: Constants.animationDuration)
    )
  ];
}