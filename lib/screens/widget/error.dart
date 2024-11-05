import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';

class Error extends StatelessWidget {
  final String? errorMsg;

  const Error({super.key, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
            onTap: () async {},
            child: RichText(
                text: TextSpan(
              text: errorMsg,
              style: TextStyle(
                  color: ColorResources.studio,
                  fontSize: widgetSize.getHeight(16, context)),
              children: const <TextSpan>[
                TextSpan(
                    text: "",
                    style: TextStyle(
                      color: ColorResources.studio,
                    )),
              ],
            ))));
  }
}
