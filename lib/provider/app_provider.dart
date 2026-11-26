import 'dart:async';
import 'dart:convert';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/Network/app_exceptions.dart';
import 'package:jocards/Network/extra_resit_api.dart';
import 'package:jocards/Network/resit_api.dart';
import 'package:jocards/model/app_version_model.dart';
import 'package:jocards/model/customer_model.dart';
import 'package:jocards/model/response_model.dart';
import 'package:jocards/model/territories_model.dart';
import 'package:jocards/model/update_token_model.dart';
import 'package:jocards/utill/strings.dart';

import '../main.dart';
import '../model/agent_model.dart';
import '../model/login_response_model.dart';
import '../model/utilities_model.dart';
// class BluetoothInfo {
//   final String name;
//   final String macAdress;

//   BluetoothInfo({required this.name, required this.macAdress});

//   factory BluetoothInfo.fromJson(Map<String, dynamic> json) {
//     return BluetoothInfo(
//       name: json['name'] ?? '',
//       macAdress: json['macAdress'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'macAdress': macAdress,
//     };
//   }
// }

class AppProvider with ChangeNotifier {
  bool isConnected = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setSignInUser(bool isSignIn, String? userInfo, String token) async {
    await sharedPreferences.setBool(Strings.IS_USER_SIGNED_IN, isSignIn);
    await sharedPreferences.setString(Strings.Token, token);
    if (userInfo != null) {
      await sharedPreferences.setString(Strings.USER_INFO, userInfo);
    }
  }

  setOldPassword(String password) async {
    await sharedPreferences.setString(Strings.OLD_PASSWORD, password);
  }

  setAgreeNotification(bool isAgreeNotification) async {
    await sharedPreferences.setBool(
        Strings.IS_USER_AGREE_NOTI, isAgreeNotification);
  }

  setFirebaseToken(String firebaseToken) async {
    await sharedPreferences.setString(Strings.FIREBASE_TOKEN, firebaseToken);
  }

 Future<void> saveBluetoothDevice(BluetoothInfo device) async {
  await sharedPreferences.setString(
    Strings.BluetoothDevice,
    jsonEncode({
      'name': device.name,
      'macAdress': device.macAdress,
    }),
  );
}

  // BluetoothDevice? getBluetoothDevice() {
  //   String? bluetoothDevice =
  //       sharedPreferences.getString(Strings.BluetoothDevice);

  //   if (bluetoothDevice != null) {
  //     BluetoothDevice bluetoothDeviceModel =
  //         BluetoothDevice.fromMap(json.decode(bluetoothDevice));

  //     return bluetoothDeviceModel;
  //   } else {
  //     return null;
  //   }
  // }

BluetoothInfo? getBluetoothDevice() {
  final data = sharedPreferences.getString(Strings.BluetoothDevice);

  if (data == null || data.isEmpty) {
    return null;
  }

  final Map<String, dynamic> jsonData = jsonDecode(data);

  return BluetoothInfo(
    name: jsonData['name']?.toString() ?? '',
    macAdress: jsonData['macAdress']?.toString() ?? '',
  );
}
// BluetoothInfo? getBluetoothDevice() {
//   String? data = sharedPreferences.getString(Strings.BluetoothDevice);
//   if (data != null) {
//     return BluetoothInfo.fromJson(json.decode(data));
//   }
//   return null;
// }


  enableDisablePrintAfterDirectOrder(bool enable) async {
    await sharedPreferences.setBool(Strings.EnablePrintAuto, enable);
  }

  getEnablePrintAuto() {
    if (sharedPreferences.getBool(Strings.EnablePrintAuto) == null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.EnablePrintAuto);
  }

  enableMerchantNamePrint(bool enable) async {
    await sharedPreferences.setBool(Strings.EnableMerchantNamePrint, enable);
  }

  getEnableMerchantNamePrint() {
    if (sharedPreferences.getBool(Strings.EnableMerchantNamePrint) == null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.EnableMerchantNamePrint);
  }

  setSignOutUser() async {
    await sharedPreferences.remove(Strings.IS_USER_SIGNED_IN);
    await sharedPreferences.remove(Strings.USER_INFO);
    await sharedPreferences.remove(Strings.Token);
  }

  LoginResponseModel? getUserInfo() {
    String? userInfo = sharedPreferences.getString(Strings.USER_INFO);
    if (userInfo != null) {
      LoginResponseModel signInModel =
          LoginResponseModel.fromJson(json.decode(userInfo));

      return signInModel;
    } else {
      return null;
    }
  }

  Future<bool> isUserSigned() async {
    if (sharedPreferences.getBool(Strings.IS_USER_SIGNED_IN) == null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.IS_USER_SIGNED_IN)!;
  }

  Future<String> getOldPassword() async {
    if (sharedPreferences.getString(Strings.OLD_PASSWORD) == null) {
      return "";
    }
    return sharedPreferences.getString(Strings.OLD_PASSWORD)!;
  }

  Future<bool> isUserAgreeNotification() async {
    if (sharedPreferences.getBool(Strings.IS_USER_AGREE_NOTI) == null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.IS_USER_AGREE_NOTI)!;
  }

  Future<String> getFirebaseToken() async {
    if (sharedPreferences.getString(Strings.FIREBASE_TOKEN) == null) {
      return "";
    }
    return sharedPreferences.getString(Strings.FIREBASE_TOKEN)!;
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    isConnected = connectivityResult != ConnectivityResult.none;

    return isConnected;
  }

  TerritoriesModel? _territoriesModel;

  TerritoriesModel? get territoriesModel => _territoriesModel;

  set territoriesModel(TerritoriesModel? value) {
    _territoriesModel = value;
    notifyListeners();
  }

  Future<TerritoriesModel?> getTerritories() async {
    restApi mRestApi = restApi(Dio());
    try {
      territoriesModel = await mRestApi.getTerritories();
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        try {
          throwCustomException(e);
        } catch (forcedException) {
          return territoriesModel = null;
        }
      }
      return territoriesModel = null;
    }
    isLoading = false;

    return territoriesModel;
  }

  UtilitiesModel? _utilitiesModel;

  UtilitiesModel? get utilitiesModel => _utilitiesModel;

  set utilitiesModel(UtilitiesModel? value) {
    _utilitiesModel = value;
    notifyListeners();
  }

  AppVersionModel? _appVersionModel;

  AppVersionModel? get appVersionModel => _appVersionModel;

  set appVersionModel(AppVersionModel? value) {
    _appVersionModel = value;
    notifyListeners();
  }

  Future<TerritoriesModel?> getUtilities() async {
    restApi mRestApi = restApi(Dio());
    try {
      utilitiesModel = await mRestApi.getUtilities();
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        try {
          throwCustomException(e);
        } catch (forcedException) {
          return utilitiesModel = null;
        }
      }
      return utilitiesModel = null;
    }
    isLoading = false;

    return territoriesModel;
  }

  Future<AppVersionModel?> getAppVersion() async {
    restApi mRestApi = restApi(Dio());
    try {
      appVersionModel = await mRestApi.getAppVersion();
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        try {
          throwCustomException(e);
        } catch (forcedException) {
          return appVersionModel = null;
        }
      }
      return appVersionModel = null;
    }
    isLoading = false;

    return appVersionModel;
  }

  AgentModel? _agentModel;

  AgentModel? get agentModel => _agentModel;

  set agentModel(AgentModel? value) {
    _agentModel = value;
    notifyListeners();
  }

  Future<AgentModel?> getAgentCustomers() async {
    restApi mRestApi = restApi(Dio());
    try {
      agentModel = await mRestApi.getAgentCustomers();
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        try {
          throwCustomException(e);
        } catch (forcedException) {
          return agentModel = null;
        }
      }
      return agentModel = null;
    }
    isLoading = false;

    return agentModel;
  }

  CustomerModel? _customerModel;

  CustomerModel? get customerModel => _customerModel;

  set customerModel(CustomerModel? value) {
    _customerModel = value;
    notifyListeners();
  }

  Future<CustomerModel?> getAgentCustomersList() async {
    restApi mRestApi = restApi(Dio());
    try {
      customerModel = await mRestApi.getAgentCustomersList();
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        try {
          throwCustomException(e);
        } catch (forcedException) {
          return customerModel = null;
        }
      }
      return customerModel = null;
    }
    isLoading = false;

    return customerModel;
  }

  Future<ApiResponse<LoginResponseModel>> signUp(
      String registerRequestModel) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<LoginResponseModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        LoginResponseModel registerResponseModel =
            await mRestApi.signUp(registerRequestModel);
        apiResponse = ApiResponse.completed(registerResponseModel);
      } catch (e) {
        isLoading = false;
        if (e is DioException) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }

  Future<ApiResponse<LoginResponseModel>> signIn(
      String email, String password) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<LoginResponseModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        LoginResponseModel loginResponseModel =
            await mRestApi.signIn(email, password);
        if (loginResponseModel.message == 'User disabled or missing') {
          apiResponse =
              ApiResponse<LoginResponseModel>.error(loginResponseModel.message);
        } else {
          apiResponse =
              ApiResponse<LoginResponseModel>.completed(loginResponseModel);
        }
      } catch (e) {
        isLoading = false;
        if (e is DioException) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }

  Future<ApiResponse<ResponseModel>> resetPassword(String email) async {
    ExtraResitApi extraResitApi = ExtraResitApi();
    late ApiResponse<ResponseModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        ResponseModel responseModel = await extraResitApi.resetPassword(email);
        if (responseModel.statusCode == 200) {
          apiResponse = ApiResponse<ResponseModel>.completed(responseModel);
        } else {
          apiResponse = ApiResponse<ResponseModel>.error(responseModel.message);
        }
      } catch (e) {
        isLoading = false;
        if (e is DioException) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }

  Future<ApiResponse<UpdateTokenModel>> sendUpdateToken(String token,
      String userId, String userDeviceType, String userDeviceName) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<UpdateTokenModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        UpdateTokenModel updateTokenModel = await mRestApi.updateToken(
            token, userId, userDeviceType, userDeviceName);
        apiResponse = ApiResponse<UpdateTokenModel>.completed(updateTokenModel);
      } catch (e) {
        isLoading = false;
        if (e is DioException) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }
}

dynamic throwCustomException(DioException? dioError) {
  var statusCode = dioError?.response?.statusCode;
  switch (dioError!.type) {
    case DioExceptionType.cancel:
      throw RequestWasCancelledException("CANCEL");
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeout("CONNECT_TIMEOUT");
    case DioExceptionType.unknown:
      throw DefaultTimeout("DEFAULT");
    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeout("RECEIVE_TIMEOUT");
    case DioExceptionType.sendTimeout:
      throw SendTimeout("SEND_TIMEOUT");
    case DioExceptionType.badResponse:
      throw BadRequestException(dioError.response?.data["error"]);
    default:
      throw FetchDataException('Error occurred while Communication with Server '
          'with StatusCode : $statusCode');
  }
}
