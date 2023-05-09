import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/provider/app_provider.dart';
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

  late TextEditingController _passwordController;

  late TextEditingController _newPasswordController;

  late TextEditingController _nameController;

  late TextEditingController _storeController;

  late TextEditingController _companyController;

  late TextEditingController _phoneController;

  late TextEditingController _delegateController;

  late String _userType;

  final GlobalKey<FormState> _key = GlobalKey();
  LoginResponseModel? userModel;
  @override
  void initState() {
    userModel= context.read<AppProvider>().getUserInfo();
    _emailController = TextEditingController(text: userModel!.user);
    _passwordController = TextEditingController(text: "");
    _newPasswordController = TextEditingController(text: "");
    _nameController = TextEditingController(text: userModel!.fullName);
    _storeController = TextEditingController(text: "اسم المحل");
    _companyController = TextEditingController(text: "اسم الشركة");
    _phoneController = TextEditingController(text: userModel!.profileDetails!.mobileNo);
    _delegateController = TextEditingController(text: "No one");
    super.initState();
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

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _passwordController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.visiblePassword,

              hint: "كلمة المرور القديمة",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _newPasswordController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.visiblePassword,

              hint: "كلمة المرور القديمة",
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

              hint: "الاسم الكامل",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _storeController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "اسم المحل",
              validate: Validations().filedRequired,
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _storeController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.name,

              hint: "اسم المحل",
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

            SizedBox(height: widgetSize.getHeight(20, context)),
            CustomTextField(
              textEditingController: _delegateController,
              maxLines: 1,
              borderRaduis: 10,
              keyboardType: TextInputType.phone,

              hint: "اسم المندوب",
              validate: Validations().filedRequired,
            ),

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
                AkwadCheckBox(typeValue: true, typeName: "شخصي", function: (value){},),
                AkwadCheckBox(typeValue: false, typeName: "تاجر", function: (value){},),
              ],
            ),

            SizedBox(height: widgetSize.getHeight(20, context)),
            ElevatedButton(
              onPressed: () {
                // Todo 1 : Need to Connect with server to update user profile
              },
              style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.all(ColorResources.lightBlue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

