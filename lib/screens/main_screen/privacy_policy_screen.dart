import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';
import '../../utill/color_resources.dart';
import '../../utill/widget_size.dart';
import '../widget/safe_on_tap.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatefulWidget {
String content;


PrivacyPolicyScreen(this.content);

@override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.whiteSmoke,
        appBar: buildAppBar(context),
    body: SingleChildScrollView(
        child: Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: Html(shrinkWrap: false,
            data: widget.content,),
          ),
        )),);
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
                  "سياسة الخصوصية",
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
