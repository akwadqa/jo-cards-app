import 'package:flutter/material.dart';

class TransferCheckBox extends StatefulWidget {
  const TransferCheckBox(
      {super.key,
      required this.onChanged,
      required this.isTransfer,
      required this.reedOnly});
  final void Function(bool value) onChanged;
  final bool isTransfer;
  final bool reedOnly;
  @override
  State<TransferCheckBox> createState() => _TransferCheckBoxState();
}

class _TransferCheckBoxState extends State<TransferCheckBox> {
  bool _isTransfer = false;

  @override
  void initState() {
    _isTransfer = widget.isTransfer;
    widget.onChanged(_isTransfer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isTransfer,
      onChanged: (value) {
        if (!widget.reedOnly) {
          if (value != null) {
            setState(() {
              _isTransfer = value;
            });
            widget.onChanged(_isTransfer);
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
