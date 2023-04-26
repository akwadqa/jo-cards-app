class DirectWalletRequestLogModel {
  final int? statusCode;
  final String? message;
  final Pagination? pagination;
  final List<DirectWalletRequestLogData>? data;

  DirectWalletRequestLogModel({
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  DirectWalletRequestLogModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      pagination = (json['pagination'] as Map<String,dynamic>?) != null ? Pagination.fromJson(json['pagination'] as Map<String,dynamic>) : null,
      data = (json['data'] as List?)?.map((dynamic e) => DirectWalletRequestLogData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'pagination' : pagination?.toJson(),
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Pagination {
    dynamic totalItems;
 dynamic totalPages;
  final int? currentPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
  });

  Pagination.fromJson(Map<String, dynamic> json)
    : totalItems = json['total_items'] ,
      totalPages = json['total_pages'] ,
      currentPage = json['current_page'] ;

  Map<String, dynamic> toJson() => {
    'total_items' : totalItems,
    'total_pages' : totalPages,
    'current_page' : currentPage
  };
}

class DirectWalletRequestLogData {
  final String? refId;
  final String? dwrLogId;
  final String? date;
  final String? time;
  final String? logType;
  final String? units;
  final String? availableWalletUnits;
  final String? owner;
  final String? salesOrder;

  DirectWalletRequestLogData({
    this.refId,
    this.dwrLogId,
    this.date,
    this.time,
    this.logType,
    this.units,
    this.availableWalletUnits,
    this.owner,
    this.salesOrder,
  });

  DirectWalletRequestLogData.fromJson(Map<String, dynamic> json)
    : refId = json['ref_id'] as String?,
      dwrLogId = json['so_id'] as String?,
      date = json['date'] as String?,
      time = json['time'] as String?,
      logType = json['log_type'] as String?,
      units = json['units'].toString(),
      availableWalletUnits = json['available_wallet_units'].toString(),
      owner = json['owner'] as String?,
      salesOrder = json['sales_order'] as String?;

  Map<String, dynamic> toJson() => {
    'ref_id' : refId,
    'so_id' : dwrLogId,
    'date' : date,
    'time' : time,
    'log_type' : logType,
    'units' : units,
    'available_wallet_units' : availableWalletUnits,
    'owner' : owner,
    'sales_order' : salesOrder
  };
}