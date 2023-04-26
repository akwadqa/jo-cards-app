class RegisterRequestModel {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? companyName;
  final String? mobileNo;
  final String? address;
  final String? password;

  RegisterRequestModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.companyName,
    this.mobileNo,
    this.address,
    this.password,
  });

  RegisterRequestModel.fromJson(Map<String, dynamic> json)
    : firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      middleName = json['middle_name'] as String?,
      email = json['email'] as String?,
      companyName = json['company_name'] as String?,
      mobileNo = json['mobile_no'] as String?,
        address = json['address'] as String?,
      password = json['password'] as String?;

  Map<String, dynamic> toJson() => {
    'first_name' : firstName,
    'middle_name' : middleName,
    'last_name' : lastName,
    'email' : email,
    'company_name' : companyName,
    'mobile_no' : mobileNo,
    'address' : address,
    'password' : password
  };
}