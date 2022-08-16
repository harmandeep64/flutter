import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  runApp(OurAppName());
}

class OurAppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My example app',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        backgroundColor: AppColors.backgroundColor,
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.assistantTextTheme(),
      ),
      initialRoute: '/',
      getPages: MainRoutes.routes
    );
  }
}
