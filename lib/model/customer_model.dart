class CustomerModel {
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  CustomerModel({
    this.statusCode,
    this.message,
    this.data,
  });

  CustomerModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final String? user;
  final String? customerId;
  final String? customerType;
  final String? customerName;

  Data(
      {this.user,
      this.customerId,
      this.customerName,
      this.customerType});

  Data.fromJson(Map<String, dynamic> json)
      : user = json['user'] as String?,
        customerId = json['customer_id'] as String?,
        customerName = json['customer_name'] as String?,
        customerType = json['customer_type'] as String?;

  Map<String, dynamic> toJson() => {
        'user': user,
        'customer_id': customerId,
        'customer_name': customerName,
        'customer_type': customerType
      };
}
