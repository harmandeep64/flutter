import 'dart:io';

import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/storage.dart';
import 'package:lifter_life_restaurant_pos/exceptions/handle_exception.dart';
import 'package:lifter_life_restaurant_pos/helpers/common_helper.dart';
import 'package:lifter_life_restaurant_pos/helpers/toast_helper.dart';
import 'package:lifter_life_restaurant_pos/models/network/get_all_promo_code_model.dart';
import 'package:lifter_life_restaurant_pos/models/network/location_model.dart';
import 'package:lifter_life_restaurant_pos/models/network/meals_menu_model.dart';
import 'package:lifter_life_restaurant_pos/models/sql/location_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/promo_code_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_category_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_meal_element_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_meal_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_option_element_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_option_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_selected_meal_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_selected_option_sql.dart';
import 'package:lifter_life_restaurant_pos/models/sql/restaurant_meal_sql.dart';

class SyncMenuMealsController extends GetxController {
  var internetConnected = true.obs;
  var taskMessage = "Please wait while we are syncing restaurant menu from server".obs;

  @override
  void onInit() async {
    var categories = await RestaurantMealSQL.getAll();

    if(categories.length > 0){
      await syncAllPromoCodes();
      Get.offAllNamed("/pos/home");
    }else {
      checkConnection();
    }
  }

  checkConnection() async{
    if(await CommonHelper.checkInternetConnection()){
      internetConnected.value = true;
      syncDataFromServer();
    }else{
      internetConnected.value = false;
    }
  }

  syncDataFromServer() async{
    await syncAllLocations();
    await syncAllPromoCodes();
    await syncRestaurantMeals();
  }

  syncAllLocations() async{
    var locations = await LocationModel.response();

    for(int i=0;i<locations.length;i++){
      await LocationSQL(
          id: locations[i].id,
          cityId: locations[i].cityId,
          name: locations[i].name,
      ).insert();
    }
  }

  syncAllPromoCodes() async {
    var promoCodes = await GetAllPromoCodeModel.response();

    for(int i=0;i<promoCodes.length;i++){
      await PromoCodeSQL(
        id: promoCodes[i].id,
        promoCode: promoCodes[i].promoCode,
        discount: promoCodes[i].discount,
        minAmount: promoCodes[i].minAmount,
        discountType: promoCodes[i].discountType,
        validFor: promoCodes[i].validFor,
      ).insert();
    }
  }

