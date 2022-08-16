import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/db.dart';
import 'package:lifter_life_restaurant_pos/config/storage.dart';
import 'package:lifter_life_restaurant_pos/controllers/pos_order_list_controller.dart';
import 'package:lifter_life_restaurant_pos/helpers/loader_helper.dart';
import 'package:lifter_life_restaurant_pos/models/network/sync_order_request_model.dart';
import 'package:lifter_life_restaurant_pos/models/sql/orders/order_sql.dart';

class POSDrawerController extends GetxController {

  syncMealsAgain() async{
    LoaderHelper.showLoading();

    var res = await SyncOrderRequestModel.requestSyncAll();
    if(res){
      OrderSQL.deleteAll();
    }

    await DB.truncateDB();

    LoaderHelper.hideLoading();
    Get.offAllNamed("/");
  }

  logout() async{
    LoaderHelper.showLoading();

    var res = await SyncOrderRequestModel.requestSyncAll();
    if(res){
      OrderSQL.deleteAll();
    }

    await DB.truncateDB();
    await Storage.flushData();

    LoaderHelper.hideLoading();
    Get.offAllNamed("/");
  }
}