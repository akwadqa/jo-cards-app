class UpdateTokenModel{
  int? statusCode;
  int? error;
  String? message;

  UpdateTokenModel({this.statusCode, this.error, this.message});

  UpdateTokenModel.fromJson(Map<String, dynamic> json){
    statusCode = json["status_code"];
    error = json["error"];
    message = json["message"];
  }

}