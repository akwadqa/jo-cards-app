class CategoriesModel {
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  CategoriesModel({
    this.statusCode,
    this.message,
    this.data,
  });

  CategoriesModel.fromJson(Map<String, dynamic> json)
    : statusCode = json['status_code'] as int?,
      message = json['message'] as String?,
      data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? itemGroupId;
  final String? parentItemGroup;
  final String? backgroundColor;
  final dynamic categoryView;
  final String? route;
  final String? image;
  final int? weightage;
  final dynamic websiteTitle;
  final dynamic description;
  final int? isGroup;
  final List<SubCategories>? subCategories;

  Data({
    this.itemGroupId,
    this.parentItemGroup,
    this.backgroundColor,
    this.categoryView,
    this.route,
    this.image,
    this.weightage,
    this.websiteTitle,
    this.description,
    this.isGroup,
    this.subCategories,
  });

  Data.fromJson(Map<String, dynamic> json)
    : itemGroupId = json['item_group_id'] as String?,
      parentItemGroup = json['parent_item_group'] as String?,
      backgroundColor = json['background_color'] as String? ?? "#7c5aa6",
      categoryView = json['category_view'],
      route = json['route'] as String?,
      image = json['image'] as String?,
      weightage = json['weightage'] as int?,
      websiteTitle = json['website_title'],
      description = json['description'],
      isGroup = json['is_group'] as int?,
      subCategories = (json['sub_categories'] as List?)?.map((dynamic e) => SubCategories.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'item_group_id' : itemGroupId,
    'parent_item_group' : parentItemGroup,
    'background_color' : backgroundColor,
    'category_view' : categoryView,
    'route' : route,
    'image' : image,
    'weightage' : weightage,
    'website_title' : websiteTitle,
    'description' : description,
    'is_group' : isGroup,
    'sub_categories' : subCategories?.map((e) => e.toJson()).toList()
  };
}

class SubCategories {
  final String? itemGroupId;
  final String? parentItemGroup;
  final String? backgroundColor;
  final dynamic categoryView;
  final String? route;
  final String? image;
  final int? weightage;
  final dynamic websiteTitle;
  final dynamic description;
  final int? isGroup;

  SubCategories({
    this.itemGroupId,
    this.parentItemGroup,
    this.backgroundColor,
    this.categoryView,
    this.route,
    this.image,
    this.weightage,
    this.websiteTitle,
    this.description,
    this.isGroup,
  });

  SubCategories.fromJson(Map<String, dynamic> json)
    : itemGroupId = json['item_group_id'] as String?,
      parentItemGroup = json['parent_item_group'] as String?,
      backgroundColor = json['background_color'] as String? ?? "#7c5aa6",
      categoryView = json['category_view'],
      route = json['route'] as String?,
      image = json['image'] as String? ?? "/files/foreground.png",
      weightage = json['weightage'] as int?,
      websiteTitle = json['website_title'],
      description = json['description'],
      isGroup = json['is_group'] as int?;

  Map<String, dynamic> toJson() => {
    'item_group_id' : itemGroupId,
    'parent_item_group' : parentItemGroup,
    'background_color' : backgroundColor,
    'category_view' : categoryView,
    'route' : route,
    'image' : image,
    'weightage' : weightage,
    'website_title' : websiteTitle,
    'description' : description,
    'is_group' : isGroup
  };
}