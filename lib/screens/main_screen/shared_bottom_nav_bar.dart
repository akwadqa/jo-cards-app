import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/provider/shared_nav_bar_provider.dart';
import 'package:jocards/screens/auth/sign_in_screen.dart';
import 'package:jocards/screens/main_screen/home_screen.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

import '../../model/login_response_model.dart';

class SharedBottomNavigationBar extends StatefulWidget {
  final Widget widget;
  const SharedBottomNavigationBar({Key? key, required this.widget}) : super(key: key);

  @override
  State<SharedBottomNavigationBar> createState() => _SharedBottomNavigationBarState();
}

class _SharedBottomNavigationBarState extends State<SharedBottomNavigationBar> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedNavBarProvider>(
        builder: (context, sharedNavBarProvider, child){
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: widget.widget,
              bottomNavigationBar: buildBottomAppBar(context),
            ),
      );}
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SizedBox(
            height: widgetSize.getHeight(70.0, context),
            child: Row(
              children: [
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        if (context.read<SharedNavBarProvider>().bottomIndex != 0) {
                          ModalRoute.of(context)!.isFirst ? onTabTapped(0) : onTabTappedInNestedScreens(0);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgHome,
                              color: context.read<SharedNavBarProvider>().bottomIndex != 0
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(height: widgetSize.getHeight(10, context)),
                          Text(
                            'الرئيسية',
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: widgetSize.getHeight(12, context),
                              color: context.read<SharedNavBarProvider>().bottomIndex != 0
                                  ? ColorResources.dimGray
                                  : ColorResources.studio,
                            ),
                          )
                        ],
                      )),
                ),
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        if (context.read<SharedNavBarProvider>().bottomIndex != 1) {
                          ModalRoute.of(context)!.isFirst ? onTabTapped(1) : onTabTappedInNestedScreens(1);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgCategory,
                              color: context.read<SharedNavBarProvider>().bottomIndex != 1
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Text(
                            'الفئات',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: context.read<SharedNavBarProvider>().bottomIndex != 1
                                  ? ColorResources.dimGray
                                  : ColorResources.studio,
                            ),
                          )
                        ],
                      )),
                ),
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () async {
                        if (context.read<SharedNavBarProvider>().bottomIndex != 2) {
                          LoginResponseModel? loginResponseModel = context.read<AppProvider>().getUserInfo();
                          if (loginResponseModel != null) {
                            ModalRoute.of(context)!.isFirst ? onTabTapped(2): onTabTappedInNestedScreens(2);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen(
                                      fromSetting: true,
                                    )));
                          }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgWallet,
                              color: context.read<SharedNavBarProvider>().bottomIndex != 2
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(height: widgetSize.getHeight(10, context)),
                          Text(
                            'محفظتي',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: context.read<SharedNavBarProvider>().bottomIndex != 2
                                  ? ColorResources.dimGray
                                  : ColorResources.studio,
                            ),
                          )
                        ],
                      )),
                ),
                // Expanded(
                //   child: SafeOnTap(
                //       onSafeTap: () {
                //         if (context.read<SharedNavBarProvider>().bottomIndex != 3) {
                //           if (context.read<AppProvider>().getUserInfo() != null) {
                //             ModalRoute.of(context)!.isFirst ? onTabTapped(3) : onTabTappedInNestedScreens(3);
                //           } else {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => SignInScreen(
                //                       fromSetting: true,
                //                     )));
                //           }
                //         }
                //       },
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(Assets.svgHeart,
                //               color: context.read<SharedNavBarProvider>().bottomIndex != 3
                //                   ? ColorResources.dimGray
                //                   : ColorResources.studio),
                //           SizedBox(height: widgetSize.getHeight(10, context)),
                //           Text(
                //             'المفضلة',
                //             style: TextStyle(
                //               fontSize: widgetSize.getHeight(13, context),
                //               color: context.read<SharedNavBarProvider>().bottomIndex != 3
                //                   ? ColorResources.dimGray
                //                   : ColorResources.studio,
                //             ),
                //           )
                //         ],
                //       )),
                // ),
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        if (context.read<SharedNavBarProvider>().bottomIndex != 3) {
                          ModalRoute.of(context)!.isFirst ? onTabTapped(3) : onTabTappedInNestedScreens(3);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgProfile,
                              color: context.read<SharedNavBarProvider>().bottomIndex != 3
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(height: widgetSize.getHeight(10, context)),
                          Text(
                            'الحساب',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: context.read<SharedNavBarProvider>().bottomIndex != 3
                                  ? ColorResources.dimGray
                                  : ColorResources.studio,
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  onTabTapped(int index) {
      context.read<SharedNavBarProvider>().changeBottomIndex(index);
      context.read<SharedNavBarProvider>().controller.animateToPage(context.read<SharedNavBarProvider>().bottomIndex, duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
      context.read<SharedNavBarProvider>().changeControllerIndex(index);
    if (index != 0) {
      context.read<HomeProvider>().homsResponse = null;
    }
  }

  onTabTappedInNestedScreens(int index) {
    context.read<SharedNavBarProvider>().changeBottomIndex(index);
    context.read<SharedNavBarProvider>().controller.animateToPage(context.read<SharedNavBarProvider>().bottomIndex, duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
    context.read<SharedNavBarProvider>().changeControllerIndex(index);

    Navigator.popUntil(context, (route) {
      return route.isFirst;
    });

    if (index != 0) {
      context.read<HomeProvider>().homsResponse = null;
    }
  }

  Future<bool> _onWillPop() async {

    if(!ModalRoute.of(context)!.isFirst){
      context.read<SharedNavBarProvider>().changeBottomIndex(context.read<SharedNavBarProvider>().bottomIndex);
      context.read<SharedNavBarProvider>().changeControllerIndex(context.read<SharedNavBarProvider>().bottomIndex);
      return true;
    }
    else if (context.read<SharedNavBarProvider>().bottomIndex != 0 && _navigatorKey.currentWidget!= const HomeScreen()) {
        context.read<SharedNavBarProvider>().changeBottomIndex(0);
        context.read<SharedNavBarProvider>().controller.animateToPage(0, duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
        context.read<SharedNavBarProvider>().changeControllerIndex(0);
        return false;
    } else {
      exit(0);
    }
  }
}

