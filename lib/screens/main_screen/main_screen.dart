import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/main_screen/categories_screen.dart';
import 'package:jocards/screens/main_screen/profile_screen.dart';
import 'package:jocards/screens/main_screen/wallet_screen.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';
import '../../provider/home_provider.dart';
import '../auth/sign_in_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: transparentStatusBarAndTransparentSystemBar,
        child: Scaffold(
          extendBody: true,
          body: children[_currentIndex],
          bottomNavigationBar: buildBottomAppBar(context),
        ),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: widgetSize.getHeight(70.0, context),
            child: Row(
              children: [
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        if (_currentIndex != 0) {
                          onTabTapped(0);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgHome,
                              color: _currentIndex != 0
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'الرئيسية',
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: widgetSize.getHeight(13, context),
                              color: _currentIndex != 0
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
                        if (_currentIndex != 1) {
                          onTabTapped(1);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgCategory,
                              color: _currentIndex != 1
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'الفئات',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: _currentIndex != 1
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
                        if (_currentIndex != 2) {
                          if (context.read<AppProvider>().getUserInfo() !=
                              null) {
                            onTabTapped(2);
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
                              color: _currentIndex != 2
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'محفظتي',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: _currentIndex != 2
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
                        if (_currentIndex != 3) {
                          onTabTapped(3);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgProfile,
                              color: _currentIndex != 3
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'الحساب',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: _currentIndex != 3
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

  @override
  void initState() {
    children = [
      HomeScreen(),
      CategoriesScreen(),
      WalletScreen(),
      ProfileScreen()
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index != 0) {
      context.read<HomeProvider>().homsResponse = null;
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      exit(0);
    }
    return true;
  }
}
