
import 'package:jocards/model/shipping_order_response_model.dart';

class SalesInvoiceResponseModel {
  final int? statusCode;
  final String? message;
  final List<SalesInvoiceData>? data;
  final Pagination? pagination;

  SalesInvoiceResponseModel({
    this.statusCode,
    this.message,
    this.data,
    this.pagination
  });

  SalesInvoiceResponseModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => SalesInvoiceData.fromJson(e as Map<String,dynamic>)).toList(),
        pagination = (json['pagination'] as Map<String,dynamic>?) != null ? Pagination.fromJson(json['pagination'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class SalesInvoiceData {
  final String? salesInvoiceId;
  final int? status;
  final String? date;
  final String? postingTime;
  final dynamic grandTotal;
  final String? invoiceStatus;
  final String? owner;
  final String? currency;
  final String? customer;
  final String? creation;
  final String? totalTaxesAndCharges;
  final List<Items>? items;

  SalesInvoiceData({
    this.salesInvoiceId,
    this.invoiceStatus,
    this.status,
    this.customer,
    this.creation,
    this.date,
    this.postingTime,
    this.grandTotal,
    this.currency,
    this.owner,
    this.totalTaxesAndCharges,
    this.items,
  });

  SalesInvoiceData.fromJson(Map<String, dynamic> json)
      : salesInvoiceId = json['sales_invoice_id'] as String?,
        date = json['date'] as String?,
        status = json["status"] as int?,
        postingTime = json['posting_time'] as String?,
        currency = json['currency'] as String?,
        invoiceStatus = json['invoice_status'] as String?,
        grandTotal = json['grand_total'] as dynamic ?? "0",
        creation = json["creation"] as String?,
        customer = json["customer"] as String?,
        owner = json['owner'] as String?,
        totalTaxesAndCharges = json['total_taxes_and_charges'].toString(),
        items = (json['items'] as List?)?.map((dynamic e) => Items.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'sales_invoice_id' : salesInvoiceId,
    'date' : date,
    "status" : status,
    'posting_time' : postingTime,
    'grand_total' : grandTotal,
    'owner' : owner,
    'total_taxes_and_charges' : totalTaxesAndCharges,
    'items' : items?.map((e) => e.toJson()).toList()
  };
}

class Items {
  final String? itemCode;
  final String? itemName;
  final String? qty;
  final String? netRate;
  final String? netAmount;
  final String? itemGroup;
  final String? image;
  final String? backgroundColor;
  final String? webSiteImage;

  Items({
    this.itemCode,
    this.itemName,
    this.backgroundColor,
    this.qty,
    this.netRate,
    this.netAmount,
    this.itemGroup,
    this.webSiteImage,
    this.image,
  });

  Items.fromJson(Map<String, dynamic> json)
      : itemCode = json['website_item_code'] as String?,
        itemName = json['website_item_name'] as String?,
        backgroundColor = json['background_color'] as String? ?? "#7c5aa6",
        webSiteImage = json['website_image'] as String? ?? "/files/foreground.png",
        qty = json['qty'].toString(),
        netRate = json['net_rate'].toString(),
        netAmount = json['net_amount'].toString(),
        itemGroup = json['item_group'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() => {
    'item_code' : itemCode,
    'item_name' : itemName,
    'qty' : qty,
    'net_rate' : netRate,
    'net_amount' : netAmount,
    'item_group' : itemGroup,
    'image' : image
  };
}