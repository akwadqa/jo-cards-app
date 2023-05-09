import 'package:flutter/material.dart';

class AkwadCheckBox extends StatelessWidget {
  final bool typeValue;
  final String typeName;
  final void Function(bool?)? function;
  const AkwadCheckBox({Key? key, required this.typeValue, required this.typeName, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: typeValue, onChanged: (value){ function;}, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),),
        Text(typeName),
      ],
    );
  }
}