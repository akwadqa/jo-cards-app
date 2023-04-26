class ResponseModel {
  ResponseModel({
      this.statusCode, 
      this.message, 
      this.data,
  });

  ResponseModel.fromJson(dynamic json) {
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'];
  }

  int? statusCode;
  String? message;
  dynamic data;

ResponseModel copyWith({  int? statusCode,
  String? message,
  List<dynamic>? data,
}) => ResponseModel(  statusCode: statusCode ?? this.statusCode,
  message: message ?? this.message,
  data: data ?? this.data,
);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}