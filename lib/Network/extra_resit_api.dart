// This file for Apis which need to params don't allowed in retrofit
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jocards/main.dart';
import 'package:http/http.dart' as http;
import 'package:jocards/model/response_model.dart';
import 'package:jocards/model/update_profile_model.dart';
import 'package:jocards/utill/strings.dart';

class ExtraResitApi {
  // Handle this function without using Retrofit package for uploading image
  Future<UpdateProfileModel> updateProfile(XFile? file, String data) async {
    var headers = {
      'content-type': 'application/json',
      'Authorization': 'token ${sharedPreferences.getString(Strings.Token)}',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Strings.BASR_URl}/api/method/jocards.smart_api.update_profile'));

    request.fields.addAll({'data': data});

    file == null
        ? null
        : request.files
            .add(await http.MultipartFile.fromPath('file', file.path));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    // var responseData = await http.Response.fromStream(response);
    UpdateProfileModel updateProfileModel = UpdateProfileModel();
    if (kDebugMode) {
      print(request.url);
      print(request.fields);
      print(response.request);
      print(response.statusCode);
      print(response.reasonPhrase);
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> json;
      await response.stream.bytesToString().then((value) {
        json = jsonDecode(value);
        updateProfileModel = UpdateProfileModel.fromMap(json);
      });

      return updateProfileModel;
    } else {
      updateProfileModel = UpdateProfileModel(
        statusCode: response.statusCode,
        message: "Failed",
      );
      return updateProfileModel;
    }
  }

  // Handle this function without using Retrofit package because in Params retrofit convert "@" to "%40" and api don't work then
  Future<ResponseModel> resetPassword(String email) async {
    var headers = {
      'content-type': 'application/json',
    };
    String url =
        '${Strings.BASR_URl}/api/method/jocards.smart_api.password_reset?user=$email';
    var request = await http.post(Uri.parse(url), headers: headers);
    late ResponseModel responseModel;

    if (kDebugMode) {
      print(url);
      print(request);
      print(request.statusCode);
      print(request.reasonPhrase);
    }

    if (request.statusCode == 200) {
      String json = jsonEncode(request.body);
      if (json == "[]") {
        responseModel = ResponseModel(
            statusCode: 200,
            message: "الرجاء التأكد من البريد الالكتروني",
            data: "[]");
      } else {
        responseModel = ResponseModel(
            statusCode: 200,
            message: " تم إرسال رسالة إلى البريد الالكتروني الخاص بك",
            data: "");
      }
    } else {
      responseModel = ResponseModel(
          statusCode: request.statusCode, message: "حدث خطأ", data: "");
    }
    return responseModel;
  }
}
