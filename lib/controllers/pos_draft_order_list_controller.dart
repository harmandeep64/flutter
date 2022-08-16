import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/app_colors.dart';
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import 'package:lifter_life_restaurant_pos/controllers/pos_cart_controller.dart';
import 'package:lifter_life_restaurant_pos/models/local/cart.dart';
import 'package:lifter_life_restaurant_pos/models/local/selected_meals.dart';
import 'package:lifter_life_restaurant_pos/models/local/selected_options.dart';
import 'package:lifter_life_restaurant_pos/models/sql/draft_orders/draft_order_sql.dart';
import 'package:lifter_life_restaurant_pos/views/ui_elements/confirm_dialog.dart';
import 'package:lifter_life_restaurant_pos/views/ui_elements/custom_button.dart';

class POSDraftOrderListController extends GetxController {
  final posCartController = Get.put(POSCartController());

  var orders = <DraftOrderSQL>[].obs;

  @override
  void onInit() {
    getAllDraftOrders();
    super.onInit();
  }

  getAllDraftOrders() async{
    orders.value = await DraftOrderSQL.getAll();
  }

  selectDraftOrder(id) async{
    ConfirmDialog(
        title: "Confirm",
        contentText: "What you want to do with this ?",
        actions: [
          CustomButton(
              btnHeight: 50,
              btnWidth: 120,
              btnColor: AppColors.dangerColor,
              text: "Delete",
              textSize: 22,
              textColor: AppColors.whiteColor,
              onTap: () async {
                await DraftOrderSQL.delete(id);
                getAllDraftOrders();
                Get.back();
              }
          ),
          const SizedBox(width: 25,),
          CustomButton(
              btnHeight: 50,
              btnWidth: 120,
              btnColor: AppColors.successColor,
              text: "Continue",
              textSize: 22,
              textColor: AppColors.blackColor,
              onTap: (){
                loadOrder(id);
                Get.back();
              }
          ),
          const SizedBox(width: 25,),
          CustomButton(
              btnHeight: 50,
              btnWidth: 120,
              btnColor: AppColors.backgroundColor,
              text: "Close",
              textSize: 22,
              textColor: AppColors.blackColor,
              onTap: (){
                Get.back();
              }
          )
        ]
    );
  }

  loadOrder(id) async{
    posCartController.clearCart();
    var order = await DraftOrderSQL.get(id);

    if(order != null) {
      posCartController.selectedOrderType.value = order.orderType;
      posCartController.selectedCustomerId.value = order.customerId;
      posCartController.selectedCustomerName.value = order.customerName;

      for(int i=0;i<order.meals.length; i++){
        var selectedOptions = <SelectedOptions>[];
        var selectedMeals = <SelectedMeals>[];

        for(int j=0;j<order.meals[i].selectedOptions.length; j++){
          selectedOptions.add(SelectedOptions(
              mealId: order.meals[i].mealId,
              optionId: order.meals[i].selectedOptions[j].mealOptionId,
              optionName: order.meals[i].selectedOptions[j].mealOptionName,
              elementId: order.meals[i].selectedOptions[j].elementId,
              elementName: order.meals[i].selectedOptions[j].elementName,
              quantity: order.meals[i].selectedOptions[j].quantity,
              price: order.meals[i].selectedOptions[j].price,
              total: order.meals[i].selectedOptions[j].totalAmount
          ));
        }
        for(int j=0;j<order.meals[i].selectedMeals.length; j++){
          selectedMeals.add(SelectedMeals(
              mealId: order.meals[i].mealId,
              mealMealId: order.meals[i].selectedMeals[j].mealMealId,
              mealMealName: order.meals[i].selectedMeals[j].mealMealName,
              elementId: order.meals[i].selectedMeals[j].elementId,
              elementName: order.meals[i].selectedMeals[j].elementName,
              quantity: order.meals[i].selectedMeals[j].quantity,
              price: order.meals[i].selectedMeals[j].price,
              total: order.meals[i].selectedMeals[j].totalAmount
          ));
        }

        var meal = Cart(
          mealId: order.meals[i].mealId,
          name: order.meals[i].name,
          price: order.meals[i].basePrice + order.meals[i].addOnPrice,
          quantity: order.meals[i].quantity,
          total: order.meals[i].totalAmount,
          note: order.meals[i].notes,
          selectedOptions: selectedOptions,
          selectedMeals: selectedMeals,
        );

        posCartController.addToCart(cart: meal, merge: false);
      }
    }

    await DraftOrderSQL.delete(id);
    Get.offAllNamed("pos/menu/categories", id: Constants.posMealNavigatorKey);
  }

  deleteAllDraftOrders (){
    ConfirmDialog(
      title: "Confirm",
      contentText: "Are you sure you want to delete all draft orders ?",
      actions: [
        CustomButton(
            btnHeight: 50,
            btnWidth: 120,
            btnColor: AppColors.dangerColor,
            text: "Yes",
            textSize: 22,
            textColor: AppColors.whiteColor,
            onTap: () async{
              await DraftOrderSQL.deleteAll();
              getAllDraftOrders();
              Get.back();
            }
        ),
        const SizedBox(width: 25,),
        CustomButton(
            btnHeight: 50,
            btnWidth: 120,
            btnColor: AppColors.backgroundColor,
            text: "No",
            textSize: 22,
            textColor: AppColors.blackColor,
            onTap: (){
              Get.back();
            }
        )
      ]
    );
  }
}