import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/src/provider.dart';
import 'dart:math' as math;
class SignUpHeaderWidget extends StatelessWidget
{



 @override
  Widget build(BuildContext context) {
    return Container(height: MediaQuery.of(context).size.width*0.448,
      width:MediaQuery.of(context).size.width ,

      child: Stack(  children: [


        Positioned.fill(child:
            SvgPicture.asset(Assets.svgRegisterHeader,)

        ),



        Align(alignment: Alignment.centerRight,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context)),
            child: SafeOnTap(
              onSafeTap: () { Navigator.pop(context); },
              child:  SvgPicture.asset(Assets.svgBack,width: widgetSize.getWidth(35, context),height: widgetSize.getWidth(35, context),)),
            ),
          ),

      ],),);
  }
}