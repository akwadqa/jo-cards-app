class AgentModel {
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  AgentModel({
    this.statusCode,
    this.message,
    this.data,
  });

  AgentModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? name;
  final String? customerName;
  final String? customerType;
  final String? territory;
  final String? akdTerritoryAgent;
  final String? mobileNo;

  Data({
    this.name,
    this.customerName,
    this.customerType,
    this.territory,
    this.akdTerritoryAgent,
    this.mobileNo
  });

  Data.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String?,
      customerName = json['customer_name'] as String?,
      customerType = json['customer_type'] as String?,
      territory = json['territory'] as String?,
      akdTerritoryAgent = json['akd_territory_agent'] as String?,
      mobileNo = json["mobile_no"] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'customer_name' : customerName,
    'customer_type' : customerType,
    'territory' : territory,
    'akd_territory_agent' : akdTerritoryAgent,
    "mobile_no": mobileNo,
  };
}