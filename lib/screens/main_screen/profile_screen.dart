import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/screens/main_screen/batch_history_screen.dart';
import 'package:jocards/screens/main_screen/print_screen.dart';
import 'package:jocards/screens/main_screen/privacy_policy_screen.dart';
import 'package:jocards/screens/main_screen/purchase_order_history.dart';
import 'package:jocards/screens/main_screen/shipping_order_history.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../model/direct_order_response.dart';
import '../../model/login_response_model.dart';
import '../../provider/app_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/widget_size.dart';
import '../auth/sign_in_screen.dart';
import '../widget/safe_on_tap.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorResources.whiteSmoke,
      body: Stack(children: [
        buildAppBar(context),
        Padding(
          padding: EdgeInsets.only(
              top: widgetSize.getHeight(120, context),
              right: widgetSize.getWidth(16, context),
              left: widgetSize.getWidth(16, context)),
          child: Container(decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: () => Future.sync(() {
                userModel= context.read<AppProvider>().getUserInfo();
                SchedulerBinding.instance.addPostFrameCallback((_) async {
                  context.read<AppProvider>().getAgentCustomers();
                });
              }),
              child: ListView(padding: EdgeInsets.zero,shrinkWrap: true,children: [
               Padding(
                 padding:  EdgeInsets.only(top: 10),
                 child: Container(     width:widgetSize.getWidth(120, context),
                        height: widgetSize.getWidth(120, context),

                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorResources.moonYellow,width:5),color: ColorResources.gainsboro),
                     child: Center(child: SvgPicture.asset(Assets.svgProfiless,))),
               ),

                Padding(
                  padding:  EdgeInsets.only(top:widgetSize.getHeight(5, context)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(userModel!=null&&userModel!.profileDetails!=null&&userModel!.profileDetails!.firstName!=null&&userModel!.profileDetails!.lastName!=null?
                    userModel!.profileDetails!.firstName!+" "+userModel!.profileDetails!.lastName!:'زائر',
                      style: TextStyle(

                        fontSize: widgetSize.getHeight(20, context),
                        color:const Color(0xff2e2e2e),
                        fontWeight: FontWeight.w700,
                      ),

                    ),
                  ),
                ),


                if(userModel!=null&&context.read<AppProvider>().utilitiesModel!=null&&context.read<AppProvider>().utilitiesModel!.data!=null&&
                    context.read<AppProvider>().utilitiesModel!.data!.companyName!=null)...[
                  Padding(
                    padding:  EdgeInsets.only(top:widgetSize.getHeight(5, context)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        context.read<AppProvider>().utilitiesModel!.data!.companyName!,
                        style: TextStyle(

                          fontSize: widgetSize.getHeight(16, context),
                          color:Color(0xffa2a2a2),

                        ),

                      ),
                    ),
                  ),],

                Padding(
                  padding:  EdgeInsets.only(top:widgetSize.getHeight(5, context)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(userModel!=null&&userModel!.profileDetails!=null&&userModel!.profileDetails!.mobileNo!=null?
                    userModel!.profileDetails!.mobileNo!:'',
                      style: TextStyle(

                        fontSize: widgetSize.getHeight(16, context),
                        color:Color(0xffa2a2a2),
                      ),

                    ),
                  ),
                ),

                if(userModel!=null)...[
                  SafeOnTap(onSafeTap: ()async{

                  },
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: widgetSize.getWidth(10, context),
                          runSpacing: widgetSize.getWidth(10, context),
                          children: [
                            SafeOnTap(onSafeTap: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const ShippingOrderHistory(shippingType: ShippingType.wallet),
                                ),
                              );
                            },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfffaf6ff),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    SizedBox(width: widgetSize.getWidth(10, context),),
                                    SvgPicture.asset(Assets.svgShippingPurple,width: 20,),
                                    SizedBox(width: widgetSize.getWidth(15, context),),
                                    Text(
                                      'طلبات الشحن',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(14, context),
                                        color: const Color(0xff7d5ba6),
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(width: widgetSize.getWidth(40, context),),


                                  ],),
                                ),
                              ),
                            ),
                            SafeOnTap(onSafeTap: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: PurchaseOrderHistory(),
                                ),
                              );
                            },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfffaf6ff),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    SizedBox(width: widgetSize.getWidth(10, context),),

                                    SvgPicture.asset(Assets.svgPurchasePurple,width: 20,),
                                    SizedBox(width: widgetSize.getWidth(15, context),),

                                    Text(
                                      'طلبات الشراء',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(14, context),
                                        color: const Color(0xff7d5ba6),
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(width: widgetSize.getWidth(18, context),),


                                  ],),
                                ),
                              ),
                            ),
                            if(context.watch<AppProvider>().agentModel?.data != null &&  context.watch<AppProvider>().agentModel!.data!.isNotEmpty)
                            SafeOnTap(onSafeTap: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const ShippingOrderHistory(shippingType: ShippingType.customers,),
                                ),
                              );
                            },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfffaf6ff),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    SizedBox(width: widgetSize.getWidth(10, context),),
                                    SvgPicture.asset(Assets.svgShippingPurple,width: 20,),
                                    SizedBox(width: widgetSize.getWidth(15, context),),
                                    Text(
                                      'طلبات شحن العملاء',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(14, context),
                                        color: const Color(0xff7d5ba6),
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(width: widgetSize.getWidth(10, context),),


                                  ],),
                                ),
                              ),
                            ),

                            if(context.watch<AppProvider>().agentModel?.data != null &&  context.watch<AppProvider>().agentModel!.data!.isNotEmpty)
                            SafeOnTap(onSafeTap: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const BatchHistoryScreen(),
                                ),
                              );
                            },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfffaf6ff),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: widgetSize.getWidth(10, context),),
                                      SvgPicture.asset(Assets.svgShippingPurple,width: 20,),
                                      SizedBox(width: widgetSize.getWidth(15, context),),
                                      Text(
                                        'سجل الدفعات',
                                        style: TextStyle(
                                          fontFamily: 'DIN Next LT W23',
                                          fontSize: widgetSize.getHeight(14, context),
                                          color: const Color(0xff7d5ba6),
                                        ),
                                        softWrap: false,
                                      ),
                                      SizedBox(width: widgetSize.getWidth(10, context),),


                                    ],),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widgetSize.getHeight(30, context),)

                ],


                  Visibility(
                    visible: Platform.isAndroid,
                    child: SafeOnTap(onSafeTap: ()async{
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: PrintScreen(DirectOrderResponse()),
                        ),
                      );
                    },
                      child: Padding(
                        padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                        child: Column(
                          children: [
                            Row(children: [
                              SvgPicture.asset(Assets.svgPrinter),
                              SizedBox(width: widgetSize.getWidth(10, context),),
                              Text(
                                "إعدادات الطابعة",
                                style: TextStyle(

                                  fontSize: widgetSize.getHeight(16, context),
                                  color: const  Color(0xff6b6b6b),
                                  fontWeight: FontWeight.w500,
                                ),

                              ),

                              Spacer(),
                              RotatedBox(
                                  quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18))
                            ],),
                            SizedBox(height: widgetSize.getHeight(10, context),),
                            Container(height: 1,
                              color: ColorResources.light_grey.withOpacity(0.5),)
                          ],
                        ),
                      ),
                    ),
                  ),

                if(userModel!=null&& context.read<AppProvider>().utilitiesModel!=null&&
                    context.read<AppProvider>().utilitiesModel!.data!=null&&context.read<AppProvider>().utilitiesModel!.data!
                    .companyWhatsappNumber!=null)...[
                  SafeOnTap(onSafeTap: ()async{
                    String link;
                    final phoneNumber = context.read<AppProvider>().utilitiesModel!.data!.companyWhatsappNumber!;
                    const text = 'مرحبا، هل يمكنني التحدث الى شخص ما؟';
                    if(Platform.isAndroid){
                      link = 'https://wa.me/$phoneNumber?text=$text';
                    }
                    else{
                      link = 'https://wa.me/$phoneNumber/?text=$text';
                    }
                    await launchUrl(Uri.parse(link), mode: LaunchMode.externalNonBrowserApplication);

                  },
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Column(
                        children: [
                          Row(children: [
                            SvgPicture.asset(Assets.svgWhatIcon),
                            SizedBox(width: widgetSize.getWidth(10, context),),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 "تواصل واتس",
                                  style: TextStyle(

                                    fontSize: widgetSize.getHeight(16, context),
                                    color: const  Color(0xff6b6b6b),
                                    fontWeight: FontWeight.w500,
                                  ),

                                ),

                              ],
                            ),
                            Spacer(),
                            RotatedBox(
                                quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18))

                          ],),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Container(height: 1,
                            color: ColorResources.light_grey.withOpacity(0.5),)
                        ],
                      ),
                    ),
                  ),
                ],
                if(userModel!=null&& context.read<AppProvider>().utilitiesModel!=null&&
                    context.read<AppProvider>().utilitiesModel!.data!=null&&context.read<AppProvider>().utilitiesModel!.data!
                    .callUs!=null)...[
                  SafeOnTap(onSafeTap: ()async{
                    final Uri phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: context.read<AppProvider>().utilitiesModel!.data!
                          .callUs,
                    );
                    launchUrl(phoneLaunchUri);
                  },
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Column(
                        children: [
                          Row(children: [
                            Image.asset(Assets.imgTelephone, width: 20, height: 20),
                            SizedBox(width: widgetSize.getWidth(10, context),),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "اتصل بنا",
                                  style: TextStyle(

                                    fontSize: widgetSize.getHeight(16, context),
                                    color: const  Color(0xff6b6b6b),
                                    fontWeight: FontWeight.w500,
                                  ),

                                ),

                              ],
                            ),
                            Spacer(),
                            RotatedBox(
                                quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18))

                          ],),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Container(height: 1,
                            color: ColorResources.light_grey.withOpacity(0.5),)
                        ],
                      ),
                    ),
                  ),
                ],
    if(userModel!=null&& context.read<AppProvider>().utilitiesModel!=null&&
    context.read<AppProvider>().utilitiesModel!.data!=null&&context.read<AppProvider>().utilitiesModel!.data!
        .privacyPolicy!=null)...[
                SafeOnTap(
                  onSafeTap: ()async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child:
                                PrivacyPolicyScreen(context.read<AppProvider>().utilitiesModel!.data!.privacyPolicy!)));

                  },
                  child: Padding(
                    padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                    child: Column(
                      children: [
                        Row(children: [
                          SvgPicture.asset(Assets.svgPolicy),
                          SizedBox(width: widgetSize.getWidth(10, context),),
                          Text(
                         "سياسة الخصوصية",
                            style: TextStyle(

                              fontSize: widgetSize.getHeight(16, context),
                              color: const  Color(0xff6b6b6b),
                              fontWeight: FontWeight.w500,
                            ),

                          ),
                          Spacer(),
                          RotatedBox(
                              quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18))
                        ],),
                        SizedBox(height: widgetSize.getHeight(10, context),),
                        Container(height: 1,
                          color: ColorResources.light_grey.withOpacity(0.5),)

                      ],
                    ),
                  ),
                ),
],

                if(userModel!=null)...[
                  SafeOnTap(onSafeTap: () => _showDeleteConfirmationDialog(context),
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Column(
                        children: [
                          Row(children: [
                            const Icon(Icons.person_remove_alt_1_outlined),
                            SizedBox(width: widgetSize.getWidth(10, context),),
                            Text(
                              "حذف الحساب",
                              style: TextStyle(

                                fontSize: widgetSize.getHeight(16, context),
                                color: const  Color(0xff6b6b6b),
                                fontWeight: FontWeight.w500,
                              ),

                            ),

                            Spacer(),
                            const RotatedBox(
                                quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18,))
                          ],),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Container(height: 1,
                            color: ColorResources.light_grey.withOpacity(0.5),)
                        ],
                      ),
                    ),
                  ),
                  SafeOnTap(onSafeTap: _signOut,
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Column(
                        children: [
                          Row(children: [
                            SvgPicture.asset(Assets.svgSignOut),
                            SizedBox(width: widgetSize.getWidth(10, context),),
                            Text(
                              "تسجيل الخروج",
                              style: TextStyle(

                                fontSize: widgetSize.getHeight(16, context),
                                color: const  Color(0xff6b6b6b),
                                fontWeight: FontWeight.w500,
                              ),

                            ),

                            Spacer(),
                            RotatedBox(
                                quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18,))
                          ],),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Container(height: 1,
                            color: ColorResources.light_grey.withOpacity(0.5),)
                        ],
                      ),
                    ),
                  ),
                ],
                if(userModel==null)...[
                  SafeOnTap(onSafeTap: ()async{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignInScreen(fromSetting: true,)));
                  },
                    child: Padding(
                      padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      child: Column(
                        children: [
                          Row(children: [
                            SvgPicture.asset(Assets.svgSignOut),
                            SizedBox(width: widgetSize.getWidth(10, context),),
                            Text(
                              "تسجيل الدخول",
                              style: TextStyle(

                                fontSize: widgetSize.getHeight(16, context),
                                color: const  Color(0xff6b6b6b),
                                fontWeight: FontWeight.w500,
                              ),

                            ),

                            Spacer(),
                            RotatedBox(
                                quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18,))
                          ],),
                          SizedBox(height: widgetSize.getHeight(10, context),),
                          Container(height: 1,
                            color: ColorResources.light_grey.withOpacity(0.5),)
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: widgetSize.getHeight(40, context),),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment: Alignment.center,
                    child: Text(
                      "  الإصدار "+ packageInfo.version,
                      style: TextStyle(

                        fontSize: widgetSize.getHeight(14, context),
                        color: const Color(0xffc5c5c5),
                        fontWeight: FontWeight.w500,
                      ),

                    ),
                  ),
                ),

                SizedBox(height: widgetSize.getHeight(90, context),),

              ],),
            ),
          ),),
        )
      ],),
    );
  }

  Future<void> _signOut() async {
    await Provider.of<AppProvider>(context,listen:false).setSignOutUser();

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        SignInScreen(fromSetting: false,)), (Route<dynamic> route) => false);
  }

  void _showDeleteConfirmationDialog(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: _signOut, child: const Text('نعم', style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.studio))),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('لا', style: TextStyle(color: ColorResources.studio, fontWeight: FontWeight.bold)))
        ],
      );
    });
  }

   buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widgetSize.getHeight(200, context),
      decoration: BoxDecoration(
          color: ColorResources.studio,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'الملف الشخصي',
            style: TextStyle(
              fontFamily: 'DIN Next LT W23',
              fontSize: widgetSize.getHeight(17, context),
              color: const Color(0xffffffff),
            ),
            softWrap: false,
          ),
        ],
      ),
    );
  }

  LoginResponseModel? userModel;
  @override
  void initState() {
    userModel= context.read<AppProvider>().getUserInfo();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.read<AppProvider>().getAgentCustomers();
    });
    super.initState();
  }
}
