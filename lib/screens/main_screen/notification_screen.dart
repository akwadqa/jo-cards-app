import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),

    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeOnTap(
                    onSafeTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(Assets.svgBack)),
                Spacer(),
                Text(
                  "الإشعارات",
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
