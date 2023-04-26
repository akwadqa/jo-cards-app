class AgentPaymentEntryResponse {
  AgentPaymentEntryResponse({
      this.statusCode, 
      this.message, 
      this.data,
      this.error,
  });

  AgentPaymentEntryResponse.fromJson(dynamic json) {
    statusCode = json['status_code'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null && json['data'].runtimeType != List ? AgentPaymentEntryModel.fromJson(json['data']) : null;
  }

  int? statusCode;
  String? message;
  AgentPaymentEntryModel? data;
  int? error;

AgentPaymentEntryResponse copyWith({  int? statusCode,
  String? message,
  AgentPaymentEntryModel? data,
  int? error,
}) => AgentPaymentEntryResponse(  statusCode: statusCode ?? this.statusCode,
  message: message ?? this.message,
  data: data ?? this.data,
  error: error ?? this.error,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['message'] = message;
    map['error'] = error;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class AgentPaymentEntryModel {
  AgentPaymentEntryModel({
      this.name, 
      this.owner, 
      this.creation, 
      this.modified, 
      this.modifiedBy, 
      this.idx, 
      this.docstatus, 
      this.namingSeries, 
      this.postingDate, 
      this.postingTime, 
      this.setPostingTime, 
      this.customer, 
      this.agent, 
      this.territory, 
      this.paidAmount, 
      this.cAccount, 
      this.aAccount, 
      this.company, 
      this.modeOfPayment, 
      this.getOutstandingInvoice, 
      this.getOutstandingWalletRequest, 
      this.totalAllocatedAmount, 
      this.unallocatedAmount, 
      this.status, 
      this.letterHead, 
      this.doctype, 
      this.references, 
      this.dwrReference,});

  AgentPaymentEntryModel.fromJson(dynamic json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    namingSeries = json['naming_series'];
    postingDate = json['posting_date'];
    postingTime = json['posting_time'];
    setPostingTime = json['set_posting_time'];
    customer = json['customer'];
    agent = json['agent'];
    territory = json['territory'];
    paidAmount = json['paid_amount'];
    cAccount = json['c_account'];
    aAccount = json['a_account'];
    company = json['company'];
    modeOfPayment = json['mode_of_payment'];
    getOutstandingInvoice = json['get_outstanding_invoice'];
    getOutstandingWalletRequest = json['get_outstanding_wallet_request'];
    totalAllocatedAmount = json['total_allocated_amount'];
    unallocatedAmount = json['unallocated_amount'];
    status = json['status'];
    letterHead = json['letter_head'];
    doctype = json['doctype'];
    if (json['references'] != null) {
      references = [];
      json['references'].forEach((v) {
        references?.add(v);
      });
    }
    if (json['dwr_reference'] != null) {
      dwrReference = [];
      json['dwr_reference'].forEach((v) {
        dwrReference?.add(DwrReference.fromJson(v));
      });
    }
  }
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  String? namingSeries;
  String? postingDate;
  String? postingTime;
  int? setPostingTime;
  String? customer;
  String? agent;
  String? territory;
  double? paidAmount;
  String? cAccount;
  String? aAccount;
  String? company;
  String? modeOfPayment;
  int? getOutstandingInvoice;
  int? getOutstandingWalletRequest;
  double? totalAllocatedAmount;
  double? unallocatedAmount;
  String? status;
  String? letterHead;
  String? doctype;
  List<dynamic>? references;
  List<DwrReference>? dwrReference;
AgentPaymentEntryModel copyWith({  String? name,
  String? owner,
  String? creation,
  String? modified,
  String? modifiedBy,
  int? idx,
  int? docstatus,
  String? namingSeries,
  String? postingDate,
  String? postingTime,
  int? setPostingTime,
  String? customer,
  String? agent,
  String? territory,
  double? paidAmount,
  String? cAccount,
  String? aAccount,
  String? company,
  String? modeOfPayment,
  int? getOutstandingInvoice,
  int? getOutstandingWalletRequest,
  double? totalAllocatedAmount,
  double? unallocatedAmount,
  String? status,
  String? letterHead,
  String? doctype,
  List<dynamic>? references,
  List<DwrReference>? dwrReference,
}) => AgentPaymentEntryModel(  name: name ?? this.name,
  owner: owner ?? this.owner,
  creation: creation ?? this.creation,
  modified: modified ?? this.modified,
  modifiedBy: modifiedBy ?? this.modifiedBy,
  idx: idx ?? this.idx,
  docstatus: docstatus ?? this.docstatus,
  namingSeries: namingSeries ?? this.namingSeries,
  postingDate: postingDate ?? this.postingDate,
  postingTime: postingTime ?? this.postingTime,
  setPostingTime: setPostingTime ?? this.setPostingTime,
  customer: customer ?? this.customer,
  agent: agent ?? this.agent,
  territory: territory ?? this.territory,
  paidAmount: paidAmount ?? this.paidAmount,
  cAccount: cAccount ?? this.cAccount,
  aAccount: aAccount ?? this.aAccount,
  company: company ?? this.company,
  modeOfPayment: modeOfPayment ?? this.modeOfPayment,
  getOutstandingInvoice: getOutstandingInvoice ?? this.getOutstandingInvoice,
  getOutstandingWalletRequest: getOutstandingWalletRequest ?? this.getOutstandingWalletRequest,
  totalAllocatedAmount: totalAllocatedAmount ?? this.totalAllocatedAmount,
  unallocatedAmount: unallocatedAmount ?? this.unallocatedAmount,
  status: status ?? this.status,
  letterHead: letterHead ?? this.letterHead,
  doctype: doctype ?? this.doctype,
  references: references ?? this.references,
  dwrReference: dwrReference ?? this.dwrReference,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['owner'] = owner;
    map['creation'] = creation;
    map['modified'] = modified;
    map['modified_by'] = modifiedBy;
    map['idx'] = idx;
    map['docstatus'] = docstatus;
    map['naming_series'] = namingSeries;
    map['posting_date'] = postingDate;
    map['posting_time'] = postingTime;
    map['set_posting_time'] = setPostingTime;
    map['customer'] = customer;
    map['agent'] = agent;
    map['territory'] = territory;
    map['paid_amount'] = paidAmount;
    map['c_account'] = cAccount;
    map['a_account'] = aAccount;
    map['company'] = company;
    map['mode_of_payment'] = modeOfPayment;
    map['get_outstanding_invoice'] = getOutstandingInvoice;
    map['get_outstanding_wallet_request'] = getOutstandingWalletRequest;
    map['total_allocated_amount'] = totalAllocatedAmount;
    map['unallocated_amount'] = unallocatedAmount;
    map['status'] = status;
    map['letter_head'] = letterHead;
    map['doctype'] = doctype;
    if (references != null) {
      map['references'] = references?.map((v) => v.toJson()).toList();
    }
    if (dwrReference != null) {
      map['dwr_reference'] = dwrReference?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class DwrReference {
  DwrReference({
      this.name, 
      this.owner, 
      this.creation, 
      this.modified, 
      this.modifiedBy, 
      this.parent, 
      this.parentfield, 
      this.parenttype, 
      this.idx, 
      this.docstatus, 
      this.postingDate, 
      this.dwrReference, 
      this.name1, 
      this.requestedAmount, 
      this.outstanding, 
      this.allocated, 
      this.doctype, 
      this.unsaved,});

  DwrReference.fromJson(dynamic json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    idx = json['idx'];
    docstatus = json['docstatus'];
    postingDate = json['posting_date'];
    dwrReference = json['dwr_reference'];
    name1 = json['name1'];
    requestedAmount = json['requested_amount'];
    outstanding = json['outstanding'];
    allocated = json['allocated'];
    doctype = json['doctype'];
    unsaved = json['__unsaved'];
  }
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? postingDate;
  String? dwrReference;
  String? name1;
  double? requestedAmount;
  double? outstanding;
  double? allocated;
  String? doctype;
  int? unsaved;
DwrReference copyWith({  String? name,
  String? owner,
  String? creation,
  String? modified,
  String? modifiedBy,
  String? parent,
  String? parentfield,
  String? parenttype,
  int? idx,
  int? docstatus,
  String? postingDate,
  String? dwrReference,
  String? name1,
  double? requestedAmount,
  double? outstanding,
  double? allocated,
  String? doctype,
  int? unsaved,
}) => DwrReference(  name: name ?? this.name,
  owner: owner ?? this.owner,
  creation: creation ?? this.creation,
  modified: modified ?? this.modified,
  modifiedBy: modifiedBy ?? this.modifiedBy,
  parent: parent ?? this.parent,
  parentfield: parentfield ?? this.parentfield,
  parenttype: parenttype ?? this.parenttype,
  idx: idx ?? this.idx,
  docstatus: docstatus ?? this.docstatus,
  postingDate: postingDate ?? this.postingDate,
  dwrReference: dwrReference ?? this.dwrReference,
  name1: name1 ?? this.name1,
  requestedAmount: requestedAmount ?? this.requestedAmount,
  outstanding: outstanding ?? this.outstanding,
  allocated: allocated ?? this.allocated,
  doctype: doctype ?? this.doctype,
  unsaved: unsaved ?? this.unsaved,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['owner'] = owner;
    map['creation'] = creation;
    map['modified'] = modified;
    map['modified_by'] = modifiedBy;
    map['parent'] = parent;
    map['parentfield'] = parentfield;
    map['parenttype'] = parenttype;
    map['idx'] = idx;
    map['docstatus'] = docstatus;
    map['posting_date'] = postingDate;
    map['dwr_reference'] = dwrReference;
    map['name1'] = name1;
    map['requested_amount'] = requestedAmount;
    map['outstanding'] = outstanding;
    map['allocated'] = allocated;
    map['doctype'] = doctype;
    map['__unsaved'] = unsaved;
    return map;
  }

}