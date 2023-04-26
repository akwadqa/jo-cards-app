import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/utill/strings.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' hide Headers;

import '../main.dart';
import '../model/direct_order_response.dart';
import '../model/row.dart';
import '../model/utilities_model.dart';
import '../provider/app_provider.dart';
import '../screens/auth/sign_in_screen.dart';
import 'color_resources.dart';
import 'flutter_telpo.dart';



Future<void> shareOrder(DirectOrderResponse res, BuildContext context) async {

    String mobileNumber = await context
        .read<AppProvider>()
        .getEnableMerchantNamePrint()
        ? "هاتف: \n" + context.read<AppProvider>().utilitiesModel!.data!.companyWhatsappNumber! + "\n" + _separator(SeparatorType.dash) + "\n" : '' ;

    String company = await context
        .read<AppProvider>()
        .getEnableMerchantNamePrint()
        ? context.read<AppProvider>().utilitiesModel!.data!.company! : '';

    var shareString = company +
        mobileNumber +
        '*' + res.orderItems![0].websiteItemCode! + '*' +"\n";

    for(StockDetails stock in res.orderItems![0].stockDetails!){
        shareString = shareString +"الرقم السري: \n"+ '*' + _addDashes(stock.secretCode!)+ '*' +"\n";
        shareString = shareString +"الرقم التسلسلي: \n"+'\b${stock.serialNo!}'+"\n";
        shareString = shareString +"رقم المرجع: \n"+stock.refNo!+"\n" + _separator(SeparatorType.dash) +"\n";
    }
    shareString= shareString+res.date!+"\n"
        +res.postingTime!.split(".")[0]+"\n";
    shareString = shareString + "رقم الطلب: "+ res. orderId!+"\n"+ _separator(SeparatorType.dash) +"\n";
    shareString = shareString + context.read<AppProvider>().utilitiesModel!.data!.companyName!+"\n";
    shareString = shareString + context.read<AppProvider>().utilitiesModel!.data!.mobileNo!;
    await  Share.share(shareString);
}
var transparentStatusBarAndDarkSystemBar = SystemUiOverlayStyle.light
    .copyWith( statusBarColor:  Colors.white,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor:   ColorResources.light_grey,systemNavigationBarDividerColor: Colors.transparent);

var transparentStatusBarAndTransparentSystemBar = SystemUiOverlayStyle.dark
    .copyWith( statusBarColor:  Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor:   Colors.transparent,systemNavigationBarIconBrightness:  Brightness.dark,);

getScreenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
}
getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
}

makePhoneCall(String url) async {

    await launch(url);

}

enum SeparatorType {
    dash,
    star,
}

String _separator([SeparatorType separatorType = SeparatorType.star]) => separatorType == SeparatorType.star ? '**********' : '----------';

String _addDashes(String text) {
    return text.replaceAllMapped(RegExp(r'(\w{4})'), (Match match) {
        return '${match[0]}-';
    });
}

forceSignOut(DioError error) async {
    if (error.response?.statusCode == 401) {
        if(sharedPreferences.getString(Strings.Token)!=null){
            Fluttertoast.showToast(
                backgroundColor: Colors.red,
                textColor: Colors.white,
                msg:error.response!.data["message"] ?? '',
                timeInSecForIosWeb: 10,
                toastLength: Toast.LENGTH_LONG);
            await Provider.of<AppProvider>(navigator.currentContext!,listen:false).setSignOutUser();


            Navigator.of(navigator.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                SignInScreen()), (Route<dynamic> route) => false);
        }}
}



