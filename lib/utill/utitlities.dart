// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/utill/strings.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' hide Headers;

import '../main.dart';
import '../model/direct_order_response.dart';
import '../model/row.dart';
import '../model/utilities_model.dart';
import '../provider/app_provider.dart' hide BluetoothInfo;
import '../screens/auth/sign_in_screen.dart';
import 'color_resources.dart';
import 'flutter_telpo.dart';

Future<void> shareOrder(DirectOrderResponse res, BuildContext context) async {
  String mobileNumber =
      await context.read<AppProvider>().getEnableMerchantNamePrint()
      ? "هاتف: \n${context.read<AppProvider>().utilitiesModel!.data!.companyWhatsappNumber!}\n${_separator(SeparatorType.dash)}\n"
      : '';

  String company =
      await context.read<AppProvider>().getEnableMerchantNamePrint()
      ? context.read<AppProvider>().utilitiesModel!.data!.company!
      : '';

  var shareString =
      company +
      mobileNumber +
      '*' +
      res.orderItems![0].websiteItemCode! +
      '*' +
      "\n";

  for (StockDetails stock in res.orderItems![0].digitalCardDetails!) {
    shareString =
        shareString +
        "الرقم السري: \n" +
        '*' +
        _addDashes(stock.secretCode!) +
        '*' +
        "\n";
    shareString =
        shareString + "الرقم التسلسلي: \n" + '\b${stock.serialNo!}' + "\n";
    shareString =
        "$shareStringرقم المرجع: \n${stock.refNo!}\n${_separator(SeparatorType.dash)}\n";
  }
  shareString = "$shareString${res.date!}\n${res.postingTime!.split(".")[0]}\n";
  shareString =
      "$shareStringرقم الطلب: ${res.salesOrderId!}\n${_separator(SeparatorType.dash)}\n";
  shareString =
      "$shareString${context.read<AppProvider>().utilitiesModel!.data!.companyName!}\n";
  shareString =
      shareString + context.read<AppProvider>().utilitiesModel!.data!.mobileNo!;
  await Share.share(shareString);
}

var transparentStatusBarAndDarkSystemBar = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: ColorResources.light_grey,
  systemNavigationBarDividerColor: Colors.transparent,
);

var transparentStatusBarAndTransparentSystemBar = SystemUiOverlayStyle.dark
    .copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

makePhoneCall(String url) async {
  await launch(url);
}

enum SeparatorType { dash, star }

String _separator([SeparatorType separatorType = SeparatorType.star]) =>
    separatorType == SeparatorType.star ? '**********' : '----------';

String _addDashes(String text) {
  return text.replaceAllMapped(RegExp(r'(\w{4})'), (Match match) {
    return '${match[0]}-';
  });
}

forceSignOut(DioException error) async {
  if (error.response?.statusCode == 401) {
    if (sharedPreferences.getString(Strings.Token) != null) {
      if (error.response?.data["message"] != null &&
          error.response?.data["message"].isNotEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.studio,
          textColor: Colors.white,
          msg: error.response!.data["message"] ?? '',
          timeInSecForIosWeb: 10,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      await Provider.of<AppProvider>(
        navigator.currentContext!,
        listen: false,
      ).setSignOutUser();

      print("===================== go to sign in from utilites ===========");
      Navigator.of(navigator.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

enum NumStrLanguage { Arabic, English }

String changeDigit(String number, NumStrLanguage toDigit) {
  var arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  var enNumbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."];

  if (toDigit == NumStrLanguage.English) {
    for (var i = 0; i < 10; i++) {
      number = number.replaceAll(RegExp(arabicNumbers[i]), enNumbers[i]);
    }
  } else {
    for (var i = 0; i < 10; i++) {
      number = number.replaceAll(RegExp(enNumbers[i]), arabicNumbers[i]);
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  return number;
}

enum SettingName {
  profile,
  notifications,
  faq,
  languages,
  help,
  contacts,
  aboutUs,
  logOut,
}

extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    Color? color,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return copyWith(
      shadows: [
        Shadow(color: this.color ?? Colors.black, offset: Offset(0, -distance)),
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationThickness: thickness,
      decorationColor: color ?? this.color,
      decorationStyle: style,
    );
  }
}

// Future<bool?> connect(BluetoothDevice? device) async {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   if (device == null) {
//     return false;
//   } else {
//     var res = await bluetooth.isConnected;
//     if (!res!) {
//       try {
//         await bluetooth.connect(device);
//         return true;
//       } catch (e) {
//         return false;
//       }
//     }
//   }
//   return null;
// }
Future<bool> connect(BluetoothInfo device) async {
  bool isConnected = await PrintBluetoothThermal.connectionStatus;

  if (!isConnected) {
    final result = await PrintBluetoothThermal.connect(
      macPrinterAddress: device.macAdress,
    );
    return result;
  }
  return true;
}

// Future<void> printOnBluetoothPrinter(
//   DirectOrderResponse directOrderResponse,
//   UtilitiesModel? utilitiesModel,
//   BuildContext context,
// ) async {
//   final appProvider = context.read<AppProvider>();
//   final device = appProvider.getBluetoothDevice();

//   if (device == null) {
//     debugPrint('No Bluetooth printer selected');
//     return;
//   }

//   final connected = await connect(device);

//   if (!connected) {
//     debugPrint('Failed to connect to Bluetooth printer');
//     return;
//   }

//   final bytes = <int>[];

//   // ESC/POS commands
//   const esc = 0x1B;
//   const gs = 0x1D;

//   // Initialize printer
//   bytes.addAll([esc, 0x40]);

//   // Helper: center
//   void center() {
//     bytes.addAll([esc, 0x61, 0x01]);
//   }

//   // Helper: left
//   void left() {
//     bytes.addAll([esc, 0x61, 0x00]);
//   }

//   // Helper: normal size
//   void normalSize() {
//   bytes.addAll([gs, 0x21, 0x04]);
//   }

//   // Helper: large size
//   void largeSize() {
//     // 2x width + 2x height
//     bytes.addAll([gs, 0x21, 0x08]);
//   }

//   // Helper: print line
//   void line(String text, {bool large = false, bool bold = false}) {
//     center();

//     if (large) {
//       largeSize();
//     } else {
//       normalSize();
//     }

//     // Bold ON / OFF
//     bytes.addAll([esc, 0x45, bold ? 0x01 : 0x00]);

//     bytes.addAll(textToBytes(text));
//     bytes.add(0x0A);

//     // Always reset bold after the line
//     bytes.addAll([esc, 0x45, 0x00]);
//   }

//   final cards = directOrderResponse.orderItems![0].digitalCardDetails!;

//   for (int i = 0; i < cards.length; i++) {
//     final StockDetails s = cards[i];

//     // Merchant name
//     if (await appProvider.getEnableMerchantNamePrint()) {
//       line(appProvider.utilitiesModel!.data!.company!);

//       line(_separator());
//     }

//     // Product name
//     line(
//       directOrderResponse.orderItems![0].websiteItemCode!,
//       large: true,
//       bold: true,
//     );

//     // Blank line
//     bytes.add(0x0A);

//     // Pin Code
//     line("Pin Code:");

//     line(_addDashes(s.secretCode!), bold: true);

//     // Blank line
//     bytes.add(0x0A);

//     // Serial
//     line("Serial No.");

//     line(s.serialNo!, bold: true);

//     // Ref
//     line("Ref No.");

//     line(s.refNo!, bold: true);

//     // Separator
//     line(_separator());
//     bytes.add(0x0A);

//     // Date
//     line(
//       "Date: ${directOrderResponse.date} "
//       "Time: ${directOrderResponse.postingTime!.split(".")[0]}",
//     );

//     // Order label
//     line("Order No. :");

//     // Order number
//     line(directOrderResponse.salesOrderId!.toString(), bold: true);

//     // Separator
//     line(_separator());

//     // Company
//     line(appProvider.utilitiesModel!.data!.companyName!);

//     // Phone
//     line("Phone:");

//     line(appProvider.utilitiesModel!.data!.mobileNo.toString(), bold: true);

//     // Between cards
//     if (i != cards.length - 1) {
//       line(_separator());

//       bytes.add(0x0A);
//       bytes.add(0x0A);
//     }
//   }

//   // Final feed
//   bytes.add(0x0A);
//   bytes.add(0x0A);

//   // Reset to normal / left after printing
//   normalSize();
//   left();
//     bytes.add(0x0A);
//     bytes.add(0x0A);

//   final result = await PrintBluetoothThermal.writeBytes(bytes);

//   if (!result) {
//     debugPrint("Bluetooth printer failed to print");
//   }
// }


Future<void> printOnBluetoothPrinter(
  DirectOrderResponse directOrderResponse,
  UtilitiesModel? utilitiesModel,
  BuildContext context,
) async {
  final appProvider = context.read<AppProvider>();
  final device = appProvider.getBluetoothDevice();

  if (device == null) {
    debugPrint('No Bluetooth printer selected');
    return;
  }

  final connected = await connect(device);

  if (!connected) {
    debugPrint('Failed to connect to Bluetooth printer');
    return;
  }

  final bytes = <int>[
    0x1B, 0x40,       // Initialize printer
    0x1D, 0x21, 0x00, // Normal size
    0x1B, 0x45, 0x00, // Bold OFF
    0x1B, 0x61, 0x01, // Center alignment
  ];

  void addLine(
    String text, {
    int fontSize = 1,
    bool bold = false,
  }) {
    // 1 = normal, 2 = double height, 3 = double
    // width and height.
    final sizeCommand = switch (fontSize) {
      3 => 0x11,
      2 => 0x01,
      _ => 0x00,
    };

    bytes.addAll([0x1D, 0x21, sizeCommand]);
    bytes.addAll([0x1B, 0x45, bold ? 0x01 : 0x00]);

    bytes.addAll(textToBytes(text));
    bytes.add(0x0A);

    bytes.addAll([
      0x1B, 0x45, 0x00,
      0x1D, 0x21, 0x00,
    ]);
  }

  final cards =
      directOrderResponse.orderItems![0].digitalCardDetails!;

  final showMerchant =
      await appProvider.getEnableMerchantNamePrint();

  for (int i = 0; i < cards.length; i++) {
    final s = cards[i];

    if (showMerchant) {
      addLine(
        appProvider.utilitiesModel!.data!.company!,
        fontSize: 2,
        bold: true,
      );
      addLine(_separator());
    }

    addLine(
      directOrderResponse.orderItems![0].websiteItemCode!,
      fontSize: 3,
      bold: true,
    );

    addLine("");

    addLine("Pin Code:");
    addLine(
      _addDashes(s.secretCode!),
      fontSize: 2,
      bold: true,
    );

    addLine("");

    addLine("Serial No.");
    addLine(
      s.serialNo!,
      fontSize: 2,
      bold: true,
    );

    addLine("Ref No.");
    addLine(
      s.refNo!,
      fontSize: 2,
      bold: true,
    );

    addLine(_separator());

    addLine(
      "Date: ${directOrderResponse.date} "
      "Time: ${directOrderResponse.postingTime!.split(".")[0]}",
    );

    addLine("Order No :");
    addLine(
      directOrderResponse.salesOrderId!.toString(),
      fontSize: 2,
      bold: true,
    );

    addLine(_separator());

    addLine(
      appProvider.utilitiesModel!.data!.companyName!,
      fontSize: 3,
    );

    addLine("Phone:");
    addLine(
      appProvider.utilitiesModel!.data!.mobileNo.toString(),
      fontSize: 2,
      bold: true,
    );

    if (i != cards.length - 1) {
      addLine(_separator());
      addLine("");
      addLine("");
    }
  }

  addLine("");
  addLine("");

  bytes.addAll([
    0x1B, 0x45, 0x00,
    0x1D, 0x21, 0x00,
    0x1B, 0x61, 0x00,
  ]);

  final result = await PrintBluetoothThermal.writeBytes(bytes);

  if (!result) {
    debugPrint("Failed to print");
  }
}

// Future<void> testV2Printer() async {
//   final bytes = <int>[
//     0x1B, 0x40,
//     0x1D, 0x21, 0x00,
//     0x1B, 0x45, 0x00,
//     0x1B, 0x61, 0x01,
//     ...textToBytes('NORMAL TEXT\n'),
//     ...textToBytes('1234567890\n'),
//     0x0A,
//     0x0A,
//   ];

//   final success = await PrintBluetoothThermal.writeBytes(bytes);

//   debugPrint('V2 test result: $success');
// }// Future<void> printOnBluetoothPrinter(DirectOrderResponse directOrderResponse,


//     UtilitiesModel? utilitiesModel, BuildContext context) async {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   for (StockDetails s
//       in directOrderResponse.orderItems![0].digitalCardDetails!) {
//     if (await context.read<AppProvider>().getEnableMerchantNamePrint()) {
//       await bluetooth.printCustom(
//           context.read<AppProvider>().utilitiesModel!.data!.company!, 1, 1);
//       await bluetooth.printCustom(_separator(), 1, 1);
//     }
//     await bluetooth.printCustom(
//         directOrderResponse.orderItems![0].websiteItemCode!, 3, 1);
//     await bluetooth.printNewLine();
//     await bluetooth.printCustom("Pin Code:", 1, 1);
//     await bluetooth.printCustom(_addDashes(s.secretCode!), 3, 1);
//     await bluetooth.printNewLine();
//     await bluetooth.printCustom("Serial No.", 1, 1);
//     await bluetooth.printCustom(s.serialNo!, 1, 1);
//     await bluetooth.printCustom("Ref No.", 1, 1);
//     await bluetooth.printCustom(s.refNo!, 1, 1);
//     await bluetooth.printCustom(_separator(), 1, 1);
//     await bluetooth.printCustom(
//         "Date: ${directOrderResponse.date} Time:${directOrderResponse.postingTime!.split(".")[0]}",
//         1,
//         1);
//     await bluetooth.printCustom(
//         "Order No : ${directOrderResponse.salesOrderId!.toString()}", 1, 1);
//     await bluetooth.printCustom(_separator(), 1, 1);
//     await bluetooth.printCustom(
//         context.read<AppProvider>().utilitiesModel!.data!.companyName!, 1, 1);
//     await bluetooth.printCustom("Phone:", 1, 1);
//     await bluetooth.printCustom(
//         context.read<AppProvider>().utilitiesModel!.data!.mobileNo.toString(),
//         1,
//         1);
//     if (directOrderResponse.orderItems![0].digitalCardDetails!.indexOf(s) !=
//         directOrderResponse.orderItems![0].digitalCardDetails!.length - 1) {
//       await bluetooth.printCustom(_separator(), 1, 1);
//       await bluetooth.printNewLine();
//       await bluetooth.printNewLine();
//     }
//   }
//   await bluetooth.printNewLine();
//   await bluetooth.printNewLine();
// }


// Future<void> printOnQ8Printer(
//   DirectOrderResponse order,
//   UtilitiesModel? utilitiesModel,
//   BuildContext context,
// ) async {
//   try {
//     final printer = FlutterTelpo();
//     final appProvider = context.read<AppProvider>();

//     final List<dynamic> rows = [];

//     final cards = order.orderItems![0].digitalCardDetails!;

//     final showMerchant =
//         await appProvider.getEnableMerchantNamePrint();

//     for (int i = 0; i < cards.length; i++) {
//       final s = cards[i];

//       void addText(
//         String text, {
//         int fontSize = 1,
//         bool bold = false,
//       }) {
//         rows.add(
//           PrintRow(
//             text: text,
//             fontSize: fontSize,
//             position: 1,
//             bold: bold,
//           ),
//         );
//       }

//       if (showMerchant) {
//         addText(appProvider.utilitiesModel!.data!.company!);
//         addText(_separator());
//       }

//       addText(
//         order.orderItems![0].websiteItemCode!,
//         fontSize: 2,
//         bold: true,
//       );

//       rows.add(WalkPaper(step: 1));

//       addText("Pin Code:");
//       addText(_addDashes(s.secretCode!), bold: true);

//       rows.add(WalkPaper(step: 1));

//       addText("Serial No.");
//       addText(s.serialNo!, bold: true);

//       addText("Ref No.");
//       addText(s.refNo!, bold: true);

//       addText(_separator());

//       rows.add(WalkPaper(step: 1));

//       addText(
//         "Date: ${order.date} "
//         "Time: ${order.postingTime!.split(".")[0]}",
//       );

//       addText("Order No. :");
//       addText(
//         order.salesOrderId!.toString(),
//         bold: true,
//       );

//       addText(_separator());

//       rows.add(WalkPaper(step: 1));

//       addText(
//         appProvider.utilitiesModel!.data!.companyName!,
//         bold: true,
//       );

//       addText("Phone:");
//       addText(
//         appProvider.utilitiesModel!.data!.mobileNo.toString(),
//         bold: true,
//       );

//       if (i != cards.length - 1) {
//         addText(_separator());
//         rows.add(WalkPaper(step: 5));
//       }
//     }

//     rows.add(WalkPaper(step: 20));

// await printer.print(rows, q8Mode: true);
//     debugPrint("Q8 printing completed");
//   } catch (e, stackTrace) {
//     debugPrint("Q8 PRINT ERROR: $e");
//     debugPrintStack(stackTrace: stackTrace);

//     if (context.mounted) {
//       Fluttertoast.showToast(
//         msg: "Q8 printer error: $e",
//         toastLength: Toast.LENGTH_LONG,
//       );
//     }
//   }
// }


Future<void> printOnTelpo(
  DirectOrderResponse directOrderResponse,
  UtilitiesModel? utilitiesModel,
  BuildContext context,
) async {
  try {
    final FlutterTelpo f = FlutterTelpo();
    final List<dynamic> d = [];

    final appProvider = context.read<AppProvider>();
    final cards = directOrderResponse.orderItems![0].digitalCardDetails!;

    for (int i = 0; i < cards.length; i++) {
      final StockDetails s = cards[i];

      // =========================================================
      // COMPANY NAME
      // Same as Bluetooth:
      // line(appProvider.utilitiesModel!.data!.company!);
      // =========================================================
      if (await appProvider.getEnableMerchantNamePrint()) {
        d.add(
          PrintRow(
            text: appProvider.utilitiesModel!.data!.company!,
            fontSize: 2,
            position: 1,
            bold: true
          ),
        );

        d.add(
          PrintRow(
            text: _separator(),
            fontSize: 1,
            position: 1,
          ),
        );
      }

      // =========================================================
      // PRODUCT / ITEM CODE
      // Bluetooth: large: true
      // Telpo: fontSize 3
      // =========================================================
      d.add(
        PrintRow(
          text: directOrderResponse.orderItems![0].websiteItemCode!,
          fontSize: 3,
          position: 1,
            bold: true

        ),
      );

      // Same blank line as Bluetooth
      d.add(
        WalkPaper(step: 1),
      );

      // =========================================================
      // PIN CODE LABEL
      // Bluetooth: normal
      // =========================================================
      d.add(
        PrintRow(
          text: "Pin Code:",
          fontSize: 1,
          position: 1,
        ),
      );

      // =========================================================
      // PIN VALUE
      // Bluetooth: normal because large:true is commented
      // =========================================================
      d.add(
        PrintRow(
          text: _addDashes(s.secretCode!),
          fontSize: 2,
          position: 1,
          bold: true,
        ),
      );

      // Same blank line as Bluetooth
      d.add(
        WalkPaper(step: 1),
      );

      // =========================================================
      // SERIAL
      // =========================================================
      d.add(
        PrintRow(
          text: "Serial No.",
          fontSize: 1,
          position: 1,
        ),
      );

      d.add(
        PrintRow(
          text: s.serialNo!,
          fontSize: 2,
          position: 1,
          bold: true,

        ),
      );

      // =========================================================
      // REF
      // =========================================================
      d.add(
        PrintRow(
          text: "Ref No.",
          fontSize: 1,
          position: 1,
        ),
      );

      d.add(
        PrintRow(
          text: s.refNo!,
          fontSize: 2,
          position: 1,
          bold: true,

        ),
      );

      // =========================================================
      // SEPARATOR
      // =========================================================
      d.add(
        PrintRow(
          text: _separator(),
          fontSize: 1,
          position: 1,
        ),
      );

      // Same extra newline as Bluetooth
      d.add(
        WalkPaper(step: 1),
      );

      // =========================================================
      // DATE
      // =========================================================
      d.add(
        PrintRow(
          text:
              "Date: ${directOrderResponse.date} "
              "Time: ${directOrderResponse.postingTime!.split(".")[0]}",
          fontSize: 1,
          position: 1,
        ),
      );

      // =========================================================
      // ORDER
      // =========================================================
      d.add(
        PrintRow(
          text: "Order No. :",
          fontSize: 1,
          position: 1,
        ),
      );

      d.add(
        PrintRow(
          text: directOrderResponse.salesOrderId!.toString(),
          fontSize: 2,
          position: 1,
          bold: true,

        ),
      );

      // =========================================================
      // SEPARATOR
      // =========================================================
      d.add(
        PrintRow(
          text: _separator(),
          fontSize: 1,
          position: 1,
        ),
      );

      // Same extra newline as Bluetooth
      d.add(
        WalkPaper(step: 1),
      );

      // =========================================================
      // COMPANY
      // =========================================================
      d.add(
        PrintRow(
          text: appProvider.utilitiesModel!.data!.companyName!,
          fontSize: 3,
          position: 1,
          // bold: true,

        ),
      );

      // =========================================================
      // PHONE
      // =========================================================
      d.add(
        PrintRow(
          text: "Phone:",
          fontSize: 1,
          position: 1,
        ),
      );

      d.add(
        PrintRow(
          text: appProvider.utilitiesModel!.data!.mobileNo.toString(),
          fontSize: 2,
          position: 1,
          bold: true,
        ),
      );

      // =========================================================
      // BETWEEN MULTIPLE CARDS
      // Same as Bluetooth
      // =========================================================
      if (i != cards.length - 1) {
        d.add(
          PrintRow(
            text: _separator(),
            fontSize: 1,
            position: 1,
          ),
        );

        d.add(
          WalkPaper(step: 2),
        );
      }
    }

    // Same final feed as Bluetooth
    d.add(
      WalkPaper(step: 20),
    );

    await f.print(d);
  } catch (e, stackTrace) {
    debugPrint("========== TELPO PRINT ERROR ==========");
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    if (context.mounted) {
      Fluttertoast.showToast(
        msg: "TELPO ERROR: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}

Future<void> testTelpoPrinter(
  BuildContext context) async {
  try {
    final printer = FlutterTelpo();

    final rows = <dynamic>[
      PrintRow(
        text: "JOCARDS",
        fontSize: 3,
        position: 1,
        bold: true,
      ),

      PrintRow(
        text: "****************",
        fontSize: 1,
        position: 1,
      ),

      PrintRow(
        text: "TELPO PRINTER TEST",
        fontSize: 2,
        position: 1,
        bold: true,
      ),


      WalkPaper(step: 20),
    ];

    await printer.print(rows, );

    if (!context.mounted) return;

    Fluttertoast.showToast(
      msg: "Telpo test completed",
      toastLength: Toast.LENGTH_LONG,
    );
  } catch (e, stackTrace) {
    debugPrint("TELPO TEST ERROR: $e");
    debugPrintStack(stackTrace: stackTrace);

    if (!context.mounted) return;

    Fluttertoast.showToast(
      msg: "Telpo test failed: $e",
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
// Future<void> printOnTelpo(
//   DirectOrderResponse directOrderResponse,
//   UtilitiesModel? utilitiesModel,
//   BuildContext context,
// ) async {
//   try {
//     Fluttertoast.showToast(
//       msg: "1. Creating Telpo",
//       toastLength: Toast.LENGTH_LONG,
//     );

//     final f = FlutterTelpo();

//     Fluttertoast.showToast(
//       msg: "2. Telpo created",
//       toastLength: Toast.LENGTH_LONG,
//     );

//     final List<dynamic> data = [
//       PrintRow(text: "JOCARDS", fontSize: 2, position: 1),
//       PrintRow(text: "TELPO TEST", fontSize: 2, position: 1),
//       PrintRow(text: "Hello TPS320", fontSize: 2, position: 1),
//        f.paperWalk(1),

//       WalkPaper(step: 10),
//     ];

//     Fluttertoast.showToast(
//       msg: "3. Calling print",
//       toastLength: Toast.LENGTH_LONG,
//     );

//     await f.print(data);

//     Fluttertoast.showToast(
//       msg: "4. Print method returned successfully",
//       toastLength: Toast.LENGTH_LONG,
//     );
//   } catch (e, stackTrace) {
//     debugPrint("========== TELPO PRINT ERROR ==========");
//     debugPrint(e.toString());
//     debugPrint(stackTrace.toString());

//     if (context.mounted) {
//       Fluttertoast.showToast(
//         msg: "TELPO ERROR: $e",
//         toastLength: Toast.LENGTH_LONG,
//       );
//     }
//   }
// }

// Future<void> testTelpoPrint(BuildContext context) async {
//   try {
//     final f = FlutterTelpo();

//     final List<dynamic> data = [
//       PrintRow(text: "JOCARDS", fontSize: 2, position: 1),
//       PrintRow(text: "TELPO TEST", fontSize: 2, position: 1),
//       PrintRow(text: "Hello TPS320", fontSize: 2, position: 1),
//       WalkPaper(step: 10),
//     ];

//     await f.print(data);

//     if (context.mounted) {
//       Fluttertoast.showToast(msg: "TPS320 print finished");
//     }
//   } catch (e, stackTrace) {
//     debugPrint("TPS320 ERROR: $e");
//     debugPrint("$stackTrace");

//     if (context.mounted) {
//       Fluttertoast.showToast(
//         msg: "TPS320 ERROR: $e",
//         toastLength: Toast.LENGTH_LONG,
//       );
//     }
//   }
// }

// Function to parse dynamic text and detect links
RichText buildTextWithURL({required String text, TextStyle? defaultTextStyle}) {
  // Split text into regular text and URLs using a RegExp
  final RegExp urlRegExp = RegExp(
    r'(https?:\/\/[^\s]+)', // Detect URLs starting with http or https
    caseSensitive: false,
  );
  final List<TextSpan> spans = [];

  // Using RegExp to find URLs and non-URL text segments
  final Iterable<RegExpMatch> matches = urlRegExp.allMatches(text);

  // Track the last end position of non-link text
  int lastMatchEnd = 0;

  for (final RegExpMatch match in matches) {
    // Add text before the link as regular text
    if (match.start > lastMatchEnd) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: defaultTextStyle?.copyWith(fontFamily: 'Cairo'),
        ),
      );
    }

    // Add the link as a clickable text
    final String url = match.group(0)!;
    spans.add(
      TextSpan(
        text: url,
        style:
            defaultTextStyle?.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontFamily: 'DIN Next LT W23',
            ) ??
            const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'DIN Next LT W23',
            ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
          },
      ),
    );

    // Update the lastMatchEnd to the end of the current match
    lastMatchEnd = match.end;
  }

  // Add any remaining non-link text after the last match
  if (lastMatchEnd < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'DIN Next LT W23',
        ),
      ),
    );
  }

  // Return the dynamically built RichText
  return RichText(text: TextSpan(children: spans));
}
