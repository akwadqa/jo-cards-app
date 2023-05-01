import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/main_screen/categories_screen.dart';
import 'package:jocards/screens/main_screen/favorite_screen.dart';
import 'package:jocards/screens/main_screen/profile_screen.dart';
import 'package:jocards/screens/main_screen/wallet_screen.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: transparentStatusBarAndTransparentSystemBar,
        child: Scaffold(
          extendBody: true,
          // body: PersistentTabView(
          //     context,
          //
          //     // onWillPop: (final BuildContext? context1) async {
          //     //   await showDialog(
          //     //     context: context1!,
          //     //     useSafeArea: true,
          //     //     builder: (final context) => Container(
          //     //       height: 50,
          //     //       width: 50,
          //     //       color: Colors.white,
          //     //       child: ElevatedButton(
          //     //         child: const Text("Close"),
          //     //         onPressed: () {
          //     //           Navigator.pop(context);
          //     //         },
          //     //       ),
          //     //     ),
          //     //   );
          //     //   return false;
          //     // },
          //
          //     // onWillPop: (context) async {
          //     //   if (_currentIndex != 0) {
          //     //     setState(() {
          //     //     _currentIndex = 0;
          //     //   });}
          //     //   else {
          //     //     exit(0);
          //     //   }
          //     //     return true;
          //     //   },
          //     // handleAndroidBackButtonPress: false,
          //
          //     navBarHeight: widgetSize.getHeight(70, context),
          //     controller: _controller,
          //     screens: children,
          //     items: _navBarsItems(),
          //     confineInSafeArea: true,
          //     resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          //     hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          //     padding:  const NavBarPadding.all(0),
          //     decoration: NavBarDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     colorBehindNavBar: Colors.white,
          //   ),
          //     popAllScreensOnTapOfSelectedTab: true,
          //   popAllScreensOnTapAnyTabs: true,
          //     popActionScreens: PopActionScreensType.once,
          //     itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          //     duration: Duration(milliseconds: 200),
          //     curve: Curves.ease,
          //   ),
          //     screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          //     animateTabTransition: false,
          //     curve: Curves.ease,
          //     duration: Duration(milliseconds: 200),
          //   ),
          //     navBarStyle: NavBarStyle.style6,
          // ),
          body: Stack(children: <Widget>[
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings){
                return MaterialPageRoute(builder: (context) => children[_currentIndex]);
              },
            ),
          ],),
          bottomNavigationBar: buildBottomAppBar(context),
        ),
      ),
    );
  }

  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgHome, color: ColorResources.studio),
  //       ),
  //       inactiveIcon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgHome, color: ColorResources.dimGray),
  //       ),
  //       title: "الرئيسية",
  //       textStyle: TextStyle(
  //         fontSize: widgetSize.getHeight(13, context),
  //         color: _currentIndex != 1
  //             ? ColorResources.dimGray
  //             : ColorResources.studio,
  //       ),
  //       activeColorPrimary: ColorResources.studio,
  //       inactiveColorPrimary: ColorResources.dimGray,
  //       onSelectedTabPressWhenNoScreensPushed: (){
  //         if (_currentIndex != 0) {
  //           onTabTapped(0);
  //         }
  //       }
  //     ),
  //
  //     PersistentBottomNavBarItem(
  //       icon :Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgCategory, color: ColorResources.studio),
  //       ),
  //       inactiveIcon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgCategory, color: ColorResources.dimGray),
  //       ),
  //       title: "الفئات",
  //       textStyle: TextStyle(
  //         fontSize: widgetSize.getHeight(13, context),
  //         color: _currentIndex != 1
  //           ? ColorResources.dimGray
  //           : ColorResources.studio,
  //         ),
  //       activeColorPrimary: ColorResources.studio,
  //       inactiveColorPrimary: ColorResources.dimGray,
  //         onSelectedTabPressWhenNoScreensPushed: (){
  //           if (_currentIndex != 1) {
  //             onTabTapped(1);
  //           }
  //         }
  //     ),
  //
  //     PersistentBottomNavBarItem(
  //       onSelectedTabPressWhenNoScreensPushed: (){
  //         if (_currentIndex != 2) {
  //           if (context.read<AppProvider>().getUserInfo() != null) {
  //             onTabTapped(2);
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
  //       icon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgWallet, color: ColorResources.studio),
  //       ),
  //       inactiveIcon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgWallet, color:  ColorResources.dimGray),
  //       ),
  //       title: "محفظتي",
  //       textStyle: TextStyle(
  //         fontSize: widgetSize.getHeight(13, context),
  //         color: _currentIndex != 2
  //             ? ColorResources.dimGray
  //             : ColorResources.studio,
  //       ),
  //       activeColorPrimary: ColorResources.studio,
  //       inactiveColorPrimary: ColorResources.dimGray,
  //     ),
  //
  //     PersistentBottomNavBarItem(
  //       icon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgWallet, color: ColorResources.studio),
  //       ),
  //       inactiveIcon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgWallet, color: ColorResources.dimGray),
  //       ),
  //       title: "المفضلة",
  //       textStyle: TextStyle(
  //         fontSize: widgetSize.getHeight(13, context),
  //         color: _currentIndex != 3
  //             ? ColorResources.dimGray
  //             : ColorResources.studio,
  //       ),
  //       activeColorPrimary: ColorResources.studio,
  //       inactiveColorPrimary: ColorResources.dimGray,
  //         onSelectedTabPressWhenNoScreensPushed: (){
  //         if (_currentIndex != 3) {
  //           onTabTapped(3);
  //         }
  //       }
  //     ),
  //
  //     PersistentBottomNavBarItem(
  //       icon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgProfile, color: ColorResources.studio),
  //       ),
  //       inactiveIcon: Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: SvgPicture.asset(Assets.svgProfile, color: ColorResources.dimGray),
  //       ),
  //       onSelectedTabPressWhenNoScreensPushed: () {
  //         if (_currentIndex != 4) {
  //           onTabTapped(4);
  //         }
  //       },
  //       title: "الحساب",
  //       textStyle: TextStyle(
  //         fontSize: widgetSize.getHeight(13, context),
  //         color: _currentIndex != 4
  //             ? ColorResources.dimGray
  //             : ColorResources.studio,
  //       ),
  //       activeColorPrimary: ColorResources.studio,
  //       inactiveColorPrimary: ColorResources.dimGray,
  //     ),
  //   ];
  // }

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
                          if (context.read<AppProvider>().getUserInfo() !=
                              null) {
                            onTabTapped(3);
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
                              color: _currentIndex != 3
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'المفضلة',
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
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        if (_currentIndex != 4) {
                          onTabTapped(4);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgProfile,
                              color: _currentIndex != 4
                                  ? ColorResources.dimGray
                                  : ColorResources.studio),
                          SizedBox(
                            height: widgetSize.getHeight(10, context),
                          ),
                          Text(
                            'الحساب',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(13, context),
                              color: _currentIndex != 4
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
      FavoriteScreen(),
      ProfileScreen()
    ];
  }

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _controller.index = index;
    });
    if (index != 0) {
      context.read<HomeProvider>().homsResponse = null;
    }
  }

  Future<bool> _onWillPop() async {
    print(_navigatorKey.currentWidget);
    if (_currentIndex != 0 && _navigatorKey.currentWidget!= HomeScreen()) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      exit(0);
    }
    return true;
  }
}