Color hexToColor(String code) {
    return  Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
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
enum SettingName{
    profile,notifications,faq,languages,help,contacts,aboutUs,logOut
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


 Future <bool?> connect(BluetoothDevice? _device) async {
    if (_device == null) {
        return false;
    } else {

        var res = await bluetooth.isConnected;
        if(!res!){



            try {
                var res = await bluetooth.connect(_device);
                return true;
            }
            catch(e){
                return false;
            }
        }

    }
}

Future<void> printOnBluetoothPrinter(DirectOrderResponse directOrderResponse,UtilitiesModel? utilitiesModel, BuildContext context) async {

    for(StockDetails s in directOrderResponse.orderItems![0].stockDetails! ){
        if(await context
            .read<AppProvider>()
            .getEnableMerchantNamePrint()){
            await bluetooth.printCustom(context.read<AppProvider>().utilitiesModel!.data!.company!, 1, 1);
            await bluetooth.printCustom(_separator(), 1, 1);
        }
        await bluetooth.printCustom(directOrderResponse.orderItems![0].websiteItemCode!, 3, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom("Pin Code:", 1, 1);
        await bluetooth.printCustom(_addDashes(s.secretCode!), 3, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom("Serial No.", 1, 1);
        await bluetooth.printCustom(s.serialNo!, 1, 1);
        await bluetooth.printCustom("Ref No.", 1, 1);
        await bluetooth.printCustom(s.refNo!, 1, 1);
        await bluetooth.printCustom(_separator(), 1, 1);
        await bluetooth.printCustom("Date: ${directOrderResponse.date} Time:${directOrderResponse.postingTime!.split(".")[0]}", 1, 1);
        await bluetooth.printCustom("Order No : ${directOrderResponse.orderId!.toString()}", 1, 1);
        await bluetooth.printCustom(_separator(), 1, 1);
        await bluetooth.printCustom(context.read<AppProvider>().utilitiesModel!.data!.companyName!, 1, 1);
        await bluetooth.printCustom("Phone:", 1, 1);
        await bluetooth.printCustom(context.read<AppProvider>().utilitiesModel!.data!.mobileNo.toString(), 1, 1);
        if(directOrderResponse.orderItems![0].stockDetails!.indexOf(s) != directOrderResponse.orderItems![0].stockDetails!.length -1) {
            await bluetooth.printCustom(_separator(), 1, 1);
            await bluetooth.printNewLine();
            await bluetooth.printNewLine();
        }
    }
    await bluetooth.printNewLine();
    await bluetooth.printNewLine();
}
Future<void> printOnTelpo(DirectOrderResponse directOrderResponse,UtilitiesModel? utilitiesModel, BuildContext context) async {
    FlutterTelpo f =  FlutterTelpo();
    List<dynamic> d = [];
    for(StockDetails s in directOrderResponse.orderItems![0].stockDetails! ){
        if(await context
            .read<AppProvider>()
            .getEnableMerchantNamePrint()){
            d.add(PrintRow(text: context.read<AppProvider>().utilitiesModel!.data!.company!,fontSize: 1,position: 1));
            d.add(PrintRow(text: _separator() ,fontSize: 2,position: 1));
        }
        d.add(PrintRow(text: directOrderResponse.orderItems![0].websiteItemCode!,fontSize: 3,position: 1));
        d.add(WalkPaper(step: 2));
        d.add(PrintRow(text: "Pin Code:",fontSize: 2,position: 1));
        d.add(PrintRow(text: _addDashes(s.secretCode!),fontSize: 3,position: 1));
        d.add(WalkPaper(step: 2));
        d.add(PrintRow(text: "Serial No.",fontSize: 2,position: 1));
        d.add(PrintRow(text: s.serialNo!,fontSize: 2,position: 1));
        d.add(PrintRow(text: "Ref No.",fontSize: 2,position: 1));
        d.add(PrintRow(text: s.refNo!,fontSize: 2,position: 1));
        d.add(PrintRow(text: _separator() ,fontSize: 2,position:1));
        d.add(PrintRow(text: "Date: ${directOrderResponse.date} Time:${directOrderResponse.postingTime!.split(".")[0]}",fontSize: 1,position: 1));
        d.add(PrintRow(text: "Order No.: ${directOrderResponse.orderId!.toString()}",fontSize: 2,position: 1));
        d.add(PrintRow(text: _separator() ,fontSize: 2,position:1));
        d.add(PrintRow(text: context.read<AppProvider>().utilitiesModel!.data!.companyName!,fontSize: 2,position: 1));
        d.add(PrintRow(text: "Phone:",fontSize: 2,position: 1));
        d.add(PrintRow(text: context.read<AppProvider>().utilitiesModel!.data!.mobileNo.toString() ,fontSize: 2,position: 1));
        if(directOrderResponse.orderItems![0].stockDetails!.indexOf(s) != directOrderResponse.orderItems![0].stockDetails!.length -1) {
            d.add(PrintRow(text: _separator() ,fontSize: 2,position:1));
            d.add(WalkPaper(step: 10));
        }
    }
    d.add(WalkPaper(step: 20));
    f.print(d);
}
