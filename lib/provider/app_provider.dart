import 'dart:async';
import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/Network/app_exceptions.dart';
import 'package:jocards/Network/resit_api.dart';
import 'package:jocards/model/app_version_model.dart';
import 'package:jocards/model/register_request_model.dart';
import 'package:jocards/model/register_response_model.dart';
import 'package:jocards/model/territories_model.dart';
import 'package:jocards/utill/strings.dart';

import '../main.dart';
import '../model/agent_model.dart';
import '../model/login_response_model.dart';
import '../model/utilities_model.dart';

class AppProvider with ChangeNotifier {
  bool isConnected = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late String _imei;

  String get imei => _imei;

  set imei(String value) {
    _imei = value;
  }

  setSignInUser(bool isSignIn, String? userInfo, String token) async {
    await sharedPreferences.setBool(Strings.IS_USER_SIGNED_IN, isSignIn);
    await sharedPreferences.setString(Strings.Token, token);
    if(userInfo!=null) {
      await sharedPreferences.setString(Strings.USER_INFO, userInfo);
    }
  }

  saveBluetoothDevice(String bluetoothDevice)async {
    await sharedPreferences.setString(Strings.BluetoothDevice, bluetoothDevice);
  }

  BluetoothDevice? getBluetoothDevice()  {
    String ?bluetoothDevice =   sharedPreferences.getString(Strings.BluetoothDevice );

    if(bluetoothDevice!=null){
      BluetoothDevice bluetoothDeviceModel= BluetoothDevice.fromMap(json.decode(bluetoothDevice)) ;

      return bluetoothDeviceModel;
    }
    else{
      return null;
    }}

  enableDisablePrintAfterDirectOrder(bool enable)async{
    await sharedPreferences.setBool(Strings.EnablePrintAuto, enable);
  }

  getEnablePrintAuto(){
    if(sharedPreferences.getBool(Strings.EnablePrintAuto )==null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.EnablePrintAuto );
  }

  enableMerchantNamePrint(bool enable)async{
    await sharedPreferences.setBool(Strings.EnableMerchantNamePrint, enable);
  }
  getEnableMerchantNamePrint(){
    if(sharedPreferences.getBool(Strings.EnableMerchantNamePrint )==null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.EnableMerchantNamePrint );
  }

  setSignOutUser() async {
    await sharedPreferences.remove(Strings.IS_USER_SIGNED_IN);
    await sharedPreferences.remove(Strings.USER_INFO);
    await sharedPreferences.remove(Strings.Token);
  }

  LoginResponseModel? getUserInfo()  {
    String ?userInfo =   sharedPreferences.getString(Strings.USER_INFO );
    if(userInfo!=null){
      LoginResponseModel signInModel= LoginResponseModel.fromJson(json.decode(userInfo));

      return signInModel;
    }
    else{
      return null;
    }

  }
  Future<bool> isUserSigned() async {
    if (sharedPreferences.getBool(Strings.IS_USER_SIGNED_IN) == null) {
      return false;
    }
    return sharedPreferences.getBool(Strings.IS_USER_SIGNED_IN)!;
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
    } catch (e, stackTrace) {
      isLoading = false;
      if (e is DioError) {
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
  UtilitiesModel? _UtilitiesModel;

  UtilitiesModel? get utilitiesModel => _UtilitiesModel;

  set utilitiesModel(UtilitiesModel? value) {
    _UtilitiesModel = value;
    notifyListeners();}

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
    } catch (e, stackTrace) {
      isLoading = false;
      if (e is DioError) {
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
    } catch (e, stackTrace) {
      isLoading = false;
      if (e is DioError) {
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


  AgentModel? _AgentModel;

  AgentModel? get agentModel => _AgentModel;

  set agentModel(AgentModel? value) {
    _AgentModel = value;
    notifyListeners();}
  Future<AgentModel?> getAgentCustomers() async {
    restApi mRestApi = restApi(Dio());
    try {
      agentModel = await mRestApi.getAgentCustomers();
    } catch (e, stackTrace) {
      isLoading = false;
      if (e is DioError) {
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


    Future<ApiResponse<LoginResponseModel>> signUp(
        String registerRequestModel) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<LoginResponseModel> apiResponse;

    if(await checkInternet()) {
      isLoading = true;

      try {

        LoginResponseModel registerResponseModel = await mRestApi.signUp( registerRequestModel);
        apiResponse=ApiResponse.completed(registerResponseModel);
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    }
    else{
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }


  Future<ApiResponse<LoginResponseModel>> signIn(
      String email, String password) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<LoginResponseModel> apiResponse;

    if(await checkInternet()) {
      isLoading = true;

      try {

        LoginResponseModel loginResponseModel = await mRestApi.signIn(email, password);
        if(loginResponseModel.message=='User disabled or missing'){
          apiResponse = ApiResponse<LoginResponseModel>.error(loginResponseModel.message);
        }
        else{
          apiResponse = ApiResponse<LoginResponseModel>.completed(loginResponseModel);
        }
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    }
    else{
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }

}

dynamic throwCustomException(DioError? dioError) {
  var response = dioError?.response?.data;
  var statusCode = dioError?.response?.statusCode;
  switch (dioError!.type) {
    case DioErrorType.cancel:
      throw RequestWasCancelledException("CANCEL");
      break;
    case DioErrorType.connectTimeout:
      throw ConnectionTimeout("CONNECT_TIMEOUT");
      break;
    case DioErrorType.other:
      throw DefaultTimeout("DEFAULT");
      break;
    case DioErrorType.receiveTimeout:
      throw ReceiveTimeout("RECEIVE_TIMEOUT");
      break;
    case DioErrorType.sendTimeout:
      throw SendTimeout("SEND_TIMEOUT");
      break;
    case DioErrorType.response:
      switch (statusCode) {
        case 400:
          throw BadRequestException(dioError.response?.data["error"]);
          break;
        case 401:
        case 403:
          throw UnauthorisedException(dioError.response?.data["message"]);
          break;
        case 404:
          throw FetchDataException(
              'Error while Communication with Server with StatusCode : ${dioError.response?.statusMessage}');
          break;
        case 500:

        default:
          throw FetchDataException(
              'Error while Communication with Server with StatusCode : ${dioError.response?.statusMessage}');
      }
      break;
  }
}
