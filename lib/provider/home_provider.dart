import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/Network/app_exceptions.dart';
import 'package:jocards/Network/resit_api.dart';
import 'package:jocards/model/agent_payment_entry_response.dart';
import 'package:jocards/model/direct_order_response.dart';
import 'package:jocards/model/home_model.dart';
import 'package:jocards/model/response_model.dart';
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

  ApiResponse<SalesOrderResponseModel>? _SalesOrderResponse;

  ApiResponse<SalesOrderResponseModel>? get salesOrderResponse =>
      _SalesOrderResponse;

  set salesOrderResponse(ApiResponse<SalesOrderResponseModel>? value) {
    _SalesOrderResponse = value;
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
        else{
          directOrderResponse = ApiResponse.completed(directOrder);
        }
      } catch (e, stackTrace) {
        print(stackTrace);
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

  ApiResponse<SalesOrderDetails> ? _SalesOrderDetailsResponse;

  ApiResponse<SalesOrderDetails> ? get salesOrderDetailsResponse =>
      _SalesOrderDetailsResponse;

  set salesOrderDetailsResponse(ApiResponse<SalesOrderDetails> ? value) {
    _SalesOrderDetailsResponse = value;
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

  Future<ApiResponse<SalesOrderDetails>> getPurchaseOrderDetails(String id) async {
    restApi mRestApi = restApi(Dio());
    if (await checkInternet()) {
      isLoading = false;

      salesOrderDetailsResponse = ApiResponse.loading("");
      try {
        SalesOrderDetails salesOrderDetails =
        await mRestApi.getSalesOrderDetails(id);

        if(salesOrderDetails.error == 1){
          isLoading = false;
          salesOrderDetailsResponse = ApiResponse.error(salesOrderDetails.message);
        }
        else{
          salesOrderDetailsResponse = ApiResponse.completed(salesOrderDetails);
        }
      } catch (e, stackTrace) {
        isLoading = false;
        if (e is DioError) {
          try {
            throwCustomException(e);
          } catch (forcedException) {
            return salesOrderDetailsResponse =
                ApiResponse.error(forcedException.toString());
          }
        }
        return salesOrderDetailsResponse = ApiResponse.error(e.toString());
      }
      isLoading = false;
    } else {
      return salesOrderDetailsResponse = ApiResponse.error("No Internet Connection");
    }
    return salesOrderDetailsResponse!;
  }

  PagingController<int, ShippingOrdeData>? shippingOrdersPagingController;
  PagingController<int, SalesOrderData>? salesOrdersDataPagingController;
  PagingController<int, DirectWalletRequestLogData>? dwrLogPagingController;

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
          pageKey = pageKey + 1;
          shippingOrdersPagingController!
              .appendPage(list, pageKey);
        }
      }
    } catch (error) {
      shippingOrdersPagingController!.error = error;
    }
  }



  Future<void> fetchSalesOrders(int pageKey, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      SalesOrderResponseModel salesOrderResponseModel =
      await mRestApi.getSalesOrders(pageKey, filters);

      if (salesOrderResponseModel.data != null) {
        final isLastPage = salesOrderResponseModel.data!.length == 0;
        if (isLastPage) {
          salesOrdersDataPagingController!
              .appendLastPage(salesOrderResponseModel.data!);
        } else {
          pageKey = pageKey + 1;
          salesOrdersDataPagingController!
              .appendPage(salesOrderResponseModel.data!, pageKey);
        }
      }
    } catch (error) {
      salesOrdersDataPagingController!.error = error;
    }
  }




  Future<void> fetchDWRLog(int pageKey, String filters) async {
    try {
      restApi mRestApi = restApi(Dio());
      DirectWalletRequestLogModel directWalletRequestLogModel =
      await mRestApi.getDWRLog(pageKey, filters);

      if (directWalletRequestLogModel.data != null) {
        final isLastPage = directWalletRequestLogModel.data!.length == 0;
        if (isLastPage) {
          dwrLogPagingController!
              .appendLastPage(directWalletRequestLogModel.data!);
        } else {
          pageKey = pageKey + 1;
          dwrLogPagingController!
              .appendPage(directWalletRequestLogModel.data!, pageKey);
        }
      }
    } catch (error) {
      dwrLogPagingController!.error = error;
    }
  }

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
}
