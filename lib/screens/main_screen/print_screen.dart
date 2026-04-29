import 'dart:convert';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/utill/strings.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../model/direct_order_response.dart';
import '../../utill/color_resources.dart';
import '../../utill/widget_size.dart';
import '../widget/safe_on_tap.dart';

class PrintScreen extends StatefulWidget {
  final DirectOrderResponse directOrderResponse;

  const PrintScreen(this.directOrderResponse, {super.key});

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice? _device;
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _device;

  bool _connected = false;
  bool autoPrint = false;
  bool printMerchantName = false;
  final ScreenshotController screenshotController = ScreenshotController();
  PrintBluetoothThermal bluetooth = PrintBluetoothThermal();
  Future<void> _connect() async {
    if (_device == null) {
      _showMessage('No device selected.');
      return;
    }

    bool connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: _device!.macAdress,
    );
    setState(() {
      _connected = connected;
    });
  }

  Future<void> _disconnect() async {
    await PrintBluetoothThermal.disconnect;
    setState(() => _connected = false);
  }

  @override
  void initState() {
    super.initState();
    final appProvider = context.read<AppProvider>();
    autoPrint = appProvider.getEnablePrintAuto();
    printMerchantName = appProvider.getEnableMerchantNamePrint();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!androidInfo.model.contains("TPS")) {
        _device = appProvider.getBluetoothDevice();
        await _initPlatformState();
      }
    });
  }

  Future<void> _initPlatformState() async {
    final bool isConnected = await PrintBluetoothThermal.connectionStatus;
    setState(() => _connected = isConnected);

    final devices = await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      _devices = devices;
    });
  }

  // Future<void> _initPlatformState() async {
  //   try {
  //     _devices = await bluetooth.getBondedDevices();
  //   } on PlatformException {
  //     // Handle Error
  //   }

  //   bluetooth.onStateChanged().listen((state) {
  //     setState(() {
  //       _connected = state == BlueThermalPrinter.CONNECTED;
  //     });
  //   });

  //   if (!mounted) return;
  //   setState(() {
  //     _devices = _devices;
  //   });

  //   final isConnected = await bluetooth.isConnected;
  //   if (isConnected != null && isConnected) {
  //     setState(() {
  //       _connected = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent());
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widgetSize.getWidth(16, context),
        vertical: widgetSize.getHeight(10, context),
      ),
      child: Stack(
        children: [
          ListView(
            children: <Widget>[
              if (!androidInfo.model.contains("TPS")) _buildBluetoothDropdown(),
              SizedBox(height: widgetSize.getHeight(10, context)),
              _buildAutoPrintSwitch(),
              SizedBox(height: widgetSize.getHeight(10, context)),
              _buildPrintMerchantNameSwitch(),
              if (_device != null &&
                  _devices.isNotEmpty &&
                  !androidInfo.model.contains("TPS")) ...[
                _buildPrintTestButtons(),
                SizedBox(height: widgetSize.getHeight(100, context)),
              ],
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildBluetoothDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(child: Text('أجهزة البلوتوث', style: TextStyle())),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.summerSky,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<BluetoothInfo>(
              iconEnabledColor: Colors.white,
              dropdownColor: ColorResources.summerSky,
              isExpanded: true,
              items: _getDeviceItems(),
              underline: Container(),
              onChanged: (value) => setState(() {
                _device = value;
              }),
              value: _devices.contains(_device) ? _device : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoPrintSwitch() {
    return Row(
      children: [
        Text(
          'اطبع الفاتورة بشكل آلي مع الطلب',
          style: TextStyle(
            fontFamily: 'DIN Next LT W23',
            fontSize: widgetSize.getWidth(16, context),
            color: const Color(0xff6b6b6b),
          ),
        ),
        const Spacer(),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Switch(
            value: autoPrint,
            onChanged: (value) async {
              final appProvider = context.read<AppProvider>();
              await appProvider.enableDisablePrintAfterDirectOrder(
                !appProvider.getEnablePrintAuto(),
              );
              setState(() {
                autoPrint = !autoPrint;
              });
            },
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: ColorResources.light_grey,
            activeTrackColor: ColorResources.endeavour,
            activeColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPrintMerchantNameSwitch() {
    return Row(
      children: [
        Text(
          'طباعة إسم المتجر',
          style: TextStyle(
            fontFamily: 'DIN Next LT W23',
            fontSize: widgetSize.getWidth(16, context),
            color: const Color(0xff6b6b6b),
          ),
        ),
        const Spacer(),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Switch(
            value: printMerchantName,
            onChanged: (value) {
              setState(() {
                printMerchantName = !printMerchantName;
              });
            },
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: ColorResources.light_grey,
            activeTrackColor: ColorResources.endeavour,
            activeColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPrintTestButtons() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: _initPlatformState,
              child: const Text('تحديث', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _connected ? Colors.red : Colors.green,
              ),
              onPressed: _connected ? _disconnect : _connect,
              child: Text(
                _connected ? 'غير متصل' : 'متصل',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            onPressed: _testPrint,
            child: const Text(
              'اختبار الطباعة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Screenshot(
          controller: screenshotController,
          child: Container(color: Colors.white, height: 300),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SafeOnTap(
      onSafeTap: _saveSettings,
      child: Container(
        height: widgetSize.getHeight(60, context),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2892d7),
          borderRadius: BorderRadius.circular(15.0),
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
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothInfo>> _getDeviceItems() {
    if (_devices.isEmpty) {
      return [
        const DropdownMenuItem(
          value: null,
          child: Center(
            child: Text('اختر الطابعة', style: TextStyle(color: Colors.white)),
          ),
        ),
      ];
    }

    return _devices.map((device) {
      return DropdownMenuItem(
        value: device,
        child: Center(
          child: Text(device.name, style: const TextStyle(color: Colors.white)),
        ),
      );
    }).toList();
  }

  // List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
  //   if (_devices.isEmpty) {
  //     return [
  //       const DropdownMenuItem(
  //         child: Center(
  //             child:
  //                 Text('اختر الطابعة', style: TextStyle(color: Colors.white))),
  //       )
  //     ];
  //   }
  //   return _devices.map((device) {
  //     return DropdownMenuItem(
  //       value: device,
  //       child: Center(
  //         child:
  //             Text(device.name!, style: const TextStyle(color: Colors.white)),
  //       ),
  //     );
  //   }).toList();
  // }
  Future<void> _testPrint() async {
    final testText = "اختبار الطباعة\n\n";
    // Uint8List.fromList(textToBytes(testText));
    // final bytes = PrintBluetoothThermal.textToBytes(testText);
    final bytes = Uint8List.fromList(textToBytes(testText));
    ;
    await PrintBluetoothThermal.writeBytes(bytes);
  }

  // Future<void> _testPrint() async {
  //   final imageBytes = await screenshotController.capture(
  //           pixelRatio: 1.5, delay: const Duration(seconds: 1)) ??
  //       Uint8List(0);
  //   bluetooth.printImageBytes(imageBytes);
  //   bluetooth.paperCut();
  // }

  // void _connect() {
  //   if (_device == null) {
  //     _showMessage('No device selected.');
  //   } else {
  //     bluetooth.isConnected.then((isConnected) {
  //       if (isConnected == false) {
  //         bluetooth.connect(_device!).catchError((_) {
  //           setState(() => _connected = false);
  //         });
  //         setState(() => _connected = true);
  //       }
  //     });
  //   }
  // }

  // void _disconnect() {
  //   bluetooth.disconnect();
  //   setState(() => _connected = false);
  // }

  Future<void> _saveSettings() async {
    final appProvider = context.read<AppProvider>();
    await appProvider.enableMerchantNamePrint(printMerchantName);
    await appProvider.enableDisablePrintAfterDirectOrder(autoPrint);

    if (_device == null) {
      Fluttertoast.showToast(
        backgroundColor: ColorResources.nightRider,
        textColor: Colors.white,
        msg: "الرجاء اختيار جهاز من القائمة",
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      if (!androidInfo.model.contains("TPS")) {
        await appProvider.saveBluetoothDevice(
          jsonEncode({"name": _device!.name, "macAdress": _device!.macAdress}),
        );
        _disconnect();
        _connect();
      }
      Navigator.pop(context);
    }
  }

  Future<void> _showMessage(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: duration,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: const BoxDecoration(
          color: ColorResources.studio,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: widgetSize.getHeight(30, context),
            right: widgetSize.getWidth(16, context),
            left: widgetSize.getWidth(16, context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeOnTap(
                onSafeTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(Assets.svgBack),
              ),
              const Spacer(),
              Text(
                "إعدادات الطابعة",
                style: TextStyle(
                  fontSize: widgetSize.getHeight(16, context),
                  color: const Color(0xffffffff),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
