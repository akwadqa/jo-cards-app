import 'package:flutter/material.dart';

import '../../../../utill/widget_size.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPressed, required this.title, this.backgroundColor, this.foregroundColor}) : super(key: key);
  final VoidCallback? onPressed;
  final String title;
  final MaterialStateProperty<Color?>? backgroundColor;
  final MaterialStateProperty<Color?>? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          minimumSize: MaterialStateProperty.all(Size(widgetSize.getWidth(150, context), widgetSize.getHeight(50, context))),
        ),
        child: Text(title));
  }
}
