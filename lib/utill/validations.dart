
import 'package:flutter/cupertino.dart';
import 'package:jocards/utill/app_local.dart';

import '../main.dart';

class Validations {
  String prefix = "              ";

  String? validateName(String value) {
    if (value.isEmpty) return '$prefix الاسم مطلوب. ';
    final RegExp nameExp = RegExp(r'[^0-9]');
    if (!nameExp.hasMatch(value)) {
      return '$prefix الرجاء إدخال أحرف فقط. ';
    }
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
    if (value.isEmpty||!nameExp.hasMatch(value)) return 'بريد الاكتروني خاطئ';}
    return null;
  }

  String? validatePassword(String ?value) {
    if(value!=null)
    if (value.isEmpty||value.length<4) {
      return 'كلمة سر خاطئة';
    }
    return null;
  }

  String? validateLink(String value) {
    if (value.isEmpty) return '$prefix الرابط مطلوب. ';
    final RegExp nameExp = RegExp(
        r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
    if (!nameExp.hasMatch(value)) return '$prefix الرجاء إدخال رابط صالح. ';
    if (value.isEmpty) return '$prefix الحقل مطلوب. ';
    return null;
  }

  String ?validNumber(String ?value) {
    if(value!=null){
    if (value.isEmpty) return 'رقم الهاتف مطلوب';
    final RegExp nameExp = RegExp(r'^[0-9]*$|[\u0660-\u0669]');
    if (!nameExp.hasMatch(value)) return '$prefix الرجاء إدخال رقم هاتف صالح. ';}
    return null;
  }

  String ?validateMobile(String ?value) {
    String patttern = r'(^(?:[0]9)?[0-9]{10,18}$)|(^(?:[0]9)?[\u0660-\u0669]{10,18}$)';
    RegExp regExp =  RegExp(patttern);
    if (value!.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    } else if (!regExp.hasMatch(value)) {
      return 'الرجاء إدخال رفم هاتف صالح';
    }
    return null;
  }
}
