import 'package:flutter/material.dart';

class Constants {
  static String baseUrl = "http://127.0.0.1:8000";
  static String apiKey = "KEY";
  static int apiTimeOut = 30; //seconds
  static int animationDuration = 500; // milliseconds
  static int snackBarDuration = 1; // seconds
  static Widget loader = Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)));

  static List<BoxShadow> boxShadow = [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 3, blurRadius: 7, offset: const Offset(0, 3),),];
  static List<BoxShadow> boxShadow2 = [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 3),),];
}