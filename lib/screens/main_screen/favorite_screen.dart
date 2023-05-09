import 'package:flutter/material.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/widgets/wallet/my_wallet.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteSmoke,appBar: buildAppBar(context),

      body: RefreshIndicator(
        onRefresh: () async{
          context.read<AppProvider>().getUtilities();
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: widgetSize.getWidth(15, context)),
          children: [
            Padding(
              padding: EdgeInsets.only(top: widgetSize.getHeight(20, context)),
              child: const MyWallet(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Center(child: Text(
              'المفضلة',
              style: TextStyle(
                fontFamily: 'DIN Next LT W23',
                fontSize: widgetSize.getHeight(18, context),
                color: const Color(0xffffffff),
              ),
              softWrap: false,
            ),),
          ),
        ));
  }

}
