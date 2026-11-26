import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jocards/model/direct_wallet_request_log_model.dart';
import 'package:jocards/model/update_profile_model.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/batch_history_screen.dart';
import 'package:jocards/screens/main_screen/edit_profile_screen.dart';
import 'package:jocards/screens/main_screen/notification_screen.dart';
import 'package:jocards/screens/main_screen/print_screen.dart';
import 'package:jocards/screens/main_screen/privacy_policy_screen.dart';
import 'package:jocards/screens/main_screen/purchase_order_history.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/main_screen/shipping_order_history.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Network/api_response.dart';
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
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? image = XFile("");
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteSmoke,
      body: Stack(
        children: [
          buildAppBar(context),
          Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(120, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(() {
                    setState(() {
                      userModel = context.read<AppProvider>().getUserInfo();
                    });
                    SchedulerBinding.instance.addPostFrameCallback((_) async {
                      context.read<AppProvider>().getAgentCustomers();
                      context.read<AppProvider>().getUtilities();
                      context.read<AppProvider>().getUserInfo();
                    });
                  }),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: Stack(
                      //     children:[
                      //       Center(child: Image.asset(Assets.profileBorder)),
                      //       Center(
                      //         // top: widgetSize.getHeight(18, context),
                      //         // right: widgetSize.getWidth(16, context),
                      //         child: Stack(
                      //           children: [
                      //            ( image!.path == "" || image == null)
                      //                 ? Container(
                      //
                      //                 width:widgetSize.getWidth(90, context),
                      //                  height: widgetSize.getWidth(90, context),
                      //
                      //                  decoration: const BoxDecoration(
                      //                      shape: BoxShape.circle,
                      //                      color: ColorResources.gainsboro
                      //                  ),
                      //               child: Center(child: SvgPicture.asset(Assets.svgProfiless,)))
                      //                 : Container(
                      //
                      //                   width:widgetSize.getWidth(90, context),
                      //                   height: widgetSize.getWidth(90, context),
                      //
                      //                 decoration: const BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: ColorResources.gainsboro
                      //                 ),
                      //                 child: ClipRRect(
                      //                    borderRadius: BorderRadius.circular(50),
                      //                     child: Image.file(File(image!.path), fit: BoxFit.fill,))),
                      //             Positioned(
                      //                bottom: 0,
                      //                 child: GestureDetector(
                      //                   onTap: () {
                      //                     setState(()  {
                      //                       changeImage();
                      //                     });
                      //                   },
                      //                   child: Container(
                      //                     decoration: const BoxDecoration(
                      //                         shape: BoxShape.circle,
                      //                         color: Colors.white
                      //                     ),
                      //                     padding: const EdgeInsets.all(5),
                      //                     child: Container(
                      //                       padding: const EdgeInsets.all(3),
                      //                       decoration: const BoxDecoration(
                      //                           shape: BoxShape.circle,
                      //                           color: ColorResources.studio
                      //                       ),
                      //                       child: Icon(Icons.settings, color: Colors.white,),
                      //                     ),
                      //                   ),
                      //                 )
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //   ]),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(Assets.profileBorder))),
                          padding: const EdgeInsets.all(18),
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                    width: widgetSize.getWidth(90, context),
                                    height: widgetSize.getWidth(90, context),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorResources.gainsboro),
                                    child: (userModel != null &&
                                            userModel!.profileDetails != null &&
                                            userModel!.profileDetails!
                                                    .userImage !=
                                                null &&
                                            image!.path.isEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              userModel!
                                                  .profileDetails!.userImage!,
                                              fit: BoxFit.fill,
                                            ))
                                        : (image!.path.isNotEmpty)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.file(
                                                  File(image!.path),
                                                  fit: BoxFit.fill,
                                                ))
                                            : Center(
                                                child: SvgPicture.asset(
                                                Assets.svgProfiless,
                                              ))),
                                Positioned(
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        XFile? image2 = await _picker.pickImage(
                                            source: ImageSource.gallery);
                                        if (image2 != null) {
                                          ApiResponse<UpdateProfileModel>
                                              resForUpdateProfile =
                                              await context
                                                  .read<HomeProvider>()
                                                  .updateProfile(
                                                      image2, jsonEncode({}));
                                          if (resForUpdateProfile.status ==
                                              Status.COMPLETED) {
                                            setState(() {
                                              image = image2;
                                            });

                                            /// Save New Data In Shared Preferences
                                            var token =
                                                "${userModel!.keyDetails!.apiKey!}:${userModel!.keyDetails!.apiSecret!}";
                                            await context
                                                .read<AppProvider>()
                                                .setSignInUser(
                                                    true,
                                                    json.encode(
                                                        LoginResponseModel(
                                                            message: userModel!
                                                                .message,
                                                            homePage: userModel!
                                                                .homePage,
                                                            fullName: userModel!
                                                                .fullName,
                                                            customerID:
                                                                userModel!
                                                                    .customerID,
                                                            user:
                                                                userModel!.user,
                                                            keyDetails:
                                                                userModel!
                                                                    .keyDetails,
                                                            customerType:
                                                                userModel!
                                                                    .customerType,
                                                            profileDetails:
                                                                ProfileDetails(
                                                              firstName: userModel!
                                                                  .profileDetails!
                                                                  .firstName,
                                                              lastName: userModel!
                                                                  .profileDetails!
                                                                  .lastName,
                                                              email: userModel!
                                                                  .profileDetails!
                                                                  .email,
                                                              mobileNo: userModel!
                                                                  .profileDetails!
                                                                  .mobileNo,
                                                              gender: userModel!
                                                                  .profileDetails!
                                                                  .gender,
                                                              companyName: userModel!
                                                                  .profileDetails!
                                                                  .companyName,
                                                              customerAgent: userModel!
                                                                  .profileDetails!
                                                                  .customerAgent,
                                                              userImage:
                                                                  resForUpdateProfile
                                                                      .data!
                                                                      .data!
                                                                      .userImage,
                                                            ))),
                                                    token);

                                            Fluttertoast.showToast(
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                msg: resForUpdateProfile
                                                        .data?.message ??
                                                    "",
                                                timeInSecForIosWeb: 4,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else {
                                            Fluttertoast.showToast(
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                msg: resForUpdateProfile
                                                        .data?.message ??
                                                    "",
                                                timeInSecForIosWeb: 4,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorResources.studio),
                                          child: const Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: widgetSize.getHeight(5, context)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            userModel != null &&
                                    userModel!.profileDetails != null &&
                                    userModel!.profileDetails!.firstName !=
                                        null &&
                                    userModel!.profileDetails!.lastName != null
                                ? "${userModel!.profileDetails!.firstName!} ${userModel!.profileDetails!.lastName!}"
                                : 'زائر',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(20, context),
                              color: const Color(0xff2e2e2e),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      if (userModel != null &&
                          userModel!.profileDetails != null &&
                          userModel!.profileDetails!.companyName != null) ...[
                        Padding(
                          padding: EdgeInsets.only(
                              top: widgetSize.getHeight(5, context)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              userModel!.profileDetails!.companyName!,
                              style: TextStyle(
                                fontSize: widgetSize.getHeight(16, context),
                                color: const Color(0xffa2a2a2),
                              ),
                            ),
                          ),
                        ),
                      ],

                      Padding(
                        padding: EdgeInsets.only(
                            top: widgetSize.getHeight(5, context)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            userModel != null &&
                                    userModel!.profileDetails != null &&
                                    userModel!.profileDetails!.mobileNo != null
                                ? userModel!.profileDetails!.mobileNo!
                                : '',
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(16, context),
                              color: const Color(0xffa2a2a2),
                            ),
                          ),
                        ),
                      ),

                      if (userModel != null) ...[
                        SafeOnTap(
                          onSafeTap: () async {},
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              // alignment: Alignment.center,
                              // child: Wrap(
                              //   spacing: widgetSize.getWidth(10, context),
                              //   runSpacing: widgetSize.getWidth(10, context),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    /// FILTER DWR is transfer = 0
                                    SafeOnTap(
                                      onSafeTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child:
                                                const SharedBottomNavigationBar(
                                                    widget:
                                                        ShippingOrderHistory(
                                                            shippingType:
                                                                ShippingType
                                                                    .wallet)),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffaf6ff),
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    10, context),
                                              ),
                                              SvgPicture.asset(
                                                Assets.svgShippingPurple,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    15, context),
                                              ),
                                              Text(
                                                'طلبات الشحن',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(14, context),
                                                  color:
                                                      const Color(0xff7d5ba6),
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    40, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// FILTER SI
                                    SafeOnTap(
                                      onSafeTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child:
                                                const SharedBottomNavigationBar(
                                                    widget:
                                                        PurchaseOrderHistory()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffaf6ff),
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    10, context),
                                              ),
                                              SvgPicture.asset(
                                                Assets.svgPurchasePurple,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    15, context),
                                              ),
                                              Text(
                                                'طلبات الشراء',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(14, context),
                                                  color:
                                                      const Color(0xff7d5ba6),
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                width: widgetSize.getWidth(
                                                    18, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: widgetSize.getHeight(5, context)),
                                if (userModel != null &&
                                    userModel!.customerType == "Agent")
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        /// FILTER DWR is transfer = 1
                                        // if(context.watch<AppProvider>().agentModel?.data != null &&  context.watch<AppProvider>().agentModel!.data!.isNotEmpty)
                                        if (userModel!.customerType ==
                                                "Agent Customer" ||
                                            userModel!.customerType == "Agent")
                                          SafeOnTap(
                                            onSafeTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:
                                                      const SharedBottomNavigationBar(
                                                          widget:
                                                              ShippingOrderHistory(
                                                    shippingType:
                                                        ShippingType.customers,
                                                  )),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xfffaf6ff),
                                                borderRadius:
                                                    BorderRadius.circular(22.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 2),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              10, context),
                                                    ),
                                                    SvgPicture.asset(
                                                      Assets.svgShippingPurple,
                                                      width: 20,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              15, context),
                                                    ),
                                                    Text(
                                                      'طلبات شحن العملاء',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                14, context),
                                                        color: const Color(
                                                            0xff7d5ba6),
                                                      ),
                                                      softWrap: false,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              10, context),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        /// PAYMENT
                                        // if(context.watch<AppProvider>().agentModel?.data != null &&  context.watch<AppProvider>().agentModel!.data!.isNotEmpty)
                                        if (userModel!.customerType == "Agent")
                                          SafeOnTap(
                                            onSafeTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: const SharedBottomNavigationBar(
                                                      widget:
                                                          BatchHistoryScreen()),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xfffaf6ff),
                                                borderRadius:
                                                    BorderRadius.circular(22.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 2),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              10, context),
                                                    ),
                                                    SvgPicture.asset(
                                                      Assets.svgPurchasePurple,
                                                      width: 20,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              15, context),
                                                    ),
                                                    Text(
                                                      'سجل الدفعات',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                14, context),
                                                        color: const Color(
                                                            0xff7d5ba6),
                                                      ),
                                                      softWrap: false,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          widgetSize.getWidth(
                                                              10, context),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ])
                              ],
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widgetSize.getHeight(30, context),
                        )
                      ],

                      if (userModel != null)
                        SafeOnTap(
                          onSafeTap: () async {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SharedBottomNavigationBar(
                                    widget: EditProfileScreen()),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgProfile),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "تعديل الملف الشخصي",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      // Visibility(
                      //   visible: Platform.isAndroid,
                      //   child: SafeOnTap(onSafeTap: ()async{
                      //     // Navigator.push(
                      //     //   context,
                      //     //   PageTransition(
                      //     //     type: PageTransitionType.fade,
                      //     //     child: SharedBottomNavigationBar(widget: EditProfileScreen()),
                      //     //   ),
                      //     // );
                      //   },
                      //     child: Padding(
                      //       padding: EdgeInsets.only(top:widgetSize.getHeight(20, context)),
                      //       child: Column(
                      //         children: [
                      //           Row(children: [
                      //             SvgPicture.asset(Assets.folder),
                      //             SizedBox(width: widgetSize.getWidth(10, context),),
                      //             Text(
                      //               "سجل الطلبات",
                      //               style: TextStyle(
                      //
                      //                 fontSize: widgetSize.getHeight(16, context),
                      //                 color: const  Color(0xff6b6b6b),
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      //
                      //             ),
                      //
                      //             const Spacer(),
                      //             const RotatedBox(
                      //                 quarterTurns: 0,child: Icon(Icons.arrow_back_ios_new,color:  Color(0xff6b6b6b),size: 18))
                      //           ],),
                      //           SizedBox(height: widgetSize.getHeight(10, context),),
                      //           Container(height: 1,
                      //             color: ColorResources.light_grey.withOpacity(0.5),)
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Visibility(
                        visible: Platform.isAndroid,
                        child: SafeOnTap(
                          onSafeTap: () async {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: SharedBottomNavigationBar(
                                    widget: PrintScreen(DirectOrderResponse())),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgPrinter),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "إعدادات الطابعة",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (userModel != null)
                        SafeOnTap(
                          onSafeTap: () async {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: const SharedBottomNavigationBar(
                                      widget: NotificationScreen(),
                                    )));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.alarmAsSvg),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "الإشعارات",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (userModel != null &&
                          context.read<AppProvider>().utilitiesModel != null &&
                          context.read<AppProvider>().utilitiesModel!.data !=
                              null &&
                          context
                                  .read<AppProvider>()
                                  .utilitiesModel!
                                  .data!
                                  .companyWhatsappNumber !=
                              null) ...[
                        SafeOnTap(
                          onSafeTap: () async {
                            String link;
                            final phoneNumber = context
                                .read<AppProvider>()
                                .utilitiesModel!
                                .data!
                                .companyWhatsappNumber!;
                            const text = 'مرحبا، هل يمكنني التحدث الى شخص ما؟';
                            if (Platform.isAndroid) {
                              link = 'https://wa.me/$phoneNumber?text=$text';
                            } else {
                              link = 'https://wa.me/$phoneNumber/?text=$text';
                            }
                            await launchUrl(Uri.parse(link),
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgWhatIcon),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "تواصل واتس",
                                          style: TextStyle(
                                            fontSize: widgetSize.getHeight(
                                                16, context),
                                            color: const Color(0xff6b6b6b),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (userModel != null &&
                          context.read<AppProvider>().utilitiesModel != null &&
                          context.read<AppProvider>().utilitiesModel!.data !=
                              null &&
                          context
                                  .read<AppProvider>()
                                  .utilitiesModel!
                                  .data!
                                  .callUs !=
                              null) ...[
                        SafeOnTap(
                          onSafeTap: () async {
                            final Uri phoneLaunchUri = Uri(
                              scheme: 'tel',
                              path: context
                                  .read<AppProvider>()
                                  .utilitiesModel!
                                  .data!
                                  .callUs,
                            );
                            launchUrl(phoneLaunchUri);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(Assets.imgTelephone,
                                        width: 20, height: 20),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "اتصل بنا",
                                          style: TextStyle(
                                            fontSize: widgetSize.getHeight(
                                                16, context),
                                            color: const Color(0xff6b6b6b),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (userModel != null &&
                          context.read<AppProvider>().utilitiesModel != null &&
                          context.read<AppProvider>().utilitiesModel!.data !=
                              null &&
                          context
                                  .read<AppProvider>()
                                  .utilitiesModel!
                                  .data!
                                  .privacyPolicy !=
                              null) ...[
                        SafeOnTap(
                          onSafeTap: () async {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: PrivacyPolicyScreen(context
                                        .read<AppProvider>()
                                        .utilitiesModel!
                                        .data!
                                        .privacyPolicy!)));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgPolicy),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "سياسة الخصوصية",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Color(0xff6b6b6b), size: 18))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (userModel != null) ...[
                        SafeOnTap(
                          onSafeTap: () =>
                              _showDeleteConfirmationDialog(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.person_remove_alt_1_outlined),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "حذف الحساب",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Color(0xff6b6b6b),
                                          size: 18,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                        SafeOnTap(
                          onSafeTap: _signOut,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgSignOut),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "تسجيل الخروج",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Color(0xff6b6b6b),
                                          size: 18,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (userModel == null) ...[
                        SafeOnTap(
                          onSafeTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen(
                                          fromSetting: true,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widgetSize.getHeight(20, context)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(Assets.svgSignOut),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff6b6b6b),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const RotatedBox(
                                        quarterTurns: 0,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Color(0xff6b6b6b),
                                          size: 18,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),
                                Container(
                                  height: 1,
                                  color: ColorResources.light_grey
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],

                      SizedBox(
                        height: widgetSize.getHeight(40, context),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "  الإصدار ",
                            style: TextStyle(
                              fontSize: widgetSize.getHeight(14, context),
                              color: const Color(0xffc5c5c5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: widgetSize.getHeight(90, context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await Provider.of<AppProvider>(context, listen: false).setSignOutUser();
    context.read<HomeProvider>().directWalletRequestLogModelVar =
        DirectWalletRequestLogModel();
    await Navigator.of(context).maybePop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => SignInScreen(
                  fromSetting: false,
                )),
        (Route<dynamic> route) => false);
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('هل أنت متأكد؟'),
            actions: [
              TextButton(
                  onPressed: _signOut,
                  child: const Text('نعم',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorResources.studio))),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لا',
                      style: TextStyle(
                          color: ColorResources.studio,
                          fontWeight: FontWeight.bold)))
            ],
          );
        });
  }

  buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widgetSize.getHeight(200, context),
      decoration: const BoxDecoration(
          color: ColorResources.studio,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
    userModel = context.read<AppProvider>().getUserInfo();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.read<AppProvider>().getAgentCustomers();
    });
    super.initState();
  }
}
