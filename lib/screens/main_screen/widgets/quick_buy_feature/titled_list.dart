import 'package:flutter/material.dart';

import '../../../../utill/widget_size.dart';

class TitledList extends StatelessWidget {
  const TitledList({Key? key, required this.child, required this.title, this.height = 40}) : super(key: key);
  final String title;
  final Widget child;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: widgetSize.getHeight(10, context)),
          SizedBox(
            height: widgetSize.getHeight(height, context),
            child: child,
          )
        ],
    );
  }
}
