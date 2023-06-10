import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/main.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/model/response_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/shared_nav_bar_provider.dart';
import 'package:jocards/screens/auth/sign_up_screen.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/sign_in_header.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/screens/widget/textformfield.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/validations.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../provider/home_provider.dart';
import '../main_screen/main_screen.dart';


class SignInScreen extends StatefulWidget {
  String ?email;
  String?password;
  bool ?fromSetting;



  SignInScreen({this.email, this.password,this.fromSetting});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  String email="";
  String password="";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: transparentStatusBarAndTransparentSystemBar,
      child: Scaffold(
        backgroundColor:Colors.white ,
        appBar: AppBar(toolbarHeight: 0,elevation: 0,backgroundColor: ColorResources.studio,),
        body:SafeArea(
          child: Stack(
            children: [
              ListView(
                physics: const ClampingScrollPhysics(),
                 children: [
                   SignInHeaderWidget(visibleArrow: widget.fromSetting,),
                   SizedBox(height: widgetSize.getHeight(90, context),),
                   Padding(
                     padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context)),
                     child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(22, context)),
                           child: Text(
                             'دخول للتطبيق',
                             style: TextStyle(
                               fontFamily: 'DIN Next LT W23',
                               fontSize: widgetSize.getHeight(26, context),
                               color: ColorResources.nightRider,
                               fontWeight: FontWeight.w500,
                             ),

                             ),

                         ),
                         SizedBox(height: widgetSize.getHeight(30, context),),

                         Form(
                           key: _key,
                           child: Column(
                             children: <Widget>[
                               emailTextFormField(),
                               SizedBox(height: widgetSize.getHeight(15, context)),
                               passwordTextFormField(),
                             ],
                           ),
                         ),
                         SizedBox(height: widgetSize.getHeight(14, context),),

                         SafeOnTap(
                           onSafeTap: (){
                             final RegExp nameExp =  RegExp(
                                 r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

                             if(emailController.text.isEmpty){ Fluttertoast.showToast(
                                 backgroundColor: ColorResources.nightRider,
                                 textColor: Colors.white,
                                 msg: "الرجاء ادخال البريد الالكتروني",
                                 timeInSecForIosWeb: 4,
                                 toastLength: Toast.LENGTH_LONG);}
                             else if(!nameExp.hasMatch(emailController.text)) {
                               Fluttertoast.showToast(
                                 backgroundColor: ColorResources.nightRider,
                                 textColor: Colors.white,
                                 msg: "بريد الكتروني خاطئ",
                                 timeInSecForIosWeb: 4,
                                 toastLength: Toast.LENGTH_LONG);}
                             else {
                               resetPassword(emailController.text);
                             }
                           },
                           child: Align(
                             alignment: Alignment.centerLeft,
                             child: Text(
                               'نسيت كلمة المرور ',
                               style: TextStyle(
                                 fontFamily: 'DIN Next LT W23',
                                 fontSize: widgetSize.getHeight(15, context),
                                 color: const Color(0xff2892d7),
                                 decoration: TextDecoration.underline,
                               ),
                               softWrap: false,
                             ),
                           ),
                         ),
                         SizedBox(height: widgetSize.getHeight(60, context),),

                         SafeOnTap(
                           onSafeTap: () {
                             final FormState form = _key.currentState!;
                             FocusScope.of(context).unfocus();
                             if (form.validate()) {
                               form.save();
                               if (!context.read<AppProvider>().isLoading) {
                                 loginFunc();
                               }
                             }
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               color: ColorResources.summerSky,
                               borderRadius: BorderRadius.circular(15.0),
                               border: Border.all(width: 1.0, color: const Color(0xff2892d7)),
                               boxShadow: [
                                 BoxShadow(
                                   color: const Color(0x401d4c9b),
                                   offset: Offset(0, 5),
                                   blurRadius: 11,
                                 ),
                               ],
                             ),child: Center(
                               child: Padding(padding: EdgeInsets.symmetric(
                                 vertical: widgetSize.getHeight(16, context)),

                           child: Text(
                               'تسجيل دخول ',
                               style: TextStyle(
                                 fontFamily: 'DIN Next LT W23',
                                 fontSize: widgetSize.getHeight(17, context),
                                 color: const Color(0xffffffff),
                                 fontWeight: FontWeight.w500,
                               ),
                               softWrap: false,
                           ),),
                             ),
                           ),
                         ),
                         SizedBox(height: widgetSize.getHeight(16, context),),

                         SafeOnTap(
                           onSafeTap: () {
                             Navigator.push(
                               context,
                               PageTransition(
                                 type: PageTransitionType.topToBottom,
                                 child: SignUpScreen(),
                               ), );
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(15.0),
                               border: Border.all(width: 1.0, color: ColorResources.summerSky,),

                             ),child: Center(
                             child: Padding(padding: EdgeInsets.symmetric(
                                 vertical: widgetSize.getHeight(16, context)),

                               child: Text(
                                 'حساب جديد',
                                 style: TextStyle(
                                   fontFamily: 'DIN Next LT W23',
                                   fontSize: widgetSize.getHeight(17, context),
                                   color:  ColorResources.summerSky,
                                   fontWeight: FontWeight.w500,
                                 ),
                                 softWrap: false,
                               ),),
                           ),
                           ),
                         ),
                         SizedBox(height: widgetSize.getHeight(16, context),),

                         SafeOnTap(onSafeTap: ()async{
                           context.read<HomeProvider>().homsResponse=null;
                           if( context.read<SharedNavBarProvider>().controller.hasClients) context.read<SharedNavBarProvider>().initialController();
                           context.read<SharedNavBarProvider>().changeBottomIndex(0);
                           context.read<SharedNavBarProvider>().changeControllerIndex(0);
                           await  Navigator.pushReplacement(
                             context,
                             PageTransition(
                               type: PageTransitionType.rightToLeftWithFade,
                               child: SharedBottomNavigationBar(widget: MainScreen()),
                             ), );
                         },
                           child: Center(
                           child: Padding(padding: EdgeInsets.symmetric(
                               vertical: widgetSize.getHeight(16, context)),

                             child: Text(
                               'تصفح كزائر',
                               style: TextStyle(
                                 fontFamily: 'DIN Next LT W23',
                                 fontSize: widgetSize.getHeight(17, context),
                                 color:  ColorResources.summerSky,
                                 fontWeight: FontWeight.w500,
                               ),
                               softWrap: false,
                             ),),
                           ),
                         ),

                       ],
                     ),
                   ),




                 ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Visibility(
                      visible: Provider.of<AppProvider>(context, listen: true)
                          .isLoading,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ColorResources.studio),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ) ,
      ),
    );
  }
  loginFunc() async {
    var res = await  context.read<AppProvider>().signIn(email.trim(),password);

    if(res.status==Status.COMPLETED){

        var token = res.data!.keyDetails!.apiKey!+":"+res.data!.keyDetails!.apiSecret!;
        await context.read<AppProvider>().setSignInUser(true, json.encode(res.data!) ,token);
        await context.read<AppProvider>().setOldPassword(password);
        await context.read<AppProvider>().getUtilities();
        if(await Provider.of<AppProvider>(context, listen: false).isUserSigned()){
          LoginResponseModel? userInfo = Provider.of<AppProvider>(context, listen: false).getUserInfo();
          String deviceType = "";
          if(Platform.isAndroid){
            await FirebaseMessaging.instance.subscribeToTopic("android");
            deviceType = "android";
          }
          if(Platform.isIOS){
            await FirebaseMessaging.instance.subscribeToTopic("ios");
            deviceType = "ios";
          }
          print(androidInfo.device);
          Provider.of<AppProvider>(context, listen: false).sendUpdateToken(await Provider.of<AppProvider>(context, listen: false).getFirebaseToken(), userInfo!.profileDetails!.email!, deviceType, androidInfo.device);
        }
        await  Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: SharedBottomNavigationBar(widget: MainScreen()),
            ), (route)=> false);





    }
    else{
      String? message = res.message;
      if(message != null && message.contains('Invalid login credentials')){
        message = 'خطأ في كلمة المرور أو البريد الالكتروني';
      }
      if(message != null && message.contains('User disabled or missing')){
        message = 'المستخدم معطل أو مفقود';
      }
      Fluttertoast.showToast(
          backgroundColor: ColorResources.studio,
          textColor: Colors.white,
          msg: message ?? "",
          timeInSecForIosWeb: 4,
          toastLength: Toast.LENGTH_LONG);
    }

  }

  resetPassword(String email) async {
    var res = await  context.read<AppProvider>().resetPassword(email);

    if(res.status==Status.COMPLETED){
      Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: (res.data!.message) ?? "",
          timeInSecForIosWeb: 4,
          toastLength: Toast.LENGTH_LONG);
    }
    else{
      String? message = res.message;
      Fluttertoast.showToast(
          backgroundColor: ColorResources.studio,
          textColor: Colors.white,
          msg: res.message??"",
          timeInSecForIosWeb: 4,
          toastLength: Toast.LENGTH_LONG);
    }

  }

  Widget emailTextFormField() {
    return CustomTextField(
      maxLines: 1,borderRaduis: 10,

      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,


      hint: "البريد الإلكتروني أو رقم الهاتف المسجل ",
      validate: Validations().filedRequired,
      onSaved: (String ?value){
        email=value!;
      },




    );

  }
  Widget passwordTextFormField() {

    return CustomTextField(
      maxLines: 1,
      borderRaduis: 10,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      hint: "كلمة المرور",
      validate: Validations().validatePassword,
      onSaved: (String ?value){
        password=value!;
      },
    );
  }
  @override
  void initState() {
    if(widget.email!=null&&widget.password!=null){
      emailController.text=widget.email!;
      passwordController.text=widget.password!;
    }
  }
}


