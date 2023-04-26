import 'login_response_model.dart';

class RegisterResponseModel {
  final int? statusCode;
  final String? message;
  final List<dynamic>? data;
  final KeyDetails? keyDetails;
  final ProfileDetails? profileDetails;
  final String? customerID;

  RegisterResponseModel({
    this.statusCode,
    this.customerID,
    this.message,
    this.data,
    this.keyDetails,
    this.profileDetails
  });

  RegisterResponseModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
        customerID = json['customer_id'] as String?,
      data = json['data'] as List?,
        keyDetails = (json['key_details'] as Map<String,dynamic>?) != null ? KeyDetails.fromJson(json['key_details'] as Map<String,dynamic>) : null,
        profileDetails = (json['profile_details'] as Map<String,dynamic>?) != null ? ProfileDetails.fromJson(json['profile_details'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'customer_id' : customerID,
    'data' : data
  };
}