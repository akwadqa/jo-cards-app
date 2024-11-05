import 'direct_order_response.dart';

class SalesInvoiceDetails {
  final int? error;
  final int? statusCode;
  final String? message;
  final SalesInvoiceDetailsData? data;

  SalesInvoiceDetails({
    this.error,
    this.statusCode,
    this.message,
    this.data,
  });

  SalesInvoiceDetails.fromJson(Map<String, dynamic> json)
      : error = json['error'] as int?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? SalesInvoiceDetailsData.fromJson(
                json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'error': error,
        'status_code': statusCode,
        'message': message,
        'data': data?.toJson()
      };
}

class SalesInvoiceDetailsData {
  final String? salesOrderId;
  final String? date;
  final String? postingTime;
  final String? extraCharges;
  final String? grandTotal;
  final String? owner;
  final String? currency;
  final String? status;
  final List<ItemsDetail>? orderItems;

  SalesInvoiceDetailsData({
    this.salesOrderId,
    this.date,
    this.status,
    this.postingTime,
    this.extraCharges,
    this.grandTotal,
    this.owner,
    this.currency,
    this.orderItems,
  });

  SalesInvoiceDetailsData.fromJson(Map<String, dynamic> json)
      : salesOrderId = json['sales_order_id'] as String?,
        date = json['date'] as String?,
        status = json['status'] as String?,
        postingTime = json['posting_time'] as String?,
        extraCharges = json['extra_charges'].toString(),
        grandTotal =
            json['grand_total'] == null ? "0" : json['grand_total'].toString(),
        owner = json['owner'] as String?,
        currency = json['currency'] as String?,
        orderItems = (json['order_items'] as List?)
            ?.map(
                (dynamic e) => ItemsDetail.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'sales_invoice_id': salesOrderId,
        'date': date,
        'posting_time': postingTime,
        'extra_charges': extraCharges,
        'grand_total': grandTotal,
        'owner': owner,
        'currency': currency,
        'items_detail': orderItems?.map((e) => e.toJson()).toList()
      };
}

class ItemsDetail {
  final String? websiteItemCode;
  final String? websiteItemName;
  final String? qty;
  final String? netRate;
  final String? netAmount;
  final String? itemGroup;
  final String? image;
  final String? backGroundColor;
  final String? productOption;
  final List<ProductOptions>? productOptions;
  final List<StockDetails>? serialNumber;

  ItemsDetail({
    this.websiteItemCode,
    this.backGroundColor,
    this.websiteItemName,
    this.qty,
    this.netRate,
    this.netAmount,
    this.itemGroup,
    this.image,
    this.productOption,
    this.productOptions,
    this.serialNumber,
  });

  ItemsDetail.fromJson(Map<String, dynamic> json)
      : websiteItemCode = json['website_item_code'] as String?,
        websiteItemName = json['website_item_name'] as String?,
        backGroundColor = json['background_color'] as String? ?? "#7c5aa6",
        qty = json['qty'].toString(),
        netRate = json['net_rate'].toString(),
        netAmount = json['net_amount'].toString(),
        itemGroup = json['item_group'] as String?,
        image = json['image'] as String? ?? "/files/foreground.png",
        productOption = json['product_option'] as String?,
        productOptions = (json['product_options'] as List?)
            ?.map((dynamic e) =>
                ProductOptions.fromJson(e as Map<String, dynamic>))
            .toList(),
        serialNumber = (json['digital_card_details'] as List?)
            ?.map(
                (dynamic e) => StockDetails.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'website_item_code': websiteItemCode,
        'website_item_name': websiteItemName,
        'qty': qty,
        'net_rate': netRate,
        'net_amount': netAmount,
        'item_group': itemGroup,
        'image': image,
        'product_option': productOption,
        'product_options': productOptions?.map((e) => e.toJson()).toList(),
        'serial_number': serialNumber
      };
}

class ProductOptions {
  final String? productOptionFieldName;
  final String? productOptionFieldValue;

  ProductOptions({
    this.productOptionFieldName,
    this.productOptionFieldValue,
  });

  ProductOptions.fromJson(Map<String, dynamic> json)
      : productOptionFieldName = json['product_option_field_name'] as String?,
        productOptionFieldValue = json['product_option_field_value'] as String?;

  Map<String, dynamic> toJson() => {
        'product_option_field_name': productOptionFieldName,
        'product_option_field_value': productOptionFieldValue
      };
}
