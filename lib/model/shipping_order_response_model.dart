class ShippingOrderResponseModel {
  final int? statusCode;
  final String? message;
  final List<ShippingOrdeData>? data;
  final Pagination? pagination;
  final TotalOrderData? totalOrderData;

  ShippingOrderResponseModel({
    this.statusCode,
    this.message,
    this.data,
    this.pagination,
    this.totalOrderData
  });

  ShippingOrderResponseModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['data'] as List?)?.map((dynamic e) => ShippingOrdeData.fromJson(e as Map<String,dynamic>)).toList(),
        pagination = (json['pagination'] as Map<String,dynamic>?) != null ? Pagination.fromJson(json['pagination'] as Map<String,dynamic>) : null,
      totalOrderData = (json['total'] as Map<String,dynamic>?) != null ? TotalOrderData.fromJson(json['total'] as Map<String,dynamic>) : null
  ;


  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'pagination' : pagination?.toJson(),
    'data' : data?.map((e) => e.toJson()).toList()
  };
  @override
  toString(){
    return "ShippingOrderResponseModel {statusCode: $statusCode, message: $message, pagination: $pagination, data: $data}";
  }
}
class Pagination {
  final int? totalItems;
  final dynamic totalPages;
  final int? currentPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
  });

  Pagination.fromJson(Map<String, dynamic> json)
      : totalItems = json['total_items'] as int?,
        totalPages = json['total_pages'],
        currentPage = json['current_page'] as int?;

  Map<String, dynamic> toJson() => {
    'total_items' : totalItems,
    'total_pages' : totalPages,
    'current_page' : currentPage
  };
}
class ShippingOrdeData {
  final String? digitalWalletRequestId;
  final String? workflowState;
  final String? postingDate;
  final String? postingTime;
  final String? territory;
  final dynamic territoryAgent;
  final String? requestedAmount;
  final String? unpaidAmount;
  final String? status;
  final int? docstatus;
  final String? owner;
  final String? customer;
  final int? isTransfer;

  ShippingOrdeData({
    this.digitalWalletRequestId,
    this.workflowState,
    this.postingDate,
    this.postingTime,
    this.territory,
    this.territoryAgent,
    this.requestedAmount,
    this.unpaidAmount,
    this.status,
    this.docstatus,
    this.owner,
    this.customer,
    this.isTransfer
  });

  ShippingOrdeData.fromJson(Map<String, dynamic> json)
    : digitalWalletRequestId = json['digital_wallet_request_id'] as String?,
      workflowState = json['workflow_state'] as String?,
      postingDate = json['posting_date'] as String?,
      postingTime = json['posting_time'] as String?,
      territory = json['territory'] as String?,
      territoryAgent = json['territory_agent'],
      requestedAmount = json['requested_amount'].toString(),
      unpaidAmount = json['unpaid_amount'].toString(),
      status = json['status'] as String?,
      docstatus = json['docstatus'] as int?,
      owner = json['owner'] as String?,
        customer = json['customer'] as String?,
      isTransfer = json['is_transfer'] as int?;

  Map<String, dynamic> toJson() => {
    'digital_wallet_request_id' : digitalWalletRequestId,
    'workflow_state' : workflowState,
    'posting_date' : postingDate,
    'posting_time' : postingTime,
    'territory' : territory,
    'territory_agent' : territoryAgent,
    'requested_amount' : requestedAmount,
    'unpaid_amount' : unpaidAmount,
    'status' : status,
    'docstatus' : docstatus,
    'owner' : owner,
    'customer' : customer,
    'is_transfer' : isTransfer
  };
}
class TotalOrderData {
  final dynamic totalPaid;
  final dynamic totalUnPaid;
  TotalOrderData({this.totalPaid, this.totalUnPaid});

  TotalOrderData.fromJson(Map<String, dynamic> json)
    : totalPaid =  json["total_paid"] as dynamic,
      totalUnPaid = json["total_unpaid"]  as dynamic;

  @override
  toString(){
    return "TotalOrderData {totalPaid: $totalPaid, totalUnPaid: $totalUnPaid}";
  }
}