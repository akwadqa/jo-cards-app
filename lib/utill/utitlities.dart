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
  
  String mobileNumber = await context
          .read<AppProvider>()
          .getEnableMerchantNamePrint()
      ? "هاتف: \n${context.read<AppProvider>().utilitiesModel!.data!.companyWhatsappNumber!}\n${_separator(SeparatorType.dash)}\n"
      : '';

  String company =
      await context.read<AppProvider>().getEnableMerchantNamePrint()
          ? context.read<AppProvider>().utilitiesModel!.data!.company!
          : '';

  var shareString = company +
      mobileNumber +
      '*' +
      res.orderItems![0].websiteItemCode! +
      '*' +
      "\n";

  for (StockDetails stock in res.orderItems![0].digitalCardDetails!) {
    shareString = shareString +
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
    systemNavigationBarDividerColor: Colors.transparent);

var transparentStatusBarAndTransparentSystemBar =
    SystemUiOverlayStyle.dark.copyWith(
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

enum SeparatorType {
  dash,
  star,
}

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
            toastLength: Toast.LENGTH_LONG);
      }
      await Provider.of<AppProvider>(navigator.currentContext!, listen: false)
          .setSignOutUser();

      print("===================== go to sign in from utilites ===========");
      Navigator.of(navigator.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (Route<dynamic> route) => false);
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
  logOut
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
        Shadow(
          color: this.color ?? Colors.black,
          offset: Offset(0, -distance),
        )
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
Future<void> printOnBluetoothPrinter(DirectOrderResponse directOrderResponse,
    UtilitiesModel? utilitiesModel, BuildContext context) async {
  
  List<String> lines = [];

  for (StockDetails s in directOrderResponse.orderItems![0].digitalCardDetails!) {
    if (await context.read<AppProvider>().getEnableMerchantNamePrint()) {
      lines.add(context.read<AppProvider>().utilitiesModel!.data!.company!);
      lines.add(_separator());
    }

    lines.add(directOrderResponse.orderItems![0].websiteItemCode!);
    lines.add("");
    lines.add("Pin Code:");
    lines.add(_addDashes(s.secretCode!));
    lines.add("");
    lines.add("Serial No.");
    lines.add(s.serialNo!);
    lines.add("Ref No.");
    lines.add(s.refNo!);
    lines.add(_separator());
    lines.add("Date: ${directOrderResponse.date} Time: ${directOrderResponse.postingTime!.split(".")[0]}");
    lines.add("Order No : ${directOrderResponse.salesOrderId!.toString()}");
    lines.add(_separator());
    lines.add(context.read<AppProvider>().utilitiesModel!.data!.companyName!);
    lines.add("Phone:");
    lines.add(context.read<AppProvider>().utilitiesModel!.data!.mobileNo.toString());

    if (directOrderResponse.orderItems![0].digitalCardDetails!.indexOf(s) !=
        directOrderResponse.orderItems![0].digitalCardDetails!.length - 1) {
      lines.add(_separator());
      lines.add("\n\n");
    }
  }

  // Send to printer
  final result = await PrintBluetoothThermal.writeBytes(
    Uint8List.fromList(textToBytes(lines.join('\n')))
  );

  if (!result) {
    print("Failed to print");
  }
}

// Future<void> printOnBluetoothPrinter(DirectOrderResponse directOrderResponse,
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




Future<void> printOnTelpo(DirectOrderResponse directOrderResponse,
    UtilitiesModel? utilitiesModel, BuildContext context) async {
  FlutterTelpo f = FlutterTelpo();
  List<dynamic> d = [];
  for (StockDetails s
      in directOrderResponse.orderItems![0].digitalCardDetails!) {
    if (await context.read<AppProvider>().getEnableMerchantNamePrint()) {
      d.add(PrintRow(
          text: context.read<AppProvider>().utilitiesModel!.data!.company!,
          fontSize: 1,
          position: 1));
      d.add(PrintRow(text: _separator(), fontSize: 2, position: 1));
    }
    d.add(PrintRow(
        text: directOrderResponse.orderItems![0].websiteItemCode!,
        fontSize: 3,
        position: 1));
    d.add(WalkPaper(step: 2));
    d.add(PrintRow(text: "Pin Code:", fontSize: 2, position: 1));
    d.add(PrintRow(text: _addDashes(s.secretCode!), fontSize: 3, position: 1));
    d.add(WalkPaper(step: 2));
    d.add(PrintRow(text: "Serial No.", fontSize: 2, position: 1));
    d.add(PrintRow(text: s.serialNo!, fontSize: 2, position: 1));
    d.add(PrintRow(text: "Ref No.", fontSize: 2, position: 1));
    d.add(PrintRow(text: s.refNo!, fontSize: 2, position: 1));
    d.add(PrintRow(text: _separator(), fontSize: 2, position: 1));
    d.add(PrintRow(
        text:
            "Date: ${directOrderResponse.date} Time:${directOrderResponse.postingTime!.split(".")[0]}",
        fontSize: 1,
        position: 1));
    d.add(PrintRow(
        text: "Order No.: ${directOrderResponse.salesOrderId!.toString()}",
        fontSize: 2,
        position: 1));
    d.add(PrintRow(text: _separator(), fontSize: 2, position: 1));
    d.add(PrintRow(
        text: context.read<AppProvider>().utilitiesModel!.data!.companyName!,
        fontSize: 2,
        position: 1));
    d.add(PrintRow(text: "Phone:", fontSize: 2, position: 1));
    d.add(PrintRow(
        text: context
            .read<AppProvider>()
            .utilitiesModel!
            .data!
            .mobileNo
            .toString(),
        fontSize: 2,
        position: 1));
    if (directOrderResponse.orderItems![0].digitalCardDetails!.indexOf(s) !=
        directOrderResponse.orderItems![0].digitalCardDetails!.length - 1) {
      d.add(PrintRow(text: _separator(), fontSize: 2, position: 1));
      d.add(WalkPaper(step: 10));
    }
  }
  d.add(WalkPaper(step: 20));
  f.print(d);
}

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
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd, match.start),
        style: defaultTextStyle?.copyWith(fontFamily: 'Cairo'),
      ));
    }

    // Add the link as a clickable text
    final String url = match.group(0)!;
    spans.add(TextSpan(
      text: url,
      style: defaultTextStyle?.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontFamily: 'DIN Next LT W23') ??
          const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'DIN Next LT W23'),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }
        },
    ));

    // Update the lastMatchEnd to the end of the current match
    lastMatchEnd = match.end;
  }

  // Add any remaining non-link text after the last match
  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastMatchEnd),
      style: const TextStyle(
          color: Colors.black, fontSize: 16, fontFamily: 'DIN Next LT W23'),
    ));
  }

  // Return the dynamically built RichText
  return RichText(
    text: TextSpan(children: spans),
  );
}
