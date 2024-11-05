import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/shared_nav_bar_provider.dart';
import 'package:jocards/screens/main_screen/categories_screen.dart';
import 'package:jocards/screens/main_screen/profile_screen.dart';
import 'package:jocards/screens/main_screen/wallet_screen.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedNavBarProvider>(
        builder: (context, sharedNavBarProvider, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: transparentStatusBarAndTransparentSystemBar,
        child: Scaffold(
          extendBody: true,
          /* 3 */
          body: PageView(
            controller: sharedNavBarProvider.controller,
            physics: context.read<AppProvider>().getUserInfo() != null
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: children,
            onPageChanged: (int index) {
              sharedNavBarProvider.changeBottomIndex(index);
              sharedNavBarProvider.changeControllerIndex(index);
              if (index != 0) {
                context.read<HomeProvider>().homsResponse = null;
              }
            },
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    children = [
      const HomeScreen(),
      const CategoriesScreen(),
      const WalletScreen(),
      //FavoriteScreen(),
      const ProfileScreen()
    ];
  }
}
