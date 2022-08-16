import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/app_colors.dart';
import 'package:lifter_life_restaurant_pos/controllers/splash_controller.dart';

class Splash extends StatelessWidget {
  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/logo.png",
                  width: 400,
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}