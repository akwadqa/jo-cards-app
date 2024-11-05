class DirectOrderResponse {
  String? message;
  int? error;
  int? statusCode;
  String? date;
  String? postingTime;
  String? status;
  String? salesOrderStatus;
  String? extraCharges;
  String? grandTotal;
  String? owner;
  String? currency;
  String? salesOrderId;
  List<OrderItems>? orderItems;
  String? excType;
  String? serverMessages;

  DirectOrderResponse(
      {this.message,
      this.error,
      this.salesOrderStatus,
      this.statusCode,
      this.date,
      this.postingTime,
      this.status,
      this.salesOrderId,
      this.orderItems,
      this.extraCharges,
      this.grandTotal,
      this.owner,
      this.currency,
      this.excType,
      this.serverMessages});

  DirectOrderResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        statusCode = json['status_code'] as int?,
        error = json['error'] as int?,
        salesOrderStatus = json['sales_order_status'] as String?,
        date = json['date'] as String?,
        postingTime = json['posting_time'] as String?,
        extraCharges = json['extra_charges'].toString(),
        grandTotal = json['grand_total'].toString(),
        owner = json['owner'] as String?,
        currency = json['currency'] as String?,
        status = json['status'] as String?,
        salesOrderId = json['sales_order_id'] as String?,
        excType = json['exc_type'] as String?,
        serverMessages = json['_server_messages'] as String?,
        orderItems = (json['order_items'] as List?)
            ?.map((dynamic e) => OrderItems.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'status_code': statusCode,
        'date': date,
        'posting_time': postingTime,
        'status': status,
        'sales_order_id': salesOrderId,
        'order_items': orderItems?.map((e) => e.toJson()).toList()
      };

  @override
  toString() {
    return """DirectOrderResponse (message: $message, error: $error, statusCode: $statusCode, date: $date, postingTime:$postingTime,
              status: $status, salesOrderStatus: $salesOrderStatus, extraCharges: $extraCharges, grandTotal: $grandTotal,
              owner: $owner, currency: $currency, sales_order_id: $salesOrderId, orderItems: $orderItems, excType: $excType, serverMessages: $serverMessages"
  )""";
  }
}

class OrderItems {
  String? websiteItemName;
  String? websiteItemCode;
  String? quantity;
  String? itemImage;
  String? backgroundColor;

  String? totalAmount;
  List<StockDetails>? digitalCardDetails;

  OrderItems({
    this.websiteItemName,
    this.websiteItemCode,
    this.quantity,
    this.itemImage,
    this.backgroundColor,
    this.totalAmount,
    this.digitalCardDetails,
  });

  OrderItems.fromJson(Map<String, dynamic> json)
      : websiteItemName = json['website_item_name'] as String?,
        websiteItemCode = json['website_item_code'] as String?,
        quantity = json['quantity'].toString(),
        itemImage =
            json['website_item_image'] as String? ?? "/files/foreground.png",
        backgroundColor = json['background_color'] as String? ?? "#7c5aa6",
        totalAmount = json['total_amount'].toString(),
        digitalCardDetails = (json['digital_card_details'] as List?)
            ?.map(
                (dynamic e) => StockDetails.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'website_item_name': websiteItemName,
        'website_item_code': websiteItemCode,
        'quantity': quantity,
        'item_image': itemImage,
        'total_amount': totalAmount,
        'stock_details': digitalCardDetails?.map((e) => e.toJson()).toList()
      };

  @override
  toString() {
    return """OrderItems(websiteItemNameL $websiteItemName, websiteItemCode: $websiteItemCode, quantity: $quantity, 
            itemImage: $itemImage,  backgroundColor: $backgroundColor, totalAmount: $totalAmount, 
            stockDetails: $digitalCardDetails""";
  }
}

class StockDetails {
  final String? secretCode;
  final String? serialNo;
  final String? refNo;

  StockDetails({
    this.secretCode,
    this.serialNo,
    this.refNo,
  });

  StockDetails.fromJson(Map<String, dynamic> json)
      : secretCode = json['secret_code'] as String?,
        serialNo = json['serial_no'] as String?,
        refNo = json['reference_no'] as String?;

  Map<String, dynamic> toJson() =>
      {'secret_code': secretCode, 'serial_no': serialNo, 'reference_no': refNo};
  @override
  toString() {
    return """StockDetails (secretCode:$secretCode, serialNo: $serialNo , refNo: $refNo)""";
  }
}
