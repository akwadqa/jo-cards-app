import 'package:flutter/material.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

class MyWallet extends StatelessWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widgetSize.getHeight(90, context), // Border width
        decoration: BoxDecoration( borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(Assets.imgWalletHh, fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric( horizontal: widgetSize.getHeight(20, context)),
                child: Column( mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  SizedBox(height:widgetSize.getHeight(15, context)),
                  Text(
                    'رصيد محفظتك',
                    style: TextStyle(
                      fontFamily: 'DIN Next LT W23',
                      fontSize: widgetSize.getHeight(18, context),
                      color: const Color(0xbdffffff),
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: false,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text(
                      context.watch<AppProvider>().utilitiesModel!=null?
                      context.watch<AppProvider>().utilitiesModel!.data!=null?
                      context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!=null?
                      context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!:"":"":""
                      ,
                      style: const TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: 44,
                        color:  Color(0xffffffff),
                        fontWeight: FontWeight.w400,
                      ),
                      softWrap: false,
                    ),
                    SizedBox(width: widgetSize.getWidth(5, context),),
                    const Text(
                      "دينار",
                      style: TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: 22,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w100,
                      ),
                      softWrap: false,
                    ),
                    // SizedBox(width: widgetSize.getWidth(35, context),),
                    // SvgPicture.asset(Assets.svgWallet,height: widgetSize.getWidth(45, context),width: widgetSize.getWidth(45, context),color: Colors.white,),

                    // Expanded(
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Padding(
                    //       padding:  EdgeInsets.symmetric(horizontal: 2),
                    //       child: Text(
                    //         context.watch<AppProvider>().utilitiesModel!=null?
                    //         context.watch<AppProvider>().utilitiesModel!.data!=null?
                    //         context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!=null?
                    //         context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!:"":"":""
                    //         ,
                    //         style: TextStyle(
                    //           fontFamily: 'DIN Next LT W23',
                    //           fontSize: 44,
                    //           color: const Color(0xffffffff),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         softWrap: false,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],),
                ],),
              ),
            )
          ],
        ));
  }
}