  syncRestaurantMeals () async{
    try {
      var restaurantId = await Storage.getData(key: "restaurantId");

      taskMessage.value = "Saving data on local system...";

      var mealsMenu = await MealsMenuModel.response(restaurantId);

      for(int category=0; category<mealsMenu.length; category++){

        await RestaurantMealCategorySQL(
            id: mealsMenu[category].id,
            restaurantId: mealsMenu[category].restaurantId,
            name: mealsMenu[category].name,
            description: mealsMenu[category].description,
            position: mealsMenu[category].position,
            status: mealsMenu[category].status
        ).insert();

        var meals = mealsMenu[category].restaurantMeals;

        for(int meal=0; meal<meals!.length; meal++) {

          taskMessage.value = "Syncing: ${meals[meal].name}";

          await RestaurantMealSQL(
            id: meals[meal].id,
            restaurantId: meals[meal].restaurantId,
            restaurantMealCategoryId: meals[meal].restaurantMealCategoryId,
            name: meals[meal].name,
            internalName: meals[meal].internalName,
            picture: meals[meal].picture,
            description: meals[meal].description,
            mealInstruction: meals[meal].mealInstruction,
            basePrice: meals[meal].basePrice,
            newBasePrice: meals[meal].newBasePrice,
            otherPrice1: meals[meal].otherPrice1,
            otherPrice2: meals[meal].otherPrice2,
            limitPerPersonUpto: meals[meal].limitPerPersonUpto,
            ageRestriction: meals[meal].ageRestriction,
            position: meals[meal].position,
            viewOnWebsite: meals[meal].viewOnWebsite,
            status: meals[meal].status,
          ).insert();

          var restaurantMealSelectedOptions = meals[meal].restaurantMealSelectedOption!;

          for(int selectedOption=0; selectedOption < restaurantMealSelectedOptions.length; selectedOption++){

            await RestaurantMealSelectedOptionSQL(
              id: restaurantMealSelectedOptions[selectedOption].id,
              restaurantMealId: restaurantMealSelectedOptions[selectedOption].restaurantMealId,
              restaurantMealOptionId: restaurantMealSelectedOptions[selectedOption].restaurantMealOptionId,
              status: restaurantMealSelectedOptions[selectedOption].status,
            ).insert();

            var restaurantMealOption = restaurantMealSelectedOptions[selectedOption].restaurantMealOption!;

            await RestaurantMealOptionSQL(
              id: restaurantMealOption.id,
              restaurantId: restaurantMealOption.restaurantId,
              restaurantMealCategoryId: restaurantMealOption.restaurantMealCategoryId,
              name: restaurantMealOption.name,
              description: restaurantMealOption.description,
              chooseMoreThanOne: restaurantMealOption.chooseMoreThanOne,
              chooseLimitUpto: restaurantMealOption.chooseLimitUpto,
              optionChooseUpto: restaurantMealOption.optionChooseUpto,
              minOptionChoose: restaurantMealOption.minOptionChoose,
              maxOptionChoose: restaurantMealOption.maxOptionChoose,
              isRequired: restaurantMealOption.isRequired,
              status: restaurantMealOption.status,
            ).insert();

            var restaurantMealOptionElements = restaurantMealOption.restaurantMealOptionElement!;

            for(int selectedElement=0; selectedElement < restaurantMealOptionElements.length; selectedElement++){

              await RestaurantMealOptionElementSQL(
                id: restaurantMealOptionElements[selectedElement].id,
                restaurantMealOptionId: restaurantMealOptionElements[selectedElement].restaurantMealOptionId,
                name: restaurantMealOptionElements[selectedElement].name,
                price: restaurantMealOptionElements[selectedElement].price,
                status: restaurantMealOptionElements[selectedElement].status,
              ).insert();
            }
          }


          var restaurantMealSelectedMeals = meals[meal].restaurantMealSelectedMeal!;

          for(int selectedMeal=0; selectedMeal < restaurantMealSelectedMeals.length; selectedMeal++){

            await RestaurantMealSelectedMealSQL(
              id: restaurantMealSelectedMeals[selectedMeal].id,
              restaurantMealId: restaurantMealSelectedMeals[selectedMeal].restaurantMealId,
              restaurantMealMealId: restaurantMealSelectedMeals[selectedMeal].restaurantMealMealId,
              status: restaurantMealSelectedMeals[selectedMeal].status,
            ).insert();

            var restaurantMealMeal = restaurantMealSelectedMeals[selectedMeal].restaurantMealMeal!;

            await RestaurantMealMealSQL(
              id: restaurantMealMeal.id,
              restaurantId: restaurantMealMeal.restaurantId,
              restaurantMealCategoryId: restaurantMealMeal.restaurantMealCategoryId,
              name: restaurantMealMeal.name,
              description: restaurantMealMeal.description,
              chooseMoreThanOne: restaurantMealMeal.chooseMoreThanOne,
              chooseLimitUpto: restaurantMealMeal.chooseLimitUpto,
              optionChooseUpto: restaurantMealMeal.optionChooseUpto,
              minOptionChoose: restaurantMealMeal.minOptionChoose,
              maxOptionChoose: restaurantMealMeal.maxOptionChoose,
              status: restaurantMealMeal.status,
            ).insert();

            var restaurantMealMealElements = restaurantMealMeal.restaurantMealMealElement!;

            for(int selectedElement=0; selectedElement < restaurantMealMealElements.length; selectedElement++){

              await RestaurantMealMealElementSQL(
                id: restaurantMealMealElements[selectedElement].id,
                restaurantMealMealId: restaurantMealMealElements[selectedElement].restaurantMealMealId,
                mealId: restaurantMealMealElements[selectedElement].mealId,
                price: restaurantMealMealElements[selectedElement].price,
                status: restaurantMealMealElements[selectedElement].status,
              ).insert();
            }
          }

        }
      }

      taskMessage.value = "Syncing complete ... ";
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed("/pos/home");

    }catch (e){
      HandleException().handleError(e);
    }
  }
}