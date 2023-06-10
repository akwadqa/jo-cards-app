import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/main.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/model/register_request_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/main_screen.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/screens/widget/sign_up_header.dart';
import 'package:jocards/screens/widget/textformfield.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/validations.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});




  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _key = GlobalKey();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController territoriesController = TextEditingController();
  String firstName ="";
  String middleName ="";
  String nickName ="";
  String mobile ="";
  String pin ="";
  String email ="";
  String password ="";
  String confirmPassword ="";
  String company ="";
  String territories ="";

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: transparentStatusBarAndTransparentSystemBar,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: ColorResources.studio,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(

                  child: Column(
                    children: [
                      const SignUpHeaderWidget(),
                      SizedBox(
                        height: widgetSize.getHeight(10, context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widgetSize.getWidth(16, context)),
                        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(22, context)),
                              child: Text(
                                'حساب جديد',
                                style: TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: widgetSize.getHeight(26, context),
                                  color: ColorResources.nightRider,
                                  fontWeight: FontWeight.w500,
                                ),

                              ),

                            ),
                            SizedBox(height: widgetSize.getHeight(10, context),),

                            Container(
                              width: double.infinity,
                              height: widgetSize.getHeight(10, context),
                              decoration: BoxDecoration(
                                color: const Color(0xff7d5ba6),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(22, context),
                              vertical: widgetSize.getHeight(15, context)),
                              child: Text(
                                'بيانات الدخول',
                                style: TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: widgetSize.getHeight(19, context),
                                  color: ColorResources.nightRider,
                                  fontWeight: FontWeight.w500,
                                ),

                              ),
                            ),
                      


                            Form(
                              key: _key,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(child: firstNameTextFormField()),
                                      SizedBox(
                                        width: widgetSize.getWidth(10, context),
                                      ),
                                      Expanded(child: lastNameTextFormField()),
                                    ],
                                  ),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  nickNameWidget(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  emailTextFormField(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  pinCodeTextFormField(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  confirmPasswordTextFormField(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  mobileTextFormField(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  companyTextFormField(),
                                  SizedBox(
                                      height: widgetSize.getHeight(15, context)),
                                  territoriesTextFormField()
                                ],
                              ),
                            ),
                            // Adobe XD layer: 'Sign In' (text)
                            // Adobe XD layer: 'Rectangle' (shape)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: widgetSize.getHeight(50, context)),
                              child: InkWell(
                                onTap: () async {
                                  final FormState form = _key.currentState!;
                                  FocusScope.of(context).unfocus();
                                  if (form.validate()) {
                                    form.save();
                                    if(password==confirmPassword){
                                    if (!context.read<AppProvider>().isLoading) {
                                      var signUpReuest=     RegisterRequestModel(firstName:firstName.trim(),middleName: middleName.trim(),lastName: nickName.trim(),email: email.trim(),password: password.trim(),mobileNo: mobile.trim(),companyName: company.trim(),address: territories.trim());
                                      var res = await  context.read<AppProvider>().signUp(jsonEncode(signUpReuest));
                                      if(res.status==Status.COMPLETED){
                                        if(res.status==Status.COMPLETED){
 /*                                         var token = res.data!.keyDetails!.apiKey!+":"+res.data!.keyDetails!.apiSecret!;
                                          context.read<AppProvider>().setSignInUser(true,  json.encode(res.data!), token);*/
                                          try{
                                          var token = "${res.data!.keyDetails!.apiKey!}:${res.data!.keyDetails!.apiSecret!}";
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
                                              Provider.of<AppProvider>(context, listen: false).sendUpdateToken(await Provider.of<AppProvider>(context, listen: false).getFirebaseToken(), userInfo!.profileDetails!.email!, deviceType, androidInfo.device);
                                            }
                                            await registrationSuccessDialog(res.data!.message!);
                                          }
                                          catch(e){
                                            Fluttertoast.showToast(
                                                backgroundColor: ColorResources.studio,
                                                textColor: Colors.white,
                                                msg: res.data!.message ?? "",
                                                timeInSecForIosWeb: 4,
                                                toastLength: Toast.LENGTH_LONG
                                            );
                                          }
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                              backgroundColor: ColorResources.studio,
                                              textColor: Colors.white,
                                              msg: res.data!.message ?? "",
                                              timeInSecForIosWeb: 4,
                                              toastLength: Toast.LENGTH_LONG
                                          );
                                        }

                                      }
                                      else{
                                        Fluttertoast.showToast(
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            msg: res.message ?? "",
                                            timeInSecForIosWeb: 4,
                                            toastLength: Toast.LENGTH_LONG);
                                      }
                                    }}
                                    else{
                                      Fluttertoast.showToast(
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          msg:"يرجى التأكد من كلمة المرور",
                                          timeInSecForIosWeb: 4,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                  }
                                },
                                child:Container(
                                  decoration: BoxDecoration(
                                    color: ColorResources.summerSky,
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(width: 1.0, color: const Color(0xff2892d7)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x401d4c9b),
                                        offset: Offset(0, 5),
                                        blurRadius: 11,
                                      ),
                                    ],
                                  ),child: Center(
                                  child: Padding(padding: EdgeInsets.symmetric(
                                      vertical: widgetSize.getHeight(16, context)),

                                    child: Text(
                                      'تسجيل حساب جديد',
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
                            ),
                            SizedBox(
                              height: widgetSize.getHeight(15, context),
                            ),
                            // Adobe XD layer: 'I have an account!' (text)


                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Visibility(
                      visible: Provider.of<AppProvider>(context, listen: true)
                          .isLoading,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.studio),
                        ),
                      )),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      inputFormatters: [ FilteringTextInputFormatter.deny(
          RegExp(r'\s')),],
      maxLines: 1,
      borderRaduis: 5,
      keyboardType: TextInputType.name,
      textEditingController: firstNameController,
      hint: "الاسم الاول",
      validate: Validations().filedRequired,
      onSaved: (String? value) {
 firstName=value!;
      },
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      inputFormatters: [ FilteringTextInputFormatter.deny(
          RegExp(r'\s')),],
      maxLines: 1,
      borderRaduis: 10,
      keyboardType: TextInputType.name,
      textEditingController: lastNameController,
      hint: "الاسم الثاني",
      validate: Validations().filedRequired,
      onSaved: (String? value) {
      middleName=value!;
      },
    );
  }

  Widget nickNameWidget() {
    return CustomTextField(

      maxLines: 1,
      borderRaduis: 10,
      keyboardType: TextInputType.name,
      textEditingController: nickNameController,
      hint: "الكنية",
      validate: Validations().filedRequired,
      onSaved: (String? value) {
        nickName=value!;
      },
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      maxLines: 1,
      borderRaduis: 10,
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      hint: "كلمة المرور",
      validate: Validations().validatePassword,
      onSaved: (String? value) {
       password=value!;
      },
    );
  }

  Widget confirmPasswordTextFormField() {
    return CustomTextField(
      maxLines: 1,
      borderRaduis: 10,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textEditingController: confirmPasswordController,
      hint: "تأكيد كلمة المرور",
      validate: Validations().validatePassword,
      onSaved: (String? value) {
        confirmPassword=value!;
      },
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      maxLines: 1,
      borderRaduis: 10,
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      hint: "البريد الإلكتروني",
      validate: Validations().validateEmail,
      onSaved: (String? value) {
        email=value!;
      },
    );
  }

  Widget mobileTextFormField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomTextField(
        maxLines: 1,
        borderRaduis: 10,
        keyboardType: TextInputType.phone,
        textEditingController: mobileController,
        hint: "الهاتف",
        validate: Validations().validNumber,
        onSaved: (String? value) {
          mobile=value!;
        },
      ),
    );
  }


  Widget companyTextFormField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomTextField(
        maxLines: 1,
        borderRaduis: 10,
        keyboardType: TextInputType.name,
        textEditingController: companyController,
        hint: "اسم المؤسسة",
        validate: Validations().filedRequired,
        onSaved: (String? value) {
          company=value!;
        },
      ),
    );
  }

  Widget pinCodeTextFormField() {
    return CustomTextField(
      maxLines: 1,
      borderRaduis: 10,

      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      hint: "كلمة المرور",
      validate: Validations().validatePassword,
      onSaved: (String? value) {
        password=value!;
      },
    );
  }

   territoriesTextFormField(){
     return CustomTextField(
       maxLines: 1,
       borderRaduis: 10,

       keyboardType: TextInputType.emailAddress,


       textEditingController: territoriesController,
       hint: "العنوان التفصيلي",
       validate: Validations().filedRequired,
       onSaved: (String? value) {
         territories=value!;
       },
     );


  }
  Future<void> showCityListBottmSheet(BuildContext context) async {
    if( context.read<AppProvider>().territoriesModel!=null) {
      var res = await showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context,
            StateSetter setModalState /*You can rename this!*/) =>
            SafeArea(

              child:   Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius
                            .circular(
                            50),
                        topLeft: Radius
                            .circular(
                            50))),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context)),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                          height: widgetSize
                              .getHeight(
                              10,
                              context)),
                      // Adobe XD layer: 'Home Indicator' (shape)
                      Align(
                        alignment:
                        Alignment
                            .center,
                        child:
                        Container(
                          height: widgetSize
                              .getHeight(
                              5,
                              context),
                          width: widgetSize.getWidth(
                              134,
                              context),
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(100.0),
                            color: const Color(
                                0xffEEEEEE),

                        ),
                      )),
                      SizedBox(height: widgetSize.getHeight(30, context),),

                      Align(
                        alignment:
                        Alignment
                            .center,
                        child: Text(
                          'اسم المنطقة',
                          style: TextStyle(
                            fontFamily: 'DIN Next LT W23',
                            fontSize: widgetSize.getHeight(17, context),
                            color: const Color(0xff2e2e2e),
                            fontWeight: FontWeight.w700,
                          ),
                          softWrap: false,
                        ),
                      ),
                      SizedBox(height: widgetSize.getHeight(15, context),),

                      ListView.separated(

                        itemCount: context.read<AppProvider>().territoriesModel!.message!.length,
                        itemBuilder: (context,index){
                          return  SafeOnTap(
                            onSafeTap: () {
                              territoriesController.text=context.read<AppProvider>().territoriesModel!.message![index].name!;
                              Navigator.pop(context);


                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                context.read<AppProvider>().territoriesModel!.message![index].name!,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: widgetSize.getHeight(17, context),
                                  color: const Color(0xff707070),
                                ),

                              ),
                            ),
                          );
                        },
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,color: Color(0xffC9C9C9),),



                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
    }


  }


  registrationSuccessDialog(String message) async {


    var res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          child: Container(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(10, context)),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[

                  SizedBox(height: widgetSize.getHeight(25, context),),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'تسجيل حساب جديد',
                      style: TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: widgetSize.getHeight(20, context),
                        color: const Color(0xff2e2e2e),
                        fontWeight: FontWeight.w700,
                      ),

                    ),
                  ),
                  SizedBox(height: widgetSize.getHeight(30, context),),
                  SvgPicture.asset(Assets.svgRegistrationSuccess),
                  SizedBox(height: widgetSize.getHeight(25, context),),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: widgetSize.getHeight(18, context),
                        color: const Color(0xff6b6b6b),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: widgetSize.getHeight(32, context),),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(90, context)),
                    child: SafeOnTap(
                      onSafeTap: ()async{
                      await  Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const SharedBottomNavigationBar(widget: MainScreen()),
                          ), (route)=> false);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff2892d7),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(width: 1.0, color: const Color(0xff2892d7)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x401d4c9b),
                              offset: Offset(0, 5),
                              blurRadius: 11,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical:
                          widgetSize.getHeight(16, context)),
                          child: Center(
                            child: Text(
                              'تصفح التطبيق',
                              style: TextStyle(
                                fontSize: widgetSize.getHeight(15, context),
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widgetSize.getHeight(45, context),),





                ],
              ),
            ),
          ),
        ));

  }

}
