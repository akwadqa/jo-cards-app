import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../generated/assets.dart';
import '../../main.dart';
import '../../model/direct_order_response.dart';
import '../../model/row.dart';
import '../../utill/color_resources.dart';
import '../../utill/flutter_telpo.dart';
import '../../utill/widget_size.dart';
import '../widget/safe_on_tap.dart';

class PrintScreen extends StatefulWidget {
  DirectOrderResponse directOrderResponse;


  PrintScreen(this.directOrderResponse);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {



  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  String ?pathImage;
  bool autoPrint= false;
  bool printMerchantName= false;

  @override
  void initState() {
    super.initState();
    autoPrint = context.read<AppProvider>().getEnablePrintAuto();
    print(autoPrint.toString());
    printMerchantName = context.read<AppProvider>().getEnableMerchantNamePrint();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      if(!androidInfo.model!.contains("TPS")) {
        _device = context.read<AppProvider>().getBluetoothDevice();
        initPlatformState();
      }
    });



  }



  Future<void> initPlatformState() async {
    bool ?isConnected = await bluetooth.isConnected;


    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected!=null&&isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    TextEditingController Printer = TextEditingController();


    late Uint8List theimageThatComesfromThePrinter ;
    String dir = Directory.current.path;
    return Scaffold(
        appBar:  buildAppBar(context),
        body:  thermialP(),
      );

  }

 thermialP()  {
    return Container(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context),vertical: widgetSize.getHeight(10, context)),
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: !androidInfo.model!.contains("TPS"),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    const Expanded(
                      child: Text(
                        'أجهزة البلوتوث',
                        style: TextStyle(

                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorResources.summerSky,
                          borderRadius: BorderRadius.circular(10)
                        ),

                        child: DropdownButton<BluetoothDevice>(
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.white,
dropdownColor: ColorResources.summerSky,
                         isExpanded: true,
                          items: _getDeviceItems(),underline: Container(),
                          onChanged: (value) => setState(()
                          {
                            _device=value;
                          }),
                          value: _device,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widgetSize.getHeight(10, context),
              ),
              Row(children: [
                Text(
                  'اطبع الفاتورة بشكل آلي مع الطلب',
                  style: TextStyle(
                    fontFamily: 'DIN Next LT W23',
                    fontSize: widgetSize.getWidth(16, context),
                    color: const Color(0xff6b6b6b),
                  ),
                  softWrap: false,
                ),
                Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Switch(
                    value: autoPrint,
                    onChanged: (value) async {

                   // await  context.read<AppProvider>().enableDisablePrintAfterDirectOrder(!context.read<AppProvider>().getEnablePrintAuto());
                    setState(() {
autoPrint=!autoPrint;
                    });
                    },
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: ColorResources.light_grey,
                    activeTrackColor:ColorResources.endeavour,
                    activeColor:  Colors.white,
                  ),
                ),
              ],),
              SizedBox(
                height: widgetSize.getHeight(10, context),
              ),
              Row(children: [
                Text(
                  'طباعة إسم المتجر',
                  style: TextStyle(
                    fontFamily: 'DIN Next LT W23',
                    fontSize: widgetSize.getWidth(16, context),
                    color: const Color(0xff6b6b6b),
                  ),
                  softWrap: false,
                ),
                Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Switch(
                    value: printMerchantName,
                    onChanged: (value) async {

                      setState(() {
                        printMerchantName=!printMerchantName;
                      });
                    },
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: ColorResources.light_grey,
                    activeTrackColor:ColorResources.endeavour,
                    activeColor:  Colors.white,
                  ),
                ),
              ],),
              Visibility(visible: false,
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.brown),
                        onPressed: () {
                          initPlatformState();
                        },
                        child: Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: _connected ? Colors.red : Colors.green),
                        onPressed: _connected ? _disconnect : _connect,
                        child: Text(
                          _connected ? 'Disconnect' : 'Connect',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),


                  Padding(
                    padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      onPressed: () async{
                        var imageTextRawUint8List = await screenshotController.capture(pixelRatio: 1.5,delay: Duration(seconds: 1)) ?? Uint8List(0);
                        bluetooth.printImageBytes(imageTextRawUint8List);
                        bluetooth. paperCut();
                        //  await printOnBluetoothPrinter();











                        //  bluetooth.printImage(pathImage!);


                        //path of your image/logo

                        //   TestPrintables().printThroughUsbPrinter();
/*
                      FlutterTelpo f =  FlutterTelpo();
                      List<dynamic> d = [];
                      d.add(PrintRow(text: "ععععع",fontSize: 2,position: 10));
                      d.add(WalkPaper(step: 1));
                      d.add(PrintRow(text: "ععععع",fontSize: 3,position: 2));
                      d.add(WalkPaper(step: 50));*/


                        // f.print(d);
                        // _getBatteryLevel();

                      },
                      child: Text('PRINT TEST',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Screenshot(
                    controller: screenshotController,
                    child:    Container(
                      color: Colors.white,

                      child:     Column( crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            "تفاصيل الطلب",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(height: 20,),
                          Text(
                            "أمنية  4",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "الكمية 2",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: false,
                          ),

                          Text(
                            "********************************************************",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: false,
                          ),

                          Text(
                            "أمنية  4",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "الكمية 2",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: false,
                          ),

                          Text(
                            "********************************************************",
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: false,
                          ),


                        ],
                      ),
                    ),
                  ),
                ],),
              ),
              SizedBox(
                height: widgetSize.getHeight(50, context),
              ),
              SafeOnTap(onSafeTap: ()async{
                await  context.read<AppProvider>().enableMerchantNamePrint(printMerchantName);
                await  context.read<AppProvider>().enableDisablePrintAfterDirectOrder(autoPrint);
                if(!androidInfo.model!.contains("TPS")) {
                  await context.read<AppProvider>().saveBluetoothDevice(
                      jsonEncode(_device!.toMap()));
                  _disconnect();
                  _connect();
                }
                Navigator.pop(context);

              },
                child: Container(
                  height: widgetSize.getHeight(60, context),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xff2892d7),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: const Color(0xff2892d7)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x401d4c9b),
                        offset: Offset(0, 5),
                        blurRadius: 11,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'حفظ',
                      style: TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: widgetSize.getHeight(20, context),
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      );
  }

 Future<void> printOnBluetoothPrinter(DirectOrderResponse directOrderResponse) async {
   await bluetooth.printCustom(directOrderResponse.orderItems![0].websiteItemName!, 3, 1);
   await bluetooth.printCustom("******************************************", 0, 0);

   for(StockDetails s in directOrderResponse.orderItems![0].stockDetails! ){
     await bluetooth.printCustom("PIN CODE 1 ", 3, 1);
     await bluetooth.printCustom(s.secretCode!, 2, 1);
     await bluetooth.printCustom("******************************************", 0, 0);
     await bluetooth.printCustom("Serial No", 1, 1);
     await bluetooth.printCustom(s.serialNo!, 1, 1);
     await bluetooth.printCustom("Ref No", 1, 1);
     await bluetooth.printCustom(s.refNo!, 1, 1);
   }

   await bluetooth.printCustom("******************************************", 0, 0);

   await bluetooth.printCustom("Date: ${directOrderResponse.date}   Time:${directOrderResponse.postingTime!.split(".")[0]}", 0, 0);
   await bluetooth.printCustom("Order No : ${directOrderResponse.orderId!.toString()}", 0, 1);
   await bluetooth.printCustom("******************************************", 0, 0);
 }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Center(child: Text('اختر الطابعة',style: TextStyle(color: Colors.white))),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Center(child: Container(child: Text(device.name!,style: TextStyle(color: Colors.white),)),),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return  File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  Future<Uint8List> _generateImageFromString(
      String text,
      TextAlign align,
      ) async {
    PictureRecorder recorder =  PictureRecorder();
    Canvas canvas = Canvas(
        recorder,
        Rect.fromCenter(
          center: Offset(0, 0),
          width: 550,
          height: 400, // cheated value, will will clip it later...
        ));
    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(
        text: span,
        maxLines: 3,
        textAlign: align,
        textDirection: TextDirection.ltr);
    tp.layout(minWidth: 550, maxWidth: 550);
    tp.paint(canvas, const Offset(0.0, 0.0));
    var picture = recorder.endRecording();
    final pngBytes = await picture.toImage(
      tp.size.width.toInt(),
      tp.size.height.toInt() - 2, // decrease padding
    );
    final byteData = await pngBytes.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SafeOnTap(onSafeTap: () { Navigator.pop(context);
             },
                    child: SvgPicture.asset(Assets.svgBack)),
                Spacer(),
                Text(
                  "إعدادات الطابعة",
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(16, context),
                    color: const Color(0xffffffff),
                  ),
                  softWrap: false,
                ),
                Spacer(),

              ],
            ),
          ),
        ));
  }


}
