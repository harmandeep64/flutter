import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import 'package:lifter_life_restaurant_pos/helpers/printer_helper.dart';
import 'package:lifter_life_restaurant_pos/helpers/toast_helper.dart';
import 'package:lifter_life_restaurant_pos/models/sql/printers/printer_sql.dart';

class POSPrinterAddController extends GetxController {
  final printerNameController = TextEditingController();
  final printerIpController = TextEditingController();
  final printerPortController = TextEditingController();
  var printerType = 1.obs;
  var isProcessing = false.obs;

  savePrinter() async{
    var name = printerNameController.text;
    var ip = printerIpController.text;
    var port = int.parse(printerPortController.text);

    isProcessing.value = true;

    var printer = await PrinterHelper.initPrint();
    final PosPrintResult res = await printer.connect(ip, port: port);

    if (res == PosPrintResult.success) {

      /*Print on printer*/
      printer.text(name, styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.text('Connected successfully!', styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.feed(2);
      printer.cut();
      printer.disconnect();
      /*End*/

      await PrinterSQL(
          type: printerType.value,
          name: name,
          ip: ip,
          port: port
      ).insert();
      isProcessing.value = false;

      ToastHelper.showSuccess(message: "Printer connected successfully!");
      Get.offAllNamed("printers/manager", id: Constants.posMealNavigatorKey);
    }else{
      isProcessing.value = false;
      ToastHelper.showError(message: "Printer not found!");
    }
  }
}