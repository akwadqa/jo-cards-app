import 'package:flutter/cupertino.dart';

class HomeModel {
  final int? statusCode;
  final String? message;
  final List<HomeBlock>? homeBlock;

  HomeModel({
    this.statusCode,
    this.message,
    this.homeBlock,
  });

  HomeModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        homeBlock = (json['home_block'] as List?)?.map((dynamic e) => HomeBlock.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status_code' : statusCode,
    'message' : message,
    'home_block' : homeBlock?.map((e) => e.toJson()).toList()
  };
}

class HomeBlock extends ChangeNotifier {
  final String? id;
  final String? type;
  final String? background;
  final String? title;
  bool? expanded;
  final dynamic view;
  final List<HomeBlockData>? data;

  HomeBlock({
    this.id,
    this.type,
    this.title,
    this.expanded,
    this.background,
    this.view,
    this.data,
  });


  HomeBlock.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        type = json['type'] as String?,
        title = json['title'] as String?,
        expanded = json['expanded']!=null?json['expanded']:true ,
        background = json['background'] as String?,
        view = json['view'],
        data = (json['data'] as List?)?.map((dynamic e) => HomeBlockData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'type' : type,
    'background' : background,
    'view' : view,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class HomeBlockData {
  final String? bannerImage;
  final String? bannerType;
  final dynamic bannerView;
  final dynamic viewId;
  final String? bannerLink;
  final String? categoryImage;
  final String? backgroundColor;
  final String? categoryName;
  final String? categoryTitle;
  final String? categoryRoute;
  final String? categoryView;
  final int? categoryWeightage;
  final List<SubCategories>? subCategories;
  HomeBlockData({
    this.bannerImage,
    this.bannerType,
    this.bannerView,
    this.viewId,
    this.bannerLink,
    this.categoryImage,
    this.backgroundColor,
    this.categoryName,
    this.categoryTitle,
    this.categoryRoute,
    this.categoryView,
    this.categoryWeightage,
    this.subCategories
  });

  HomeBlockData.fromJson(Map<String, dynamic> json)
      : bannerImage = json['banner_image'] as String?,
        bannerType = json['banner_type'] as String?,
        bannerView = json['banner_view'],
        viewId = json['view_id'],
        bannerLink = json['banner_link'] as String?,
        categoryImage = json['category_image'] as String?,
        backgroundColor = json['background_color'] as String?,
        categoryName = json['category_name'] as String?,
        categoryTitle = json['category_title'] as String?,
        categoryRoute = json['category_route'] as String?,
        categoryView = json['category_view'] as String?,
        categoryWeightage = json['category_weightage'] as int?,
        subCategories = (json['sub_categories'] as List?)?.map((dynamic e) => SubCategories.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'banner_image' : bannerImage,
    'banner_type' : bannerType,
    'banner_view' : bannerView,
    'view_id' : viewId,
    'banner_link' : bannerLink
  };
}
class SubCategories {
  final String? name;
  final dynamic image;
  final dynamic backgroundColor;
  final dynamic websiteTitle;
  final String? route;
  final dynamic categoryView;
  final int? weightage;

  SubCategories({
    this.name,
    this.image,
    this.backgroundColor,
    this.websiteTitle,
    this.route,
    this.categoryView,
    this.weightage,
  });

  SubCategories.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        image = json['image'],
        backgroundColor = json['background_color'],
        websiteTitle = json['website_title'],
        route = json['route'] as String?,
        categoryView = json['category_view'],
        weightage = json['weightage'] as int?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'image' : image,
    'background_color' : backgroundColor,
    'website_title' : websiteTitle,
    'route' : route,
    'category_view' : categoryView,
    'weightage' : weightage
  };
}