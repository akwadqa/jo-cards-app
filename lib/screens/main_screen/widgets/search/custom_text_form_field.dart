import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({Key? key, this.hintText, this.keyboardType, this.onSaved, this.readOnly = false, this.onTap}) : super(key: key);

  final String? hintText;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 13),
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
