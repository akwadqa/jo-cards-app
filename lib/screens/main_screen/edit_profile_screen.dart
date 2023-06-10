import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/auth/sign_in_screen.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/screens/widget/textformfield.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/validations.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

import 'widgets/check_box/akwad_checkbox.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _emailController;

  // late TextEditingController _passwordController;

  late TextEditingController _newPasswordController;

  late TextEditingController _nameController;

  late TextEditingController _lastNameController;

  late TextEditingController _companyController;

  late TextEditingController _phoneController;

  late TextEditingController _delegateController;

  bool _isAgent = false;
  bool _isCustomer = false;

  final GlobalKey<FormState> _key = GlobalKey();
  LoginResponseModel? userModel;

  @override
  void initState() {
    userModel= context.read<AppProvider>().getUserInfo();
    _emailController = TextEditingController(text: userModel!.user);
    // _passwordController = TextEditingController(text: "");
    _newPasswordController = TextEditingController(text: "");
    _nameController = TextEditingController(text: userModel!.profileDetails!.firstName);
    _lastNameController = TextEditingController(text: userModel!.profileDetails!.lastName);
    _companyController = TextEditingController(text: userModel!.profileDetails!.companyName);
    _phoneController = TextEditingController(text: userModel!.profileDetails!.mobileNo);
    _delegateController = userModel!.customerType =="Agent Customer"?  TextEditingController(text: userModel!.profileDetails!.customerAgent) :TextEditingController(text: "");
    setUserStatus();
    super.initState();
  }

  void setUserStatus() {
   userModel!.customerType == "End Customer" ? _isCustomer=true :_isAgent = true ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Form(
        key: _key,
        child: ListView(
         padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context),vertical: widgetSize.getHeight(10, context)),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: widgetSize.getHeight(16, context)),
              child: Text(
                "بيانات الحساب",
                style: TextStyle(
                  fontSize: widgetSize.getHeight(18, context),
                  color: const  Color(0xff6b6b6b),
                  fontWeight: FontWeight.w500,
                ),

              ),
            ),
            CustomTextField(
              textEditingController: _emailController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.emailAddress,

              hint: "البريد الإلكتروني",
              validate: Validations().filedRequired,
            ),

            // SizedBox(height: widgetSize.getHeight(20, context)),
            // CustomTextField(
            //   textEditingController: _passwordController,
            //   maxLines: 1,
            //   borderRaduis: 10,
            //   keyboardType: TextInputType.visiblePassword,
            //
            //   hint: "كلمة المرور القديمة",
            //   validate: Validations().filedRequired,
            // ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _newPasswordController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.visiblePassword,

              hint: "كلمة المرور الجديدة",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: widgetSize.getHeight(16, context)),
              child: Text(
                "بيانات الاتصال",
                style: TextStyle(
                  fontSize: widgetSize.getHeight(18, context),
                  color: const  Color(0xff6b6b6b),
                  fontWeight: FontWeight.w500,
                ),

              ),
            ),

            CustomTextField(
              textEditingController: _nameController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "الاسم الأول",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _lastNameController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "الاسم الأخير",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _companyController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "الشركة",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _phoneController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.phone,

              hint: "الهاتف",
              validate: Validations().filedRequired,
            ),
            if(userModel!.customerType == "Agent Customer")...[
              SizedBox(height: widgetSize.getHeight(20, context)),
              CustomTextField(
              textEditingController: _delegateController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "اسم المندوب",
              validate: Validations().filedRequired,
            ),
              ],
            SizedBox(height: widgetSize.getHeight(20, context)),
            Text(
              "الصنف",
              style: TextStyle(
                fontSize: widgetSize.getHeight(18, context),
                color: const  Color(0xff6b6b6b),
                fontWeight: FontWeight.w500,
              ),

            ),

            Row(
              children: [
                Row(
                  children: [
                    Checkbox(value: _isCustomer, onChanged: (value){
                    //   setState(() {
                    //   _isCustomer = true;
                    //   _isAgent = false;
                    // });
                      }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),),
                    const Text("شخصي"),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(value: _isAgent, onChanged: (value){
                    //   setState(() {
                    //   _isCustomer = false;
                    //   _isAgent = true;
                    // });
                      }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),),
                    const Text("تاجر"),
                  ],
                ),
              ],
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            ElevatedButton(
              onPressed: () async{

                /// Update Profile Data
                Map<String, dynamic> profileData = {
                  if(_nameController.text != userModel!.profileDetails!.firstName) "first_name": _nameController.text,
                  if(_lastNameController.text != userModel!.profileDetails!.lastName) "last_name": _lastNameController.text,
                  if(_phoneController.text != userModel!.profileDetails!.mobileNo) "mobile_no": _phoneController.text,
                  if(_emailController.text != userModel!.profileDetails!.email) "email": _emailController.text,
                  if(_companyController.text != userModel!.profileDetails!.companyName) "company_name": _companyController.text,
                  if(_delegateController.text != "") "customer_agent": _delegateController.text,
                };
                var resForUpdateProfile = await context.read<HomeProvider>().updateProfile(null, jsonEncode(profileData));
                if(resForUpdateProfile.status == Status.COMPLETED){
                  LoginResponseModel newUserModel =  LoginResponseModel(
                    message : userModel!.message,
                    homePage : userModel!.homePage,
                    fullName: "${_nameController.text} ${_lastNameController.text}",
                    customerID: userModel!.customerID,
                    user: userModel!.user,
                    keyDetails: userModel!.keyDetails,
                    customerType: userModel!.customerType,
                    profileDetails: ProfileDetails(
                        firstName: _nameController.text != userModel!.profileDetails!.firstName ? _nameController.text : userModel!.profileDetails!.firstName,
                        lastName: _lastNameController.text != userModel!.profileDetails!.lastName ? _lastNameController.text :userModel!.profileDetails!.lastName,
                        email: _emailController.text != userModel!.profileDetails!.email ? _emailController.text : userModel!.profileDetails!.email,
                        mobileNo: _phoneController.text != userModel!.profileDetails!.mobileNo ? _phoneController.text : userModel!.profileDetails!.mobileNo,
                        gender: userModel!.profileDetails!.gender,
                        companyName: _companyController.text != userModel!.profileDetails!.companyName ? _companyController.text : userModel!.profileDetails!.companyName,
                        customerAgent: userModel!.profileDetails!.customerAgent,
                        userImage: userModel!.profileDetails!.userImage
                    )
                  );

                  /// Save New Data In Shared Preferences
                  var token = "${userModel!.keyDetails!.apiKey!}:${userModel!.keyDetails!.apiSecret!}";
                  await context.read<AppProvider>().setSignInUser(true, json.encode(newUserModel) ,token);

                  /// Update Password
                  if(_newPasswordController.text != "") {
                    String oldPassword = await context.read<AppProvider>().getOldPassword();
                    var resForUpdatePassword = await context.read<HomeProvider>().updatePassword(oldPassword, _newPasswordController.text);
                    if(resForUpdatePassword.status == Status.COMPLETED){
                      Fluttertoast.showToast(
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          msg: resForUpdatePassword.data?.message ?? "",
                          timeInSecForIosWeb: 4,
                          toastLength: Toast.LENGTH_LONG);
                      await context.read<AppProvider>().setOldPassword( _newPasswordController.text);
                      await Provider.of<AppProvider>(context,listen:false).setSignOutUser();

                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          SignInScreen(fromSetting: false,)), (Route<dynamic> route) => false);

                    }
                    else{
                      Fluttertoast.showToast(
                          backgroundColor: ColorResources.studio,
                          textColor: Colors.white,
                          msg: resForUpdatePassword.data?.message ?? "حدثت مشكلة في تغيير كلمة السر",
                          timeInSecForIosWeb: 4,
                          toastLength: Toast.LENGTH_LONG);
                    }
                  }
                  else{
                    Navigator.of(context).pop();
                  }
                  context.read<AppProvider>().getUserInfo();
                  Fluttertoast.showToast(
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      msg: resForUpdateProfile.data?.message ?? "",
                      timeInSecForIosWeb: 4,
                      toastLength: Toast.LENGTH_LONG);
                }
                else{
                  Fluttertoast.showToast(
                      backgroundColor: ColorResources.studio,
                      textColor: Colors.white,
                      msg: resForUpdateProfile.data?.message ?? "",
                      timeInSecForIosWeb: 4,
                      toastLength: Toast.LENGTH_LONG);
                }
              },
              style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.all(ColorResources.lightBlue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check),
                  SizedBox(width: 5),
                  const Text('حفظ'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: const BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SafeOnTap(onSafeTap: () { Navigator.pop(context); },
                    child: SvgPicture.asset(Assets.svgBack)),
                const Spacer(),
                Text(
                  "تعديل الملف الشخصي",
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(18, context),
                    color: const Color(0xffffffff),
                  ),
                  softWrap: false,
                ),
                const Spacer(),
                const SizedBox(width: 30,)

              ],
            ),
          ),
        ));
  }
}

