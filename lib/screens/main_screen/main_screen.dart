import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/provider/shared_nav_bar_provider.dart';
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

  late List<Widget> children;

  @override
  Widget build(BuildContext context) {

    return Consumer<SharedNavBarProvider>(
        builder: (context, sharedNavBarProvider, child){
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: transparentStatusBarAndTransparentSystemBar,
        child: Scaffold(
          extendBody: true,
          /* 3 */
          body: PageView(
            controller: sharedNavBarProvider.controller,
            children: children,
            onPageChanged: (int index){
              sharedNavBarProvider.changeBottomIndex(index);
              sharedNavBarProvider.changeControllerIndex(index);
            if (index != 0) {
              context.read<HomeProvider>().homsResponse = null;
            }},
          ),
        ),
      );}
    );
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

}
