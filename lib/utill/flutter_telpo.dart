
import 'dart:async';

import 'package:flutter/services.dart';

import '../model/qrcode.dart';
import '../model/row.dart';



class FlutterTelpo {
  final MethodChannel _platform = const MethodChannel('com.efikas.flutter_telpo/printer');


  Future<bool> isConnected() async {
    return await _platform.invokeMethod('isConnected');
  }
  
  Future<dynamic> print(
  List<dynamic> rows, {
  bool q8Mode = false,
}) async {
  final printableRows = <Map<String, dynamic>>[];

  for (final row in rows) {
    if (row is PrintRow ||
        row is PrintQRCode ||
        row is PrintImage ||
        row is WalkPaper) {
      printableRows.add(row.toJson());
    }
  }

  return await _platform.invokeMethod(
    'printDocument',
    {
      'details': printableRows,
      'q8Mode': q8Mode,
    },
  );
}

  Future<dynamic> printNewLine() async{
    return await _platform.invokeMethod('printNewLine');
  }

  Future<dynamic> printCustom(String text, int fontSize, int position) async{
    return await _platform.invokeMethod('printCustom', {"text": text, "fontSize": fontSize, "position": position});
  }

  Future<dynamic> printQRCode(String text, int height, int width, int position) async {
    return await _platform.invokeMethod('printQRCode', {"text": text, "height": height, "width": width});
  }

  Future<dynamic> printImage(String pathUrl, int height, int width, int position) async {
    return await _platform.invokeMethod('printImage', {"pathUrl": pathUrl, "height": height, "width": width, "position": position});
  }

  Future<dynamic> paperWalk(int length) async {
    return await _platform.invokeMethod('walkPaper', {"length": length});
  }


  void disconnect() async{
    await _platform.invokeMethod('disconnect');
  }

  Future<String> connect() async {
   return await _platform.invokeMethod('connect');
  }

}

