import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/main_screen/item_per_categories.dart';
import 'package:jocards/screens/main_screen/product_details.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:page_transition/page_transition.dart';

import '../../model/app_message_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final MessageData messageData;
  const NotificationDetailsScreen({super.key, required this.messageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFA2C0DB),
      body: Stack(
        fit: StackFit.expand,

        /// crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //SizedBox(height: widgetSize.targetHeightSize*0.09),
          Positioned(
              top: widgetSize.targetHeightSize * 0.09,
              left: 0.0,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: messageData.appMessageIcon != null
                      ? Image.network(messageData.appMessageIcon!,
                          fit: BoxFit.fill)
                      : Image.asset("assets/img/notification image.png",
                          fit: BoxFit.fill))),
          Positioned(
            bottom: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              height: widgetSize.targetHeightSize / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(messageData.appMessageTitle!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        buildTextWithURL(
                            text: messageData.content!,
                            defaultTextStyle: const TextStyle(
                                fontSize: 16, color: Colors.black87)),
                      ],
                    ),
                    SafeOnTap(
                      onSafeTap: () {
                        messageData.type == "Item Group"
                            ? Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SharedBottomNavigationBar(
                                    widget: ItemPerCategories(
                                        messageData.itemGroup != null
                                            ? messageData.itemGroup!
                                            : "",
                                        ""),
                                  ),
                                ),
                              )
                            : messageData.type == "Item"
                                ? Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: ProductDetailsScreen(
                                            "", messageData.item!)),
                                  )
                                : null;
                      },
                      child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: ColorResources.lightBlue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child: Text(
                              'معرفة المزيد',
                              style: TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: 16,
                                color: Color(0xffffffff),
                              ),
                              softWrap: false,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SafeOnTap(
                    onSafeTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(Assets.svgBack)),
              ],
            ),
          ),
        ));
  }
}
