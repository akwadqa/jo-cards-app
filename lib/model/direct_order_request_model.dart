class DirectOrderRequest {
   String? websiteItemCode;
   int? qty;
   String? itemUom;
   List<RProductOptions>? productOptions;

  DirectOrderRequest({
    this.websiteItemCode,
    this.qty,
    this.itemUom,
    this.productOptions,
  });

  DirectOrderRequest.fromJson(Map<String, dynamic> json)
    : websiteItemCode = json['website_item_code'] as String?,
      qty = json['qty'] as int?,
      itemUom = json['item_uom'] as String?,
      productOptions = (json['product_options'] as List?)?.map((dynamic e) => RProductOptions.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'website_item_code' : websiteItemCode,
    'qty' : qty,
    'item_uom' : itemUom,
    if(productOptions!=null)
    'product_options' : productOptions?.map((e) => e.toJson()).toList()
  };
}

class RProductOptions {
   String? optionName;
   String? optionValue;
   int? isPriceModifier;

  RProductOptions({
    this.optionName,
    this.optionValue,
    this.isPriceModifier,
  });

  RProductOptions.fromJson(Map<String, dynamic> json)
    : optionName = json['option_name'] as String?,
      optionValue = json['option_value'] as String?,
      isPriceModifier = json['is_price_modifier'] as int?;

  Map<String, dynamic> toJson() => {
    'option_name' : optionName,
    'option_value' : optionValue,
    'is_price_modifier' : isPriceModifier
  };
}

class DirectOrderList {
  final List<DirectOrderRequest>? items;

  DirectOrderList({
    this.items,
  });

  DirectOrderList.fromJson(Map<String, dynamic> json)
      : items = (json['items'] as List?)?.map((dynamic e) => DirectOrderRequest.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'items' : items?.map((e) => e.toJson()).toList()
  };
}
