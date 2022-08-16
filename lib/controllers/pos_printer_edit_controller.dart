import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/app_colors.dart';
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import 'package:lifter_life_restaurant_pos/helpers/printer_helper.dart';
import 'package:lifter_life_restaurant_pos/helpers/toast_helper.dart';
import 'package:lifter_life_restaurant_pos/models/sql/printers/printer_sql.dart';
import 'package:lifter_life_restaurant_pos/views/ui_elements/confirm_dialog.dart';
import 'package:lifter_life_restaurant_pos/views/ui_elements/custom_button.dart';

class POSPrinterEditController extends GetxController {
  final printerId = Get.arguments;

  final printerNameController = TextEditingController();
  final printerIpController = TextEditingController();
  final printerPortController = TextEditingController();
  var printerType = 1.obs;
  var isProcessing = false.obs;

  onInit() async{
    super.onInit();
    await loadPrinter();
  }

  loadPrinter() async{
    var printer = await PrinterSQL.get(id: "$printerId");
    printerNameController.text = printer.name;
    printerIpController.text = printer.ip.toString();
    printerPortController.text = printer.port.toString();
    printerType.value = printer.type;
  }

  deletePrinter() {
    ConfirmDialog(
      title: "Confirm",
      contentText: "Are you sure you want to delete this printer?",
      actions: [
        CustomButton(
            btnHeight: 40,
            btnWidth: 50,
            btnColor: AppColors.dangerColor,
            text: "Yes",
            textSize: 20,
            textColor: AppColors.whiteColor,
            onTap: () async{
              await PrinterSQL.deletePrinter(id: "$printerId");
              Get.back();
              Get.offAllNamed("printers/manager",id: Constants.posMealNavigatorKey);
            }
        ),
        const SizedBox(width: 10,),
        CustomButton(
            btnHeight: 40,
            btnWidth: 50,
            btnColor: AppColors.greyColor,
            text: "No",
            textSize: 20,
            textColor: AppColors.blackColor,
            onTap: (){
              Get.back();
            }
        ),
      ]
    );
  }

  updatePrinter() async{
    var name = printerNameController.text;
    var ip = printerIpController.text;
    var port = int.parse(printerPortController.text);

    isProcessing.value = true;

    var printer = await PrinterHelper.initPrint();
    final PosPrintResult res = await printer.connect(ip, port: port);

    if (res == PosPrintResult.success) {

      /*Print on printer*/
      printer.text(name, styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.text('Connected & Updated successfully!', styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.feed(2);
      printer.cut();
      printer.disconnect();
      /*End*/

      await PrinterSQL(
          type: printerType.value,
          name: name,
          ip: ip,
          port: port
      ).update(printerId);

      isProcessing.value = false;

      ToastHelper.showSuccess(message: "Printer updated successfully!");
      Get.offAllNamed("printers/manager", id: Constants.posMealNavigatorKey);
    }else{
      isProcessing.value = false;
      ToastHelper.showError(message: "Printer not found!");
    }
  }
}