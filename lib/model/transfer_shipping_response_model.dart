class TransferShippingResponseModel {
  final int? statusCode;
  final String? message;
  final Data? data;

  TransferShippingResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  TransferShippingResponseModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['status_code'] as int?) != 403 ? (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null : null;

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.toJson()
  };
}

class Data {
  final String? name;
  final String? owner;
  final String? creation;
  final String? modified;
  final String? modifiedBy;
  final String? idx;
  final String? docstatus;
  final String? namingSeries;
  final String? customer;
  final String? territory;
  final String? postingDate;
  final String? postingTime;
  final String? setPostingTime;
  final String? status;
  final String? requestedAmount;
  final String? paidAmount;
  final String? unpaidAmount;
  final String? doctype;

  Data({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.idx,
    this.docstatus,
    this.namingSeries,
    this.customer,
    this.territory,
    this.postingDate,
    this.postingTime,
    this.setPostingTime,
    this.status,
    this.requestedAmount,
    this.paidAmount,
    this.unpaidAmount,
    this.doctype,
  });

  Data.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String?,
      owner = json['owner'] as String?,
      creation = json['creation'] as String?,
      modified = json['modified'] as String?,
      modifiedBy = json['modified_by'] as String?,
      idx = json['idx'].toString(),
      docstatus = json['docstatus'].toString(),
      namingSeries = json['naming_series'] as String?,
      customer = json['customer'] as String?,
      territory = json['territory'] as String?,
      postingDate = json['posting_date'] as String?,
      postingTime = json['posting_time'] as String?,
      setPostingTime = json['set_posting_time'] .toString(),
      status = json['status'] as String?,
      requestedAmount = json['requested_amount'] .toString(),
      paidAmount = json['paid_amount'] .toString(),
      unpaidAmount = json['unpaid_amount'] .toString(),
      doctype = json['doctype'].toString();

  Map<String, dynamic> toJson() => {
    'name' : name,
    'owner' : owner,
    'creation' : creation,
    'modified' : modified,
    'modified_by' : modifiedBy,
    'idx' : idx,
    'docstatus' : docstatus,
    'naming_series' : namingSeries,
    'customer' : customer,
    'territory' : territory,
    'posting_date' : postingDate,
    'posting_time' : postingTime,
    'set_posting_time' : setPostingTime,
    'status' : status,
    'requested_amount' : requestedAmount,
    'paid_amount' : paidAmount,
    'unpaid_amount' : unpaidAmount,
    'doctype' : doctype
  };
}