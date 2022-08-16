import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifter_life_restaurant_pos/config/app_colors.dart';
import 'package:lifter_life_restaurant_pos/helpers/printer_helper.dart';
import 'package:lifter_life_restaurant_pos/models/sql/printers/printer_sql.dart';

class POSPrinterManageController extends GetxController {
  var printers = [].obs;
  var isProcessing = false.obs;

  @override
  void onInit() async{
    super.onInit();
    await getAllPrinters();
  }

  getAllPrinters() async{
    printers.value = await PrinterSQL.getAll();
  }

  pingAllPrinters() async{
    isProcessing.value = true;

    for(int i=0; i<printers.length; i++){
      if(await pingPrinter(ip: printers[i].ip.toString(), port: printers[i].port, name: printers[i].name)){
        printers[i].connected = 1;
      }else{
        printers[i].connected = 2;
      }
      printers.refresh();
    }

    isProcessing.value = false;
  }

  pingPrinter({required String ip, required int port, required String name}) async{
    var printer = await PrinterHelper.initPrint();
    final PosPrintResult res = await printer.connect(ip, port: port);

    if (res == PosPrintResult.success) {

      /*Print on printer*/
      printer.text(name, styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.text('Ping received :)', styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2));
      printer.feed(2);
      printer.cut();
      printer.disconnect();
      /*End*/

     return true;
    }else{
      return false;
    }
  }
}