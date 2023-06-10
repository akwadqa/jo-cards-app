class LoginResponseModel {
  final String? message;
  final String? homePage;
  final String? fullName;
  final String? user;
  final String? customerID;
  final KeyDetails? keyDetails;
  final ProfileDetails? profileDetails;
  final String? customerType;

  LoginResponseModel({
    this.message,
    this.homePage,
    this.fullName,
    this.customerID,
    this.user,
    this.keyDetails,
    this.profileDetails,
    this.customerType
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json)
    : message = json['message'] as String?,
      homePage = json['home_page'] as String?,
      fullName = json['full_name'] as String?,
        customerID = json['customer_id'] as String?,
      user = json['user'] as String?,
      keyDetails = (json['key_details'] as Map<String,dynamic>?) != null ? KeyDetails.fromJson(json['key_details'] as Map<String,dynamic>) : null,
      profileDetails = (json['profile_details'] as Map<String,dynamic>?) != null ? ProfileDetails.fromJson(json['profile_details'] as Map<String,dynamic>) : null,
      customerType = json["customer_type"] as String?;

  Map<String, dynamic> toJson() => {
    'message' : message,
    'home_page' : homePage,
    'full_name' : fullName,
    'user' : user,
    'customer_id' : customerID,
    'key_details' : keyDetails?.toJson(),
    'profile_details' : profileDetails?.toJson(),
    "customer_type": customerType,
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

  @override
  toString(){
    return "KeyDetails: {apiSecret: $apiSecret, apiKey: $apiKey}";
  }
}

class ProfileDetails {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNo;
  final dynamic gender;
  final String? companyName;
  final String? customerAgent;
  final String? userImage;

  ProfileDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNo,
    this.gender,
    this.companyName,
    this.customerAgent,
    this.userImage
  });

  ProfileDetails.fromJson(Map<String, dynamic> json)
    : firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      email = json['email'] as String?,
      mobileNo = json['mobile_no'] as String?,
      gender = json['gender'],
      companyName = json["company_name"] as String?,
      customerAgent = json["customer_agent"] as String?,
      userImage = json["user_image"] as String?
  ;

  Map<String, dynamic> toJson() => {
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email,
    'mobile_no' : mobileNo,
    'gender' : gender,
    "company_name": companyName,
    "user_image": userImage,
    "customer_agent": customerAgent
  };

  @override
  toString() {
    return "ProfileDetails: {firstName: $firstName, lastName: $lastName, email: $email, mobileNo : $mobileNo, gender: $gender, companyName: $companyName, customerAgent: $customerAgent, userImage : $userImage}";
  }
}