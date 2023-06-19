class UtilitiesModel {
  final int? statusCode;
  final String? message;
  final Data? data;

  UtilitiesModel({
    this.statusCode,
    this.message,
    this.data,
  });

  UtilitiesModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.toJson()
  };
}

class Data {
  final String? customerId;
  final String? company;
  final String? companyWhatsappNumber;
  final String? privacyPolicy;
  final String? walletBalance;
  final String? payableAmount;
  final String? username;
  final String? fullName;
  final String? mobileNo;
  final String? companyName;
  final String? unpaidUnits;
  final String? callUs;

  Data({
    this.customerId,
    this.company,
    this.companyWhatsappNumber,
    this.privacyPolicy,
    this.walletBalance,
    this.payableAmount,
    this.username,
    this.fullName,
    this.mobileNo,
    this.companyName,
    this.unpaidUnits,
    this.callUs,
  });

  Data.fromJson(Map<String, dynamic> json)
    : customerId = json['customer_id'] as String?,
      company = json['company'] as String?,
      companyWhatsappNumber = json['company_whatsapp_number'] as String?,
      privacyPolicy = json['privacy_policy'] as String?,
      walletBalance = json['wallet_balance'].toStringAsFixed(4).toString(),
      payableAmount = json['payable_amount'].toString(),
      username = json['username'] as String?,
      fullName = json['full_name'] as String?,
      mobileNo = json['mobile_no'] as String?,
      companyName = json['company_name'] as String?,
      unpaidUnits = json['unpaid_units'].toString(),
        callUs = json['call_us'] as String?;

  Map<String, dynamic> toJson() => {
    'customer_id' : customerId,
    'company' : company,
    'company_whatsapp_number' : companyWhatsappNumber,
    'privacy_policy' : privacyPolicy,
    'wallet_balance' : walletBalance,
    'payable_amount' : payableAmount,
    'username' : username,
    'full_name' : fullName,
    'mobile_no' : mobileNo,
    'company_name' : companyName,
    'unpaid_units' : unpaidUnits,
    'call_us' : unpaidUnits,
  };
}