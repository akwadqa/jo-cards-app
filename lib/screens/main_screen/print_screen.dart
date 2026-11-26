import 'dart:convert';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
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
  bool _isTesting = false;
bool _isConnecting = false;
bool _isSaving = false;

// bool get _isQ8 =>
//     androidInfo.model.toUpperCase().contains("Q8");

bool get _isTelpo =>
    androidInfo.model.toUpperCase().contains("TPS");

bool get _isBuiltInPrinter => _isTelpo;
 @override
void initState() {
  super.initState();

  final appProvider = context.read<AppProvider>();

  autoPrint = appProvider.getEnablePrintAuto();
  printMerchantName = appProvider.getEnableMerchantNamePrint();

  SchedulerBinding.instance.addPostFrameCallback((_) async {
    if (!mounted || _isBuiltInPrinter) return;

    _device = appProvider.getBluetoothDevice();
    await _initPlatformState();
  });
}

Future<void> _initPlatformState() async {
  if (_isBuiltInPrinter) return;

  try {
    final devices = await PrintBluetoothThermal.pairedBluetooths;
    final connected = await PrintBluetoothThermal.connectionStatus;

    if (!mounted) return;

    final selectedMac = _device?.macAdress;

    BluetoothInfo? selectedDevice;

    for (final device in devices) {
      if (device.macAdress == selectedMac) {
        selectedDevice = device;
        break;
      }
    }

    setState(() {
      _devices = devices;
      _device = selectedDevice;
      _connected = connected;
    });
  } catch (e) {
    debugPrint("Bluetooth refresh error: $e");

    if (mounted) {
      await _showMessage("تعذر تحديث أجهزة البلوتوث");
    }
  }
}

Future<void> _connect() async {
  if (_device == null || _isConnecting) {
    if (_device == null) {
      await _showMessage("الرجاء اختيار الطابعة");
    }
    return;
  }

  setState(() => _isConnecting = true);

  try {
    // Disconnect first if the user selected another printer.
    final alreadyConnected =
        await PrintBluetoothThermal.connectionStatus;

    if (alreadyConnected) {
      await PrintBluetoothThermal.disconnect;
    }

    final connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: _device!.macAdress,
    );

    if (!mounted) return;

    setState(() => _connected = connected);

    if (!connected) {
      await _showMessage("فشل الاتصال بالطابعة");
    }
  } catch (e) {
    debugPrint("Bluetooth connection error: $e");

    if (mounted) {
      setState(() => _connected = false);
      await _showMessage("حدث خطأ أثناء الاتصال بالطابعة");
    }
  } finally {
    if (mounted) {
      setState(() => _isConnecting = false);
    }
  }
}

Future<void> _disconnect() async {
  if (_isConnecting) return;

  setState(() => _isConnecting = true);

  try {
    await PrintBluetoothThermal.disconnect;

    if (!mounted) return;

    setState(() => _connected = false);
  } catch (e) {
    debugPrint("Bluetooth disconnect error: $e");

    if (mounted) {
      await _showMessage("تعذر فصل الطابعة");
    }
  } finally {
    if (mounted) {
      setState(() => _isConnecting = false);
    }
  }
}

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
          padding: EdgeInsets.only(
            bottom: widgetSize.getHeight(110, context),
          ),
          children: <Widget>[
            if (!_isBuiltInPrinter) ...[
              _buildBluetoothDropdown(),
              SizedBox(
                height: widgetSize.getHeight(10, context),
              ),
            ],

            _buildAutoPrintSwitch(),

            SizedBox(
              height: widgetSize.getHeight(10, context),
            ),

            _buildPrintMerchantNameSwitch(),

            SizedBox(
              height: widgetSize.getHeight(20, context),
            ),

            _buildPrintTestButtons(),
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
      if (!_isBuiltInPrinter) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              onPressed:
                  _isConnecting ? null : _initPlatformState,
              child: const Text(
                'تحديث',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(width: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _connected ? Colors.green : Colors.red,
              ),
              onPressed: _isConnecting
                  ? null
                  : (_connected ? _disconnect : _connect),
              child: Text(
                _isConnecting
                    ? 'جاري الاتصال...'
                    : _connected
                        ? 'متصل'
                        : 'غير متصل',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],

      Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 20,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
          ),
          onPressed: _isTesting ? null : _handleTestPrint,
          child: _isTesting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'اختبار الطباعة',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    ],
  );
}
Future<void> _handleTestPrint() async {
  if (_isTesting) return;

  setState(() => _isTesting = true);

  try {
    if (_isBuiltInPrinter) {
      await testTelpoPrinter(
        context,
        // q8Mode: _isQ8,
      );
    } else {
      await _testPrint();
    }
  } catch (e, stackTrace) {
    debugPrint("TEST PRINT ERROR: $e");
    debugPrintStack(stackTrace: stackTrace);

    if (mounted) {
      await _showMessage("فشل اختبار الطباعة: $e");
    }
  } finally {
    if (mounted) {
      setState(() => _isTesting = false);
    }
  }
}

Future<void> _testPrint() async {
  if (_device == null) {
    await _showMessage("الرجاء اختيار طابعة البلوتوث");
    return;
  }

  if (!_connected) {
    await _connect();
  }

  if (!mounted || !_connected) return;

  final bytes = <int>[
    0x1B, 0x40,       // Initialize
    0x1D, 0x21, 0x00, // Normal size
    0x1B, 0x45, 0x00, // Bold OFF
    0x1B, 0x61, 0x01, // Center
  ];

  void line(String text, {bool bold = false}) {
    bytes.addAll([
      0x1B, 0x45, bold ? 0x01 : 0x00,
    ]);

    bytes.addAll(textToBytes(text));
    bytes.add(0x0A);

    bytes.addAll([0x1B, 0x45, 0x00]);
  }

  line("JOCARDS", bold: true);
  line("****************");
  line("BLUETOOTH PRINTER TEST");
  line("****************");
  line("PRINT TEST OK");

  line("");

  bytes.addAll([
    0x1B, 0x45, 0x00,
    0x1D, 0x21, 0x00,
    0x1B, 0x61, 0x00,
  ]);

  final result =
      await PrintBluetoothThermal.writeBytes(bytes);

  if (!result && mounted) {
    await _showMessage("فشل إرسال الاختبار إلى الطابعة");
  }
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
  // Future<void> _testPrint() async {
  //   final testText = "Printer Test\n\n";
  //   final bytes = textToBytes(testText);

  //   await PrintBluetoothThermal.writeBytes(bytes.toList());
  // }

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
  if (_isSaving) return;

  setState(() => _isSaving = true);

  try {
    final appProvider = context.read<AppProvider>();

    await appProvider.enableMerchantNamePrint(
      printMerchantName,
    );

    await appProvider.enableDisablePrintAfterDirectOrder(
      autoPrint,
    );

    if (_isBuiltInPrinter) {
      if (mounted) Navigator.pop(context);
      return;
    }

    if (_device == null) {
      await _showMessage("الرجاء اختيار جهاز من القائمة");
      return;
    }

    await appProvider.saveBluetoothDevice(_device!);

    if (!_connected) {
      await _connect();
    }

    if (!mounted) return;

    if (_connected) {
      Navigator.pop(context);
    } else {
      await _showMessage(
        "تم حفظ الإعدادات، لكن تعذر الاتصال بالطابعة",
      );
    }
  } catch (e) {
    debugPrint("SAVE PRINTER SETTINGS ERROR: $e");

    if (mounted) {
      await _showMessage("تعذر حفظ إعدادات الطابعة");
    }
  } finally {
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }
}
  Future<void> _showMessage(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

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
