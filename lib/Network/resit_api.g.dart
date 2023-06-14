// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resit_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _restApi implements restApi {
  _restApi(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://www.jocards.com/api/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HomeModel> getHome(platform) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'platform': platform};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<HomeModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_home_block',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = HomeModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TerritoriesModel> getTerritories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TerritoriesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_territories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TerritoriesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ItemCategoryModel> getItemsOfCategory(
    category,
    platform,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'category': category,
      r'platform': platform,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ItemCategoryModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_items_of_categories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ItemCategoryModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProductsDetailsModel> getProductDetails(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'website_item_id': id};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProductsDetailsModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_product_details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ProductsDetailsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginResponseModel> signIn(
    user,
    password,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'usr': user,
      'pwd': password,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.app_login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginResponseModel> signUp(registerRequestModel) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'data': registerRequestModel};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DirectOrderResponse> directOrder(directOrderList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'items': directOrderList};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DirectOrderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.direct_order',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DirectOrderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UtilitiesModel> getUtilities() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UtilitiesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_utilities',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UtilitiesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AgentModel> getAgentCustomers() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AgentModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_agent_customers',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AgentModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ShippingOrderResponseModel> getShippingOrders(
    pageNo,
    filter,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page_no': pageNo,
      r'filters': filter,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ShippingOrderResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.filter_dwr',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ShippingOrderResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SalesInvoiceResponseModel> getSalesOrders(
    pageNo,
    filter,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page_no': pageNo,
      r'filters': filter,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SalesInvoiceResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.filter_si',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SalesInvoiceResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CategoriesModel> getAllCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CategoriesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_categories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoriesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DirectWalletRequestLogModel> getDWRLog(
    pageNo,
    filter,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page_no': pageNo,
      r'filters': filter,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DirectWalletRequestLogModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.filter_dwrl',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DirectWalletRequestLogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SalesOrderDetails> getSalesOrderDetails(salesOrderId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'sales_order_id': salesOrderId};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SalesOrderDetails>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_sales_order_detail',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SalesOrderDetails.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SalesInvoiceDetails> getSalesInvoiceDetails(salesInvoiceId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'sales_invoice_id': salesInvoiceId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SalesInvoiceDetails>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.get_sales_invoce_details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SalesInvoiceDetails.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransferShippingResponseModel> requestTransferShipping({
    units,
    customerName,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'units': units,
      'customer': customerName,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TransferShippingResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.dwr_request_and_transfer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TransferShippingResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UploadResponseModel> uploadReceipt({
    cmd,
    doctype,
    docname,
    fileName,
    fileData,
    fromForm,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'cmd': cmd,
      'doctype': doctype,
      'docname': docname,
      'filename': fileName,
      'filedata': fileData,
      'from_form': fromForm,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UploadResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'resource/run_custom_method',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UploadResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AgentPaymentEntryResponse> agentPaymentEntry(
    dwr,
    paidAmount,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'dwr': dwr,
      'paid_amount': paidAmount,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AgentPaymentEntryResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.agent_payment_entry',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AgentPaymentEntryResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ResponseModel> dwrApproval(
    dwr,
    status,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'dwr': dwr,
      'status': status,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.dwr_approval',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AppVersionModel> getAppVersion() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AppVersionModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.app_version',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AppVersionModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PaymentModel> getPaymentModel(
    filter,
    pageNo,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'filters': filter,
      r'page_no': pageNo,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<PaymentModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.smart_api.payments',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PaymentModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AppMessageModel> getAppMessage(pageNo) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page_no': pageNo};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AppMessageModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/jocards_v2.app_message.app_messages',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AppMessageModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UpdatePasswordModel> updatePassword(
    oldPassword,
    newPassword,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UpdatePasswordModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/frappe.core.doctype.user.user.update_password',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UpdatePasswordModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UpdateTokenModel> updateToken(
    token,
    userId,
    userDeviceType,
    userDeviceName,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'device_token': token,
      'user_id': userId,
      'user_device_type': userDeviceType,
      'user_device_name': userDeviceName,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UpdateTokenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'method/fcm_frappe.api.device_token',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UpdateTokenModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
