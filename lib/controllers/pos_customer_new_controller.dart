import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import 'package:lifter_life_restaurant_pos/controllers/pos_cart_controller.dart';
import 'package:lifter_life_restaurant_pos/helpers/toast_helper.dart';
import 'package:lifter_life_restaurant_pos/models/network/find_customer_model.dart';

class POSCustomerNewController extends GetxController {
  final posCartController = Get.put(POSCartController());
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  addCustomer() async{
    var name = nameController.text;
    var email = emailController.text;
    var phoneNumber = phoneNumberController.text;

    if(name.isEmpty){
      ToastHelper.showError(message: "Name is required!");
      return null;
    }if(email.isEmpty){
      ToastHelper.showError(message: "Email is required!");
      return null;
    }if(!email.isEmail){
      ToastHelper.showError(message: "Please enter valid email!");
      return null;
    }if(phoneNumber.isEmpty){
      ToastHelper.showError(message: "Phone number is required!");
      return null;
    }

    var params = {
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
    };

    var customer = await FindCustomerModel.saveCustomer(params);

    posCartController.selectedCustomerId.value = customer.id;
    posCartController.selectedCustomerName.value = "${customer.firstName} ${customer.lastName}";

    Get.back(id: Constants.posMealNavigatorKey);
  }
}