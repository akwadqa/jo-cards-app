import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/model/app_message_model.dart';
import 'package:jocards/model/direct_order_response.dart';
import 'package:jocards/model/home_model.dart';
import 'package:jocards/model/invoice_order_details.dart';
import 'package:jocards/model/item_category_model.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/model/payment_model.dart';
import 'package:jocards/model/response_model.dart';
import 'package:jocards/model/sales_invoice_response_model.dart';
import 'package:jocards/model/territories_model.dart';
import 'package:jocards/model/update_password_model.dart';
import 'package:jocards/model/update_token_model.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../main.dart';
import '../model/agent_model.dart';
import '../model/agent_payment_entry_response.dart';
import '../model/app_version_model.dart';
import '../model/categories_model.dart';
import '../model/direct_wallet_request_log_model.dart';
import '../model/products_details_model.dart';
import '../model/sales_order_details.dart';
import '../model/shipping_order_response_model.dart';
import '../model/transfer_shipping_response_model.dart';
import '../model/upload_response_model.dart';
import '../model/utilities_model.dart';
import '../provider/app_provider.dart';
import '../screens/auth/sign_in_screen.dart';
import '../utill/utitlities.dart';
part 'resit_api.g.dart';

// @RestApi(baseUrl: "https://app.jocards.com/api/")
@RestApi(baseUrl: "https://jocards.akwad.qa/api/")
// @RestApi(baseUrl: "https://www.jocards.com/api/")
abstract class restApi {
  factory restApi(Dio dio, {BuildContext? context, String? baseUrl}) {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      options.connectTimeout = const Duration(milliseconds: 60000);
      options.receiveTimeout = const Duration(milliseconds: 60000);
      var customHeaders = {
        'content-type': 'application/json',
        if (sharedPreferences.getString(Strings.Token) != null)
          'Authorization':
              'token ${sharedPreferences.getString(Strings.Token)}',
      };

      options.headers.addAll(customHeaders);

      return handler.next(options);
    }, onResponse:
            (Response response, ResponseInterceptorHandler handler) async {
      if (response.data['status_code'] == 401 &&
          response.data['message'] == 'token invalid') {
        if (sharedPreferences.getString(Strings.Token) != null) {
          Fluttertoast.showToast(
              backgroundColor: ColorResources.studio,
              textColor: Colors.white,
              msg: 'انتهت صلاحية جلستك الرجاء تسجيل الدخول مرة اخرى',
              timeInSecForIosWeb: 10,
              toastLength: Toast.LENGTH_LONG);
          await Provider.of<AppProvider>(navigator.currentContext!,
                  listen: false)
              .setSignOutUser();

          Navigator.of(navigator.currentContext!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignInScreen()),
              (Route<dynamic> route) => false);
        }
      }
      return handler.next(response);
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      await forceSignOut(error);
      return handler.next(error);
    }));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
          responseBody: true,
          requestBody: true,
          logPrint: (logData) {
            log(logData.toString());
          }));
    }

    return _restApi(dio, baseUrl: baseUrl);
  }

  @GET('method/jocards_v2.smart_api.get_home_block')
  Future<HomeModel> getHome(@Query('platform') String platform);

  @GET('method/jocards_v2.smart_api.get_territories')
  Future<TerritoriesModel> getTerritories();
  @GET('method/jocards_v2.smart_api.get_items_of_categories')
  Future<ItemCategoryModel> getItemsOfCategory(
      @Query('category') String category, @Query('platform') String platform);

  @GET('method/jocards_v2.smart_api.get_product_details')
  Future<ProductsDetailsModel> getProductDetails(
      @Query('website_item_id') String id);

  @POST('method/jocards_v2.smart_api.app_login')
  Future<LoginResponseModel> signIn(
      @Field("usr") String user, @Field("pwd") String password);

  @POST('method/jocards_v2.smart_api.register')
  Future<LoginResponseModel> signUp(@Field("data") String registerRequestModel);

  @POST('method/jocards_v2.smart_api.direct_order')
  Future<DirectOrderResponse> directOrder(
      @Field("items") String directOrderList);

  @GET('method/jocards_v2.smart_api.get_utilities')
  Future<UtilitiesModel> getUtilities();

  @GET('method/jocards_v2.smart_api.get_agent_customers')
  Future<AgentModel> getAgentCustomers();
  @GET('method/jocards_v2.smart_api.filter_dwr')
  Future<ShippingOrderResponseModel> getShippingOrders(
      @Query('page_no') int pageNo, @Query('filters') String filter);
  @GET('method/jocards_v2.smart_api.filter_si')
  Future<SalesInvoiceResponseModel> getSalesOrders(
      @Query('page_no') int pageNo, @Query('filters') String filter);
  @GET('method/jocards_v2.smart_api.get_categories')
  Future<CategoriesModel> getAllCategories();

  @GET('method/jocards_v2.smart_api.filter_dwrl')
  Future<DirectWalletRequestLogModel> getDWRLog(
      @Query('page_no') int pageNo, @Query('filters') String filter);

  @GET('method/jocards_v2.smart_api.get_sales_order_detail')
  Future<SalesOrderDetails> getSalesOrderDetails(
      @Query("sales_order_id") String salesOrderId);

  @GET('method/jocards_v2.smart_api.get_sales_invoce_details')
  Future<SalesInvoiceDetails> getSalesInvoiceDetails(
      @Query("sales_invoice_id") String salesInvoiceId);

  @POST('method/jocards_v2.smart_api.dwr_request_and_transfer')
  Future<TransferShippingResponseModel> requestTransferShipping(
      {@Field('units') String? units, @Field('customer') String? customerName});

  @POST('resource/run_custom_method')
  Future<UploadResponseModel> uploadReceipt(
      {@Field('cmd') String? cmd,
      @Field('doctype') String? doctype,
      @Field('docname') String? docname,
      @Field('filename') String? fileName,
      @Field('filedata') String? fileData,
      @Field('from_form') int? fromForm});

  @POST('method/jocards_v2.smart_api.agent_payment_entry')
  Future<AgentPaymentEntryResponse> agentPaymentEntry(
      @Field('dwr') String dwr, @Field('paid_amount') String paidAmount);

  @POST('method/jocards_v2.smart_api.dwr_approval')
  Future<ResponseModel> dwrApproval(
      @Field('dwr') String dwr, @Field('status') String status);

  @GET('method/jocards_v2.smart_api.app_version')
  Future<AppVersionModel> getAppVersion();

  @GET("method/jocards_v2.smart_api.payments")
  Future<PaymentModel> getPaymentModel(
    @Query('filters') String filter,
    @Query('page_no') int pageNo,
  );

  @GET("method/jocards_v2.app_message.app_messages")
  Future<AppMessageModel> getAppMessage(
    @Query('page_no') int pageNo,
  );

  // @POST("method/jocards_v2.smart_api.password_reset")
  // Future<ResponseModel> resetPassword(@Query('user') String email);

  // @POST("method/jocards_v2.smart_api.update_profile")
  // @MultiPart()
  // Future<ResponseModel> updateProfile(@Part(name: "file") File? file, @Part(name: "data") String? data);

  @POST("method/frappe.core.doctype.user.user.update_password")
  Future<UpdatePasswordModel> updatePassword(
      @Field("old_password") String oldPassword,
      @Field("new_password") String newPassword);

  @POST("method/fcm_frappe.api.device_token")
  Future<UpdateTokenModel> updateToken(
      @Field("device_token") String token,
      @Field("user_id") String userId,
      @Field("user_device_type") String userDeviceType,
      @Field("user_device_name") String userDeviceName);
}

// @RestApi(baseUrl: "https://tbd.akwad.qa/api/")
// abstract class notiicationApi{
//   factory notiicationApi(Dio dio, {BuildContext ?context, String ?baseUrl}) {
//     dio.interceptors
//         .add(InterceptorsWrapper(onRequest: (RequestOptions  options,RequestInterceptorHandler handler) {
//       options.connectTimeout = 60000;
//       options.receiveTimeout = 60000;
//
//       return handler.next(options);
//     },onResponse: (Response response,ResponseInterceptorHandler handler) async {
//       if(response.data['status_code'] == 401 && response.data['message'] == 'token invalid'){
//         // if(sharedPreferences.getString(Strings.Token)!=null){
//         //   Fluttertoast.showToast(
//         //       backgroundColor: Colors.red,
//         //       textColor: Colors.white,
//         //       msg: 'انتهت صلاحية جلستك الرجاء تسجيل الدخول مرة اخرى',
//         //       timeInSecForIosWeb: 10,
//         //       toastLength: Toast.LENGTH_LONG);
//         //   await Provider.of<AppProvider>(navigator.currentContext!,listen:false).setSignOutUser();
//         //
//         //
//         //   Navigator.of(navigator.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//         //       SignInScreen()), (Route<dynamic> route) => false);
//         // }
//       }
//       return handler.next(response);
//     }, onError: (DioError error,ErrorInterceptorHandler handler) async {
//       await forceSignOut(error);
//       return  handler.next(error);
//     }));
//
//     if(kDebugMode){
//       dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true, logPrint: (logData) {
//         log(logData.toString());
//       }));
//     }
//
//     return _notiicationApi(dio, baseUrl: baseUrl);
//   }
//
//   @POST("method/fcm_frappe.api.device_token")
//   Future<UpdateTokenModel> updateToken(@Field("device_token") String token, @Field("user_id") String userId);
//
// }