import 'dart:io';

class CommonHelper {
  static checkInternetConnection() async{
    var internetConnected = true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty) {
        internetConnected = true;
      }else{
        internetConnected = false;
      }
    } on SocketException catch (e) {
      internetConnected = false;
    }

    return internetConnected;
  }
}