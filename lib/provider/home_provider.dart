import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/Network/app_exceptions.dart';
import 'package:jocards/Network/extra_resit_api.dart';
import 'package:jocards/Network/resit_api.dart';
import 'package:jocards/model/agent_payment_entry_response.dart';
import 'package:jocards/model/app_message_model.dart';
import 'package:jocards/model/direct_order_response.dart';
import 'package:jocards/model/home_model.dart';
import 'package:jocards/model/invoice_order_details.dart';
import 'package:jocards/model/payment_model.dart';
import 'package:jocards/model/response_model.dart';
import 'package:jocards/model/sales_invoice_response_model.dart';
import 'package:jocards/model/update_password_model.dart';
import 'package:jocards/model/update_profile_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/shipping_order_history.dart';
import 'package:jocards/utill/strings.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/categories_model.dart';
import '../model/direct_order_request_model.dart';
import '../model/direct_wallet_request_log_model.dart';
import '../model/item_category_model.dart';
import '../model/products_details_model.dart';
import '../model/sales_order_details.dart';
import '../model/sales_order_response_model.dart';
import '../model/shipping_order_response_model.dart';
import '../model/transfer_shipping_response_model.dart';
import '../model/upload_response_model.dart';

class HomeProvider extends AppProvider {
  ApiResponse<HomeModel>? _homeResponse;

  ApiResponse<HomeModel>? get homsResponse => _homeResponse;

  set homsResponse(ApiResponse<HomeModel>? value) {
    _homeResponse = value;
    notifyListeners();
  }

  ApiResponse<ItemCategoryModel>? _ItemCategoryResponse;

  ApiResponse<ItemCategoryModel>? get itemCategoryResponse =>
      _ItemCategoryResponse;

  set itemCategoryResponse(ApiResponse<ItemCategoryModel>? value) {
    _ItemCategoryResponse = value;
    notifyListeners();
  }

  ApiResponse<ProductsDetailsModel>? _productDetailsResponse;

  ApiResponse<ProductsDetailsModel>? get productDetailsResponse =>
      _productDetailsResponse;

  set productDetailsResponse(ApiResponse<ProductsDetailsModel>? value) {
    _productDetailsResponse = value;
    notifyListeners();
  }

  ApiResponse<ShippingOrderResponseModel>? _ShippingOrderResponse;

  ApiResponse<ShippingOrderResponseModel>? get shippingOrderResponse =>
      _ShippingOrderResponse;

  set shippingOrderResponse(ApiResponse<ShippingOrderResponseModel>? value) {
    _ShippingOrderResponse = value;
    notifyListeners();
  }

  // ApiResponse<SalesOrderResponseModel>? _SalesOrderResponse;
  //
  // ApiResponse<SalesOrderResponseModel>? get salesOrderResponse =>
  //     _SalesOrderResponse;
  //
  // set salesOrderResponse(ApiResponse<SalesOrderResponseModel>? value) {
  //   _SalesOrderResponse = value;
  //   notifyListeners();
  // }

  ApiResponse<SalesInvoiceResponseModel>? _SalesInvoiceResponse;

  ApiResponse<SalesInvoiceResponseModel>? get salesInvoiceResponse =>
      _SalesInvoiceResponse;

  set salesInvoiceResponse(ApiResponse<SalesInvoiceResponseModel>? value) {
    _SalesInvoiceResponse = value;
    notifyListeners();
  }

  ApiResponse<AgentPaymentEntryResponse>? _agentPaymentEntryResponse;

  ApiResponse<AgentPaymentEntryResponse>? get agentPaymentEntryResponse => _agentPaymentEntryResponse;

  set agentPaymentEntryResponse(ApiResponse<AgentPaymentEntryResponse>? value) {
    _agentPaymentEntryResponse = value;
    notifyListeners();
  }

  ApiResponse<ResponseModel>? _apiResponse;

  ApiResponse<ResponseModel>? get apiResponse => _apiResponse;

  set apiResponse(ApiResponse<ResponseModel>? value) {
    _apiResponse = value;
    notifyListeners();
  }

  ApiResponse<UpdateProfileModel>? _apiUpdateProfileResponse;

  ApiResponse<UpdateProfileModel>? get apiUpdateProfileResponse => _apiUpdateProfileResponse;

  set apiUpdateProfileResponse(ApiResponse<UpdateProfileModel>? value) {
    _apiUpdateProfileResponse = value;
    notifyListeners();
  }

  ApiResponse<UpdatePasswordModel>? _updatePasswordModel;

  ApiResponse<UpdatePasswordModel>? get updatePasswordModel => _updatePasswordModel;

  set updatePasswordModel(ApiResponse<UpdatePasswordModel>? value) {
    _updatePasswordModel = value;
    notifyListeners();
  }

  List<HomeBlockData>? _categoriesList = [];

  List<HomeBlockData>? get categoriesList => _categoriesList;

  set categoriesList(List<HomeBlockData>? value) {
    _categoriesList = value;
    notifyListeners();
  }

  Future<ApiResponse<HomeModel>> getHomePage() async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      homsResponse = ApiResponse.loading("");
      try {
        HomeModel homeModel = await mRestApi.getHome();
        if (homeModel.homeBlock != null && homeModel.homeBlock!.isNotEmpty) {
          for (HomeBlock homeBlock in homeModel.homeBlock!) {
            if (homeBlock.type == "Categories") {
              for (HomeBlockData homeBlockData in homeBlock.data!) {
                categoriesList!.add(homeBlockData);
              }
            }
          }
        }
        // homeModel.homeBlock!.insert(0, HomeBlock(id: "0", title: "Wallet", type: "Wallet", ));
        homsResponse = ApiResponse.completed(homeModel);
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return homsResponse = ApiResponse.error(forcedException.toString());
          }
        }
        return homsResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return homsResponse = ApiResponse.error("No Internet Connection");
    }
    return homsResponse!;
  }

  Future<ApiResponse<ItemCategoryModel>> getItemPerCat(String catName) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      itemCategoryResponse = ApiResponse.loading("");
      try {
        ItemCategoryModel itemCategoryModel =
            await mRestApi.getItemsOfCategory(catName);

        itemCategoryResponse = ApiResponse.completed(itemCategoryModel);
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return itemCategoryResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return itemCategoryResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return itemCategoryResponse = ApiResponse.error("No Internet Connection");
    }
    return itemCategoryResponse!;
  }

  Future<ApiResponse<ProductsDetailsModel>> getProductDetails(String id) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      productDetailsResponse = ApiResponse.loading("");
      try {
        ProductsDetailsModel productsDetailsModel =
            await mRestApi.getProductDetails(id);

        productDetailsResponse = ApiResponse.completed(productsDetailsModel);
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return productDetailsResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return productDetailsResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return productDetailsResponse =
          ApiResponse.error("No Internet Connection");
    }
    return productDetailsResponse!;
  }
  getDirectOrder( List<DirectOrderRequest> directOrderRequest) async{
      return await directOrder(directOrderRequest);
  }
  Future<ApiResponse<DirectOrderResponse>> directOrder(
      List<DirectOrderRequest> directOrderRequest) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<DirectOrderResponse> directOrderResponse;
    if (await checkInternet()) {
      isLoading = true;
      try {
        DirectOrderResponse directOrder =
            await mRestApi.directOrder(json.encode(directOrderRequest));

        if(directOrder.error == 1){
          isLoading = false;
          directOrderResponse = ApiResponse.error(directOrder.message);
        }
        if(directOrder.error == 2 ){
          Fluttertoast.showToast(msg: "ضغط على الشبكة الرجاء الانتظار");
          await getDirectOrder(directOrderRequest);
        }
        else{
          directOrderResponse = ApiResponse.completed(directOrder);
        }
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return directOrderResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return directOrderResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return directOrderResponse = ApiResponse.error("No Internet Connection");
    }
    return directOrderResponse;
  }

  Future<ApiResponse<TransferShippingResponseModel>> requestTransferShipping(
      String units,
      {String? customerName}) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<TransferShippingResponseModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        TransferShippingResponseModel transferShippingResponseModel =
            await mRestApi.requestTransferShipping(
                units: units, customerName: customerName);
        if(transferShippingResponseModel.statusCode != 403){
          apiResponse = ApiResponse.completed(transferShippingResponseModel);
        }
        else{
          apiResponse = ApiResponse.error(transferShippingResponseModel.message);
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
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }


  Future<ApiResponse<UploadResponseModel>> uploadReceipt(
      String fileName,String docname,
      {String? fileData}) async {
    restApi mRestApi = restApi(Dio());
    late ApiResponse<UploadResponseModel> apiResponse;

    if (await checkInternet()) {
      isLoading = true;

      try {
        UploadResponseModel uploadResponseModel =
        await mRestApi.uploadReceipt(
           cmd: "uploadfile",doctype: "Digital Wallet Request",docname:docname,fileData: fileData,fileName: fileName,fromForm: 1);
        apiResponse = ApiResponse.completed(uploadResponseModel);
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
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse;
  }


  ApiResponse<CategoriesModel>? _CategoriesModelrResponse;

  ApiResponse<CategoriesModel>? get categoriesModelResponse =>
      _CategoriesModelrResponse;

  set categoriesModelResponse(ApiResponse<CategoriesModel>? value) {
    _CategoriesModelrResponse = value;
    notifyListeners();
  }

  // ApiResponse<SalesOrderDetails> ? _SalesOrderDetailsResponse;
  //
  // ApiResponse<SalesOrderDetails> ? get salesOrderDetailsResponse =>
  //     _SalesOrderDetailsResponse;
  //
  // set salesOrderDetailsResponse(ApiResponse<SalesOrderDetails> ? value) {
  //   _SalesOrderDetailsResponse = value;
  //   notifyListeners();
  // }

  ApiResponse<SalesInvoiceDetails> ? _SalesInvoiceDetailsResponse;

  ApiResponse<SalesInvoiceDetails> ? get salesInvoiceDetailsResponse =>
      _SalesInvoiceDetailsResponse;

  set salesInvoiceDetailsResponse(ApiResponse<SalesInvoiceDetails> ? value) {
    _SalesInvoiceDetailsResponse = value;
    notifyListeners();
  }

   Future<ApiResponse<CategoriesModel>> getAllCategories() async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      categoriesModelResponse = ApiResponse.loading("");
      try {
        CategoriesModel categoriesModel =
            await mRestApi.getAllCategories();

        categoriesModelResponse = ApiResponse.completed(categoriesModel);
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return categoriesModelResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return categoriesModelResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return categoriesModelResponse = ApiResponse.error("No Internet Connection");
    }
    return categoriesModelResponse!;
  }

  List<String>  _items = [];
  List<String> get items => _items;
  set setItems(List<String> value){
    _items = value;
    notifyListeners();
  }

  // Future<ApiResponse<SalesOrderDetails>> getPurchaseOrderDetails(String id) async {
  //   restApi mRestApi = restApi(Dio());
  //   if (await checkInternet()) {
  //     isLoading = false;
  //
  //     salesOrderDetailsResponse = ApiResponse.loading("");
  //     try {
  //       SalesOrderDetails salesOrderDetails =
  //       await mRestApi.getSalesOrderDetails(id);
  //
  //       if(salesOrderDetails.error == 1){
  //         isLoading = false;
  //         salesOrderDetailsResponse = ApiResponse.error(salesOrderDetails.message);
  //       }
  //       else{
  //         salesOrderDetailsResponse = ApiResponse.completed(salesOrderDetails);
  //       }
  //     } catch (e, stackTrace) {
  //       isLoading = false;
  //       if (e is DioError) {
  //         try {
  //           throwCustomException(e);
  //         } catch (forcedException) {
  //           return salesOrderDetailsResponse =
  //               ApiResponse.error(forcedException.toString());
  //         }
  //       }
  //       return salesOrderDetailsResponse = ApiResponse.error(e.toString());
  //     }
  //     isLoading = false;
  //   } else {
  //     return salesOrderDetailsResponse = ApiResponse.error("No Internet Connection");
  //   }
  //   return salesOrderDetailsResponse!;
  // }

  Future<ApiResponse<SalesInvoiceDetails>> getPurchaseInvoiceDetails(String id) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      isLoading = false;

      salesInvoiceDetailsResponse = ApiResponse.loading("");
      try {
        SalesInvoiceDetails salesInvoiceDetails =
        await mRestApi.getSalesInvoiceDetails(id);

        if(salesInvoiceDetails.error == 1){
          isLoading = false;
          salesInvoiceDetailsResponse = ApiResponse.error(salesInvoiceDetails.message);
        }
        else{
          salesInvoiceDetailsResponse = ApiResponse.completed(salesInvoiceDetails);
        }
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return salesInvoiceDetailsResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return salesInvoiceDetailsResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return salesInvoiceDetailsResponse = ApiResponse.error("No Internet Connection");
    }
    return salesInvoiceDetailsResponse!;
  }

  PagingController<int, ShippingOrdeData>? shippingOrdersPagingController;
  // PagingController<int, SalesOrderData>? salesOrdersDataPagingController;
  PagingController<int, SalesInvoiceData>? salesInvoiceDataPagingController;
  PagingController<int, MessageData>? appMessageDataPagingController;
  PagingController<int, DirectWalletRequestLogData>? dwrLogPagingController;
  PagingController<int, GLEntries>? paymentLogPagingController;
  ShippingOrderResponseModel? _shippingOrderResponseModel;
  ShippingOrderResponseModel? get shippingOrderResponseModelVar => _shippingOrderResponseModel;
  set shippingOrderResponseModelVar(ShippingOrderResponseModel? value){
    _shippingOrderResponseModel = value;
    notifyListeners();
  }

  DirectWalletRequestLogModel? _directWalletRequestLogModel;
  DirectWalletRequestLogModel? get directWalletRequestLogModelVar => _directWalletRequestLogModel;
  set directWalletRequestLogModelVar (DirectWalletRequestLogModel? value){
    _directWalletRequestLogModel = value;
    notifyListeners();
  }

  PaymentData? _paymentModel;
  PaymentData? get paymentModel => _paymentModel;
  set paymentModel (PaymentData? value){
    _paymentModel = value;
    notifyListeners();
  }

  Future<void> fetchShippingOrders(int pageKey, BuildContext context, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      ShippingOrderResponseModel shippingOrderResponseModel =
          await mRestApi.getShippingOrders(pageKey, filters);
      if (shippingOrderResponseModel.data != null) {
        final isLastPage = shippingOrderResponseModel.data!.isEmpty;
        final List<ShippingOrdeData> list = shippingOrderResponseModel.data!;
        if (isLastPage) {
          shippingOrdersPagingController!
              .appendLastPage(list);
        } else {
          _shippingOrderResponseModel = shippingOrderResponseModel;
          pageKey = pageKey + 1;
          shippingOrdersPagingController!
              .appendPage(list, pageKey);
        }
      }
      notifyListeners();
    } catch (error) {
      shippingOrdersPagingController!.error = error;
    }
  }



  Future<void> fetchSalesInvoices(int pageKey, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      SalesInvoiceResponseModel salesInvoiceResponseModel =
      await mRestApi.getSalesOrders(pageKey, filters);

      if (salesInvoiceResponseModel.data != null) {
        final isLastPage = salesInvoiceResponseModel.data!.isEmpty;
        if (isLastPage) {
          salesInvoiceDataPagingController!
              .appendLastPage(salesInvoiceResponseModel.data!);
        } else {
          _shippingOrderResponseModel = shippingOrderResponseModelVar;
          pageKey = pageKey + 1;
          salesInvoiceDataPagingController!
              .appendPage(salesInvoiceResponseModel.data!, pageKey);
        }
      }
    } catch (error) {
      salesInvoiceDataPagingController!.error = error;
    }
  }

  Future<void> fetchPaymentRequest(int pageKey, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      PaymentModel paymentModel = await mRestApi.getPaymentModel(filters, pageKey);

      if (paymentModel.paymentData != null) {
        final isLastPage = paymentModel.paymentData!.glEntries!.isEmpty;
        if (isLastPage) {
          paymentLogPagingController!
              .appendLastPage(paymentModel.paymentData!.glEntries!);
        } else {
          _paymentModel = paymentModel.paymentData;
           pageKey = pageKey + 1;
           paymentLogPagingController!
               .appendPage(paymentModel.paymentData!.glEntries!, pageKey);
        }

        // _paymentModel ??= paymentModel.paymentData;
      }
    } catch (error) {
      paymentLogPagingController!.error = error;
    }
  }

  Future<void> getAppMessage(int pageKey, String? appMessageId) async {
    try {
      restApi mRestApi = restApi(Dio());
      AppMessageModel appMessageModel = await mRestApi.getAppMessage(pageKey);

      if (appMessageModel.data != null) {
        final isLastPage = appMessageModel.data!.isEmpty;
        if (isLastPage) {
          appMessageDataPagingController!.appendLastPage(appMessageModel.data!);
        } else {
          pageKey = pageKey + 1;
          appMessageDataPagingController!.appendPage(appMessageModel.data!, pageKey);
        }
      }
    } catch (error) {
      appMessageDataPagingController!.error = error;
    }
  }


  Future<void> fetchDWRLog(int pageKey, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      DirectWalletRequestLogModel directWalletRequestLogModel =
      await mRestApi.getDWRLog(pageKey, filters);

      if (directWalletRequestLogModel.data != null) {
        final isLastPage = directWalletRequestLogModel.data!.isEmpty;
        if (isLastPage) {
          dwrLogPagingController!
              .appendLastPage(directWalletRequestLogModel.data!);
        } else {
          _directWalletRequestLogModel = directWalletRequestLogModel;
          pageKey = pageKey + 1;
          dwrLogPagingController!
              .appendPage(directWalletRequestLogModel.data!, pageKey);
        }
      }
    } catch (error) {
      print("the error in dwrl is ${error.toString()}");
      dwrLogPagingController!.error = error;
    }
  }
  //
  // Future<void> fetchSILog(int pageKey, String filters) async {
  //   try {
  //     restApi mRestApi = restApi(Dio());
  //     // DirectWalletRequestLogModel directWalletRequestLogModel =
  //     // await mRestApi.getDWRLog(pageKey, filters);
  //
  //     PaymentModel paymentModel = await mRestApi.getPaymentModel();
  //
  //     // if (paymentModel.paymentData != null) {
  //     //   final isLastPage = paymentModel.paymentData!.glEntries!.isEmpty;
  //     //   if (isLastPage) {
  //     //     siPaymentLogPagingController!
  //     //         .appendLastPage(paymentModel.paymentData);
  //     //   } else {
  //     //     pageKey = pageKey + 1;
  //     //     dwrLogPagingController!
  //     //         .appendPage(directWalletRequestLogModel.data!, pageKey);
  //     //   }
  //     // }
  //   } catch (error) {
  //     dwrLogPagingController!.error = error;
  //   }
  // }

  Future<ApiResponse<AgentPaymentEntryResponse>> agentPaymentEntry(String dwr, String paidAmount) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      isLoading = true;
      agentPaymentEntryResponse = ApiResponse.loading("");
      try {
        AgentPaymentEntryResponse response =
        await mRestApi.agentPaymentEntry(dwr, paidAmount);
        if(response.error == 1){
          isLoading = false;
          return agentPaymentEntryResponse = ApiResponse.error(response.message);
        }
        agentPaymentEntryResponse = ApiResponse.completed(response);
      } catch (e) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return agentPaymentEntryResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return agentPaymentEntryResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return agentPaymentEntryResponse = ApiResponse.error("No Internet Connection");
    }
    return agentPaymentEntryResponse!;
  }

  Future<ApiResponse<ResponseModel>> dwrApproval(String dwr, String status) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      isLoading = true;
      apiResponse = ApiResponse.loading("");
      try {
        ResponseModel response =
        await mRestApi.dwrApproval(dwr, status);
        apiResponse = ApiResponse.completed(response);
      } catch (e) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return apiResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiResponse = ApiResponse.error("No Internet Connection");
    }
    return apiResponse!;
  }

  Future<ApiResponse<UpdateProfileModel>> updateProfile(XFile? image, String data) async{
    ExtraResitApi mRestApi = ExtraResitApi();
    if (await checkInternet()) {
      isLoading = true;
      apiUpdateProfileResponse = ApiResponse.loading("");
      try {
        UpdateProfileModel response =
        await mRestApi.updateProfile(image, data);
        apiUpdateProfileResponse = ApiResponse.completed(response);
      } catch (e) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return apiUpdateProfileResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return apiUpdateProfileResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return apiUpdateProfileResponse = ApiResponse.error("No Internet Connection");
    }
    return apiUpdateProfileResponse!;
  }

  Future<ApiResponse<UpdatePasswordModel>> updatePassword(String oldPassword, String newPassword) async{
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      isLoading = true;
      updatePasswordModel = ApiResponse.loading("");
      try {
        UpdatePasswordModel response =
        await mRestApi.updatePassword(oldPassword, newPassword);
        updatePasswordModel = ApiResponse.completed(response);
      } catch (e) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return updatePasswordModel =
                ApiResponse.error(forcedException.toString());
          }
        }
        return updatePasswordModel = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return updatePasswordModel = ApiResponse.error("No Internet Connection");
    }
    return updatePasswordModel!;
  }
}
