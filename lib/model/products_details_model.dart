class ProductsDetailsModel {
  final int? statusCode;
  final String? message;
  final List<ProductsDetailsData>? data;

  ProductsDetailsModel({
    this.statusCode,
    this.message,
    this.data,
  });

  ProductsDetailsModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['data'] as List?)?.map((dynamic e) => ProductsDetailsData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class ProductsDetailsData {
  final String? websiteItemId;
  final String? itemCode;
  final String? websiteItemName;
  final String? itemGroup;
  final String? stockUom;
  final String? mobileDefaultUom;
  final String? itemDescription;
  final String? backgroundColor;
  final int? published;
  final String? websiteImage;
  final String? shortDescription;
  final String? webLongDescription;
  final String? itemPrice;
  final String? currency;
  final String? discountPercent;
  final String? discountAmount;
  final String? discountedPrice;
  final int? inStock;
  final List<ProductOptions>? productOptions;
  final String? minimumOrderQuantities;
  final String? maximumOrderQuantities;

  ProductsDetailsData({
    this.websiteItemId,
    this.itemCode,
    this.websiteItemName,
    this.itemGroup,
    this.stockUom,
    this.mobileDefaultUom,
    this.itemDescription,
    this.backgroundColor,
    this.published,
    this.websiteImage,
    this.shortDescription,
    this.webLongDescription,
    this.itemPrice,
    this.currency,
    this.discountPercent,
    this.discountAmount,
    this.discountedPrice,
    this.inStock,
    this.productOptions,
    this.minimumOrderQuantities,
    this.maximumOrderQuantities
  });

  ProductsDetailsData.fromJson(Map<String, dynamic> json)
    : websiteItemId = json['website_item_id'] as String?,
      itemCode = json['item_code'] as String?,
      websiteItemName = json['website_item_name'] as String?,
      itemGroup = json['item_group'] as String?,
      stockUom = json['stock_uom'] as String?,
      mobileDefaultUom = json['mobile_default_uom'] as String?,
      itemDescription = json['item_description'] as String?,
      backgroundColor = json['background_color'] as String? ?? "#7c5aa6",
      published = json['published'] as int?,
      websiteImage = json['website_image'] as String? ?? "/files/foreground.png",
      shortDescription = json['short_description'] as String?,
      webLongDescription = json['web_long_description'] as String?,
      itemPrice = json['item_price'].toString(),
      currency = json['currency'] as String?,
      discountPercent = json['discount_percent'] as String?,
      discountAmount = json['discount_amount'].toString(),
      discountedPrice = json['discounted_price'].toString(),
      inStock = json['in_stock'] as int?,
      minimumOrderQuantities = json["minimum_order_quantities"] as String?,
      maximumOrderQuantities = json["maximum_order_quantities"] as String?,
      productOptions = (json['product_options'] as List?)?.map((dynamic e) => ProductOptions.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'website_item_id' : websiteItemId,
    'item_code' : itemCode,
    'website_item_name' : websiteItemName,
    'item_group' : itemGroup,
    'stock_uom' : stockUom,
    'mobile_default_uom' : mobileDefaultUom,
    'item_description' : itemDescription,
    'background_color' : backgroundColor,
    'published' : published,
    'website_image' : websiteImage,
    'short_description' : shortDescription,
    'web_long_description' : webLongDescription,
    'item_price' : itemPrice,
    'currency' : currency,
    'discount_percent' : discountPercent,
    'discount_amount' : discountAmount,
    'discounted_price' : discountedPrice,
    'in_stock' : inStock,
    "minimum_order_quantities" : minimumOrderQuantities,
    'product_options' : productOptions?.map((e) => e.toJson()).toList()
  };
}

class ProductOptions {
  final String? optionName;
  final String? optionType;
  final int? isMandatory;
  final String? weightage;
   String? answer;
  final int? isPriceModifier;
  final String? hint;
  final String? textInput;
  final String? numberInputValue;
  final String? viewOption;
  final dynamic percentage;
  final List<RadioGroupOption>? radioGroupOption;

  ProductOptions({
    this.optionName,
    this.answer,
    this.optionType,
    this.isMandatory,
    this.weightage,
    this.isPriceModifier,
    this.hint,
    this.textInput,
    this.numberInputValue,
    this.viewOption,
    this.percentage,
    this.radioGroupOption,
  });

  ProductOptions.fromJson(Map<String, dynamic> json)
    : optionName = json['option_name'] as String?,
      optionType = json['option_type'] as String?,
      answer = json['answer'] as String?,
      isMandatory = json['is_mandatory'] as int?,
      weightage = json['weightage'] as String?,
      isPriceModifier = json['is_price_modifier'] as int?,
      hint = json['hint'] as String?,
      textInput = json['text_input'] as String?,
      numberInputValue = json['number_input_value'].toString(),
      viewOption = json['view_option'] as String?,
      percentage = json["percentage"] as dynamic,
        radioGroupOption = (json['radio_group_option'] as List?)?.map((dynamic e) => RadioGroupOption.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'option_name' : optionName,
    'option_type' : optionType,
    'is_mandatory' : isMandatory,
    'weightage' : weightage,
    'is_price_modifier' : isPriceModifier,
    'hint' : hint,
    'text_input' : textInput,
    'number_input_value' : numberInputValue,
    'view_option' : viewOption,
    "percentage" : percentage,
    'radio_group_option' : radioGroupOption?.map((e) => e.toJson()).toList()

  };
}
class RadioGroupOption {
  final String? name1;
   bool? selected;

  RadioGroupOption({
    this.name1,this.selected
  });

  RadioGroupOption.fromJson(Map<String, dynamic> json)
      : name1 = json['name1'] as String?,
        selected = json['selected']!=null ?json['selected']:false;

  Map<String, dynamic> toJson() => {
    'name1' : name1,
    'selected':selected
  };
}