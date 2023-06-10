import 'package:jocards/model/shipping_order_response_model.dart';

class AppMessageModel{
  final int? statusCode;
  final String? message;
  final List<MessageData>? data;
  final Pagination? pagination;

  AppMessageModel({
    this.statusCode,
    this.message,
    this.data,
    this.pagination
  });

  AppMessageModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => MessageData.fromJson(e as Map<String,dynamic>)).toList(),
        pagination = (json['pagination'] as Map<String,dynamic>?) != null ? Pagination.fromJson(json['pagination'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}
class MessageData{
  final String? appMessageId;
  final String? appMessageTitle;
  final String? appMessageIcon;
  final String? publishedOn;
  final String? expiryDate;
  final String? content;
  final String? type;
  final String? itemGroup;
  final String? item;

  MessageData.fromJson(Map<String, dynamic> json) :
        appMessageId = json['app_message_id'] as String?,
        appMessageTitle = json["app_message_title"] as String?,
        appMessageIcon = json["app_message_icon"] as String?,
        publishedOn = json["published_on"] as String?,
        expiryDate = json["expiry_date"] as String?,
        content = json["content"] as String?,
        type = json["type"] as String?,
        itemGroup = json["item_group"] as String?,
        item = json["item"] as String?
  ;

  Map<String, dynamic> toJson() =>{
    "app_message_id": appMessageId,
    "app_message_title": appMessageTitle,
    "app_message_icon": appMessageIcon,
    "published_on": publishedOn,
    "expiry_date": expiryDate,
    "content": content,
    "type": type,
    "item_group" : itemGroup,
    "item" : item
  };
}