class LoginResponseModel {
  final String? message;
  final String? homePage;
  final String? fullName;
  final String? user;
  final String? customerID;
  final KeyDetails? keyDetails;
  final ProfileDetails? profileDetails;

  LoginResponseModel({
    this.message,
    this.homePage,
    this.fullName,
    this.customerID,
    this.user,
    this.keyDetails,
    this.profileDetails,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json)
    : message = json['message'] as String?,
      homePage = json['home_page'] as String?,
      fullName = json['full_name'] as String?,
        customerID = json['customer_id'] as String?,
      user = json['user'] as String?,
      keyDetails = (json['key_details'] as Map<String,dynamic>?) != null ? KeyDetails.fromJson(json['key_details'] as Map<String,dynamic>) : null,
      profileDetails = (json['profile_details'] as Map<String,dynamic>?) != null ? ProfileDetails.fromJson(json['profile_details'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'message' : message,
    'home_page' : homePage,
    'full_name' : fullName,
    'user' : user,
    'customer_id' : customerID,
    'key_details' : keyDetails?.toJson(),
    'profile_details' : profileDetails?.toJson()
  };
}

class KeyDetails {
  final String? apiSecret;
  final String? apiKey;

  KeyDetails({
    this.apiSecret,
    this.apiKey,
  });

  KeyDetails.fromJson(Map<String, dynamic> json)
    : apiSecret = json['api_secret'] as String?,
      apiKey = json['api_key'] as String?;

  Map<String, dynamic> toJson() => {
    'api_secret' : apiSecret,
    'api_key' : apiKey
  };
}

class ProfileDetails {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNo;
  final dynamic gender;

  ProfileDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNo,
    this.gender,
  });

  ProfileDetails.fromJson(Map<String, dynamic> json)
    : firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      email = json['email'] as String?,
      mobileNo = json['mobile_no'] as String?,
      gender = json['gender'];

  Map<String, dynamic> toJson() => {
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email,
    'mobile_no' : mobileNo,
    'gender' : gender
  };
}