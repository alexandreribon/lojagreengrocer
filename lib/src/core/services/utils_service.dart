import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UtilsService {
  String priceToCurrency(double price) {
    NumberFormat numberformat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return numberformat.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();

    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    return dateFormat.format(dateTime);
  }

  Uint8List decodeQrCodeImage(String value) {
    var base64String = value.split(',').last;
    return base64.decode(base64String);
  }

  void showToast({
    required String message,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 18);
  }
}
