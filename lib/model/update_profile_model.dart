class UpdateProfileModel{
  int? statusCode;
  String? message;
  int? error;
  UpdateProfileData? data;
  UpdateProfileModel({this.statusCode, this.message, this.error, this.data});

  UpdateProfileModel.fromMap(Map<String, dynamic> json):
      statusCode = json["status_code"],
      message = json["message"],
      error = json["error"],
      data = UpdateProfileData.fromMap(json["data"]);
}

class UpdateProfileData {
  String? fullName;
  String? middleName;
  String? lastName;
  String? email;
  String? mobileNo;
  String? gender;
  String? userImage;
  String? companyName;

  UpdateProfileData({this.fullName, this.middleName, this.lastName, this.email, this.mobileNo, this.gender, this.userImage, this.companyName});
  UpdateProfileData.fromMap(Map<String, dynamic> json):
      fullName = json["first_name"],
      middleName = json["middle_name"],
      lastName = json["last_name"],
      email = json["email"],
      mobileNo = json["mobile_no"],
      gender = json["gender"],
      userImage = json["user_image"],
      companyName = json["company_name"]
  ;
}