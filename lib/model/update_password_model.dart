class UpdatePasswordModel{
  final String? message;
  final String? homePage;
  final String? fullName;

  UpdatePasswordModel({this.message, this.homePage, this.fullName});

  UpdatePasswordModel.fromJson(Map<String, dynamic> json) :
    message = json["message"] as String? ,
    homePage = json["home_page"] as String? ,
    fullName = json["full_name"] as String?;

}