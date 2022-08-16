import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/models/network/find_customer_model.dart';

class POSCustomerFindController extends GetxController {
  final searchInputController = TextEditingController();
  var customers = <FindCustomerModel>[].obs;

  @override
  void onInit() {

  }

  findCustomer() async{
    var search = searchInputController.text;
    if(search != "") {
      customers.value = await FindCustomerModel.response(search: search);
    }else{
      customers.value = [];
    }
  }
}