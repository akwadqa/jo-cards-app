class ItemCategoryModel {
  final int? statusCode;
  final String? message;
  final String? itemGroup;
  final List<Data>? data;

  ItemCategoryModel({
    this.statusCode,
    this.message,
    this.itemGroup,
    this.data,
  });

  ItemCategoryModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      itemGroup = json['item_group'] as String?,
      data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'item_group' : itemGroup,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? websiteItemId;
  final String? itemCode;
  final String? websiteImage;
  final String? productTitle;
  final String? backgroundColor;
  final String? currency;
  final int? inStock;
  final String? itemPrice;
  final String? discountPercent;
  final String? discountAmount;
  final String? discountedPrice;

  Data({
    this.websiteItemId,
    this.itemCode,
    this.websiteImage,
    this.productTitle,
    this.backgroundColor,
    this.currency,
    this.inStock,
    this.itemPrice,
    this.discountPercent,
    this.discountAmount,
    this.discountedPrice,
  });

  Data.fromJson(Map<String, dynamic> json)
    : websiteItemId = json['website_item_id'] as String?,
      itemCode = json['item_code'] as String?,
      websiteImage = json['website_image'] as String?,
      productTitle = json['product_title'] as String?,
      backgroundColor = json['background_color'] as String?,
      currency = json['currency'] as String?,
      inStock = json['in_stock'] as int?,
      itemPrice = json['item_price'].toString(),
      discountPercent = json['discount_percent'] as String?,
      discountAmount = json['discount_amount']  .toString(),
      discountedPrice = json['discounted_price'].toString();

  Map<String, dynamic> toJson() => {
    'website_item_id' : websiteItemId,
    'item_code' : itemCode,
    'website_image' : websiteImage,
    'product_title' : productTitle,
    'background_color' : backgroundColor,
    'currency' : currency,
    'in_stock' : inStock,
    'item_price' : itemPrice,
    'discount_percent' : discountPercent,
    'discount_amount' : discountAmount,
    'discounted_price' : discountedPrice
  };
}