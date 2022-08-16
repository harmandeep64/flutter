import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NestedRoutes {

  static String initialRoute = "auth/login";

  static Route routes(RouteSettings settings) {
    Route page;

    Get.routing.args = settings.arguments;
    switch(settings.name){
      case("auth/login"):
        page = GetPageRoute(
          routeName: settings.name,
          page: () => Login(),
        );
        break;
      case("auth/forgot_password"):
        page = GetPageRoute(
          routeName: settings.name,
          page: () => ForgotPassword(),
        );
        break;
      case("auth/verify_otp"):
        page = GetPageRoute(
          routeName: settings.name,
          page: () => VerifyOTP(),
        );
        break;
      default:
        page = GetPageRoute(
          routeName: settings.name,
          page: () => Login(),
        );
        break;
    }

    return page;
  }
}