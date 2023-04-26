class AppVersionModel {
  AppVersionModel({
      this.androidApiVersion, 
      this.iosApiVersion, 
      this.mandatoryToUpdate, 
      this.appUpdateMessage,});

  AppVersionModel.fromJson(dynamic json) {
    androidApiVersion = json['android_api_version'];
    iosApiVersion = json['ios_api_version'];
    mandatoryToUpdate = json['mandatory_to_update'];
    appUpdateMessage = json['app_update_message'];
  }
  String? androidApiVersion;
  String? iosApiVersion;
  int? mandatoryToUpdate;
  String? appUpdateMessage;
AppVersionModel copyWith({  String? androidApiVersion,
  String? iosApiVersion,
  int? mandatoryToUpdate,
  String? appUpdateMessage,
}) => AppVersionModel(  androidApiVersion: androidApiVersion ?? this.androidApiVersion,
  iosApiVersion: iosApiVersion ?? this.iosApiVersion,
  mandatoryToUpdate: mandatoryToUpdate ?? this.mandatoryToUpdate,
  appUpdateMessage: appUpdateMessage ?? this.appUpdateMessage,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['android_api_version'] = androidApiVersion;
    map['ios_api_version'] = iosApiVersion;
    map['mandatory_to_update'] = mandatoryToUpdate;
    map['app_update_message'] = appUpdateMessage;
    return map;
  }

}