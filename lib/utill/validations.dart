
import 'package:flutter/cupertino.dart';
import 'package:jocards/utill/app_local.dart';

import '../main.dart';

class Validations {
  String prefix = "              ";

  String? validateName(String value) {
    if (value.isEmpty) return '$prefix Name is required.';
    final RegExp nameExp = new RegExp(r'[^0-9]');
    if (!nameExp.hasMatch(value))
      return '$prefix Please enter only alphabetical characters.';
    if (value.isEmpty) return '$prefix الحقل مطلوب';
    return null;
  }

  String? filedRequired(String? value) {
    if (value!.isEmpty) return 'الحقل مطلوب';
    return null;
  }

  String? transferAmountValidator(String? value) {
    if (value!.isEmpty) {
      return 'الحقل مطلوب';
    } else if(double.parse(value) > 5000.0) {
      return 'لا يمكن تجاوز الحد الأقصى للمبلغ';
    }
    return null;
  }

  String ?validateEmail(String? value) {
    if(value!=null){
    final RegExp nameExp =  RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.isEmpty||!nameExp.hasMatch(value)) return 'Invalid email address';}
    return null;
  }

  String? validatePassword(String ?value) {
    if(value!=null)
    if (value.isEmpty||value.length<4) return 'Invalid password';
    return null;
  }

  String? validateLink(String value) {
    if (value.isEmpty) return '$prefix link is required.';
    final RegExp nameExp = new RegExp(
        r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
    if (!nameExp.hasMatch(value)) return '$prefix Please enter vaild link.';
    if (value.isEmpty) return '$prefix This failed is require.';
    return null;
  }

  String ?validNumber(String ?value) {
    if(value!=null){
    if (value.isEmpty) return 'number is required';
    final RegExp nameExp = new RegExp(r'^[0-9]*$|[\u0660-\u0669]');
    if (!nameExp.hasMatch(value)) return '$prefix Please enter vaild pin code.';}
    return null;
  }

  String ?validateMobile(String ?value) {
    String patttern = r'(^(?:[0]9)?[0-9]{10,18}$)|(^(?:[0]9)?[\u0660-\u0669]{10,18}$)';
    RegExp regExp =  RegExp(patttern);
    if (value!.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
