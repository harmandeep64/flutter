import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ToastHelper {

  static void showError({String title = 'Error', String? message = 'Something went wrong'}) async{
    if(Get.isSnackbarOpen){
      await Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message!,
      duration: Duration(seconds: Constants.snackBarDuration),
      snackPosition: SnackPosition.TOP,
      titleText: Text(
        title,
        style:  TextStyle(
          fontSize: 25,
          color: AppColors.whiteColor
        ),
      ),
      messageText: Text(
        message,
        style:  TextStyle(
            fontSize: 23,
            color: AppColors.whiteColor
        ),
      ),
      icon: Padding(padding: const EdgeInsets.all(20), child: FaIcon(FontAwesomeIcons.ban, color: AppColors.whiteColor,)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.dangerColor,
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void showSuccess({String title = 'Success', String? message = 'Task performed successfully'}) async{
    if(Get.isSnackbarOpen){
      await Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message!,
      duration: Duration(seconds: Constants.snackBarDuration),
      snackPosition: SnackPosition.TOP,
      titleText: Text(
        title,
        style:  TextStyle(
            fontSize: 25,
            color: AppColors.blackColor
        ),
      ),
      messageText: Text(
        message,
        style:  TextStyle(
            fontSize: 23,
            color: AppColors.blackColor
        ),
      ),
      icon: Padding(padding: const EdgeInsets.all(20), child: FaIcon(FontAwesomeIcons.checkDouble, color: AppColors.blackColor,)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.successColor,
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}