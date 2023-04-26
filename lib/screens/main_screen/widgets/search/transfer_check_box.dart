import 'package:flutter/material.dart';

class TransferCheckBox extends StatefulWidget {
  const TransferCheckBox({Key? key, required this.onChanged}) : super(key: key);
  final void Function(bool value) onChanged;

  @override
  State<TransferCheckBox> createState() => _TransferCheckBoxState();
}

class _TransferCheckBoxState extends State<TransferCheckBox> {
  bool _isTransfer = false;

  @override
  void initState() {
    widget.onChanged(_isTransfer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: _isTransfer, onChanged: (value) {
      if(value != null) {
        setState(() {
          _isTransfer = value;
        });
        widget.onChanged(_isTransfer);
      }
    },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
