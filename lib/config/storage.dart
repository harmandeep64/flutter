import 'package:get_storage/get_storage.dart';

class Storage {

  static init() async {
    await GetStorage.init();
  }

  static void saveData({required String key, required dynamic value}) async {
    final storage = GetStorage();
    await storage.write(key, value);
    storage.save();
  }

  static hasData({required String key}) async {
    final storage = GetStorage();
    return storage.hasData(key);
  }

  static getData({required String key}) async {
    final storage = GetStorage();
    if(storage.hasData(key)){
      return storage.read(key);
    }else{
      return false;
    }
  }

  static removeData({required String key}) async {
    final storage = GetStorage();
    storage.remove(key);
  }

  static flushData() async {
    final storage = GetStorage();
    storage.erase();
  }
}