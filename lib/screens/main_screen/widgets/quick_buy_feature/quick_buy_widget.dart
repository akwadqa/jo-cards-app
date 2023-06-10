import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/price_widget.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/sub_categories_list.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/titled_list.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/types_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:jocards/screens/widget/error.dart';

import '../../../../Network/api_response.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../model/direct_order_request_model.dart';
import '../../../../model/direct_order_response.dart';
import '../../../../model/home_model.dart';
import '../../../../model/item_category_model.dart';
import '../../../../model/products_details_model.dart';
import '../../../../provider/app_provider.dart';
import '../../../../provider/home_provider.dart';
import '../../../../res.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/strings.dart';
import '../../../../utill/utitlities.dart';
import '../../../../utill/widget_size.dart';
import '../../../auth/sign_in_screen.dart';
import '../../../widget/loading.dart';
import '../../../widget/safe_on_tap.dart';
import '../../main_screen.dart';
import '../../print_screen.dart';
import '../../product_details.dart';
import 'custom_button.dart';

class QuickBuyWidget extends StatelessWidget {
  const QuickBuyWidget({Key? key, required this.homeBlockData})
      : super(key: key);
  final HomeBlockData homeBlockData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(widgetSize.getHeight(30, context)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.noun_shopping_cart),
                SizedBox(width: widgetSize.getWidth(5, context)),
                const Text('الشراء السريع',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: widgetSize.getHeight(30, context)),
            Chip(
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Text(homeBlockData.categoryName!,
                      style: const TextStyle(color: Colors.white)),
                ),
                backgroundColor: ColorResources.darkGrayishBlue),
            SizedBox(height: widgetSize.getHeight(20, context)),
            TitledList(
                title: 'الفئة الفرعية',
                child: SubCategoriesList(
                  subCategories: homeBlockData.subCategories!,
                  onCategorySelected: (SubCategories subCategory) {
                    context
                        .read<HomeProvider>()
                        .getItemPerCat(subCategory.name!);
                    context.read<HomeProvider>().productDetailsResponse = null;
                  },
                )),
            SizedBox(height: widgetSize.getHeight(15, context)),
            TitledList(
                height: 120,
                title: 'النوع',
                child: Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) {
                  if (homeProvider.itemCategoryResponse != null) {
                    switch (homeProvider.itemCategoryResponse!.status!) {
                      case Status.LOADING:
                        return Loading(
                            loadingText:
                                homeProvider.itemCategoryResponse!.message);

                      case Status.COMPLETED:
                        List<Data>? items =
                            homeProvider.itemCategoryResponse?.data?.data;
                        if (items != null) {
                          return TypesList(
                              items: items,
                              onItemSelected: (Data item) async {
                                await context
                                    .read<HomeProvider>()
                                    .getProductDetails(item.websiteItemId!);
                              });
                        } else {
                          return Container();
                        }

                      case Status.ERROR:
                        return Error(
                            errorMsg: homeProvider.homsResponse!.message);
                    }
                  }
                  return Container();
                })),
            SizedBox(height: widgetSize.getHeight(30, context)),
            Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              if (homeProvider.productDetailsResponse != null) {
                switch (homeProvider.productDetailsResponse!.status!) {
                  case Status.LOADING:
                    return Align(
                      child: Loading(
                          loadingText:
                              homeProvider.productDetailsResponse!.message),
                    );

                  case Status.COMPLETED:
                    var item =
                        homeProvider.productDetailsResponse?.data?.data?[0];
                    double totalPrice = double.parse(item!.discountedPrice!);
                    int count = 1;
                    if (item.productOptions != null &&
                        item.productOptions!.isNotEmpty) {
                      return CustomButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ProductDetailsScreen(
                                  item.websiteItemName!, item.websiteItemId!),
                            ),
                          );
                        },
                        title: 'تحديد الخيارات',
                      );
                    }
                    bool moreThanAvailableWalletBalance = false;
                    if (context.read<AppProvider>().utilitiesModel != null &&
                        context.read<AppProvider>().utilitiesModel!.data !=
                            null &&
                        context
                                .read<AppProvider>()
                                .utilitiesModel!
                                .data!
                                .walletBalance !=
                            null &&
                        context
                            .read<AppProvider>()
                            .utilitiesModel!
                            .data!
                            .walletBalance!
                            .isNotEmpty) {
                      var walletBalance = double.parse(context
                          .read<AppProvider>()
                          .utilitiesModel!
                          .data!
                          .walletBalance!);
                      if (totalPrice > walletBalance) {
                        moreThanAvailableWalletBalance = true;
                      } else {
                        moreThanAvailableWalletBalance = false;
                      }
                    }
                    return Column(
                      children: [
                        PriceWidget(
                          price: double.parse(item.discountedPrice!),
                          getTotalPriceAndCount:
                              (double totalPrice, int quantity) {
                            totalPrice = totalPrice;
                            count = quantity;
                          },
                          productsDetailsData: item,
                        ),
                        SizedBox(height: widgetSize.getHeight(16, context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                                onPressed: !moreThanAvailableWalletBalance &&
                                        double.parse(item.discountedPrice!) !=
                                            0.0
                                    ? () async {
                                        if (!moreThanAvailableWalletBalance) {
                                          if (context
                                                  .read<AppProvider>()
                                                  .getUserInfo() !=
                                              null) {
                                            await directOrderRequest(
                                                item, count, context);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInScreen(
                                                          fromSetting: true,
                                                        )));
                                          }
                                        }
                                      }
                                    : null,
                                title: !moreThanAvailableWalletBalance &&
                                        double.parse(item.discountedPrice!) !=
                                            0.0
                                    ? 'شراء البطاقة'
                                    : 'لا يوجد رصيد كافي'),
                            CustomButton(
                                onPressed: () => Navigator.of(context).pop(),
                                title: 'إلغاء',
                                backgroundColor: MaterialStateProperty.all(
                                    ColorResources.veryLightShadeOfGray),
                                foregroundColor: MaterialStateProperty.all(
                                    ColorResources.gray61)),
                          ],
                        )
                      ],
                    );

                  case Status.ERROR:
                    return Error(
                        errorMsg: homeProvider.productDetailsResponse!.message);
                }
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }

  directOrderRequest(
      ProductsDetailsData item, int count, BuildContext context) async {
    List<DirectOrderRequest> directOrderList = [];
    DirectOrderRequest directOrderRequest = DirectOrderRequest();
    directOrderRequest.websiteItemCode = item.websiteItemId;
    directOrderRequest.orderType = "Direct Order";
    directOrderRequest.itemUom = item.stockUom;
    directOrderRequest.qty = count;
    if (item.productOptions != null && item.productOptions!.isNotEmpty) {
      directOrderRequest.productOptions = [];
      for (ProductOptions p in item.productOptions!) {
        directOrderRequest.productOptions!.add(RProductOptions(
            optionName: p.optionName,
            optionValue: p.answer,
            isPriceModifier: p.isPriceModifier));
      }
    } else {
      directOrderRequest.productOptions = [];
    }
    directOrderList.add(directOrderRequest);
    ApiResponse<DirectOrderResponse> resultOfConfirmDirectOrder =
        await confirmDirectOrder(
            context, directOrderRequest, item, directOrderList, count);

    if (resultOfConfirmDirectOrder.status == Status.COMPLETED) {
      if (resultOfConfirmDirectOrder.data != null &&
          resultOfConfirmDirectOrder.data!.error == null) {
        if (context.read<AppProvider>().getEnablePrintAuto()) {
          if (!androidInfo.model.contains("TPS")) {
            await printOnBluetoothPrinter(
                resultOfConfirmDirectOrder.data!,
                context.read<AppProvider>().getEnableMerchantNamePrint()
                    ? context.read<AppProvider>().utilitiesModel
                    : null,
                context);
          } else {
            await printOnTelpo(
                resultOfConfirmDirectOrder.data!,
                context.read<AppProvider>().getEnableMerchantNamePrint()
                    ? context.read<AppProvider>().utilitiesModel
                    : null,
                context);
          }
        }
        var orderReceiptResult = await showDialog(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                  builder: (context, setState) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    //this right here
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widgetSize.getWidth(10, context)),
                      child: Stack(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(
                                height: widgetSize.getHeight(20, context),
                              ),
                              Row(
                                children: [
                                  SafeOnTap(
                                      onSafeTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                          Assets.svgCancelDirectOrder)),
                                  const Spacer(),
                                  Text(
                                    'تفاصيل الطلب',
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(20, context),
                                      color: const Color(0xff2e2e2e),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: false,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(25, context),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfff6f6f6),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffe8e8e8)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: widgetSize.getHeight(20, context),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: Strings.BASR_URl +
                                                    resultOfConfirmDirectOrder
                                                        .data!
                                                        .orderItems![0]
                                                        .itemImage!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: hexToColor(
                                                            resultOfConfirmDirectOrder
                                                                .data!
                                                                .orderItems![0]
                                                                .backgroundColor!),
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.contain),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorResources
                                                                  .studio)),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!
                                                    .orderItems![0]
                                                    .websiteItemName!,
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 16,
                                                  color: Color(0xff2e2e2e),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    25, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              const Text(
                                                'رقم الطلب',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 12,
                                                  color:
                                                      Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.invoiceId!,
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color:
                                                      Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                softWrap: true,
                                                maxLines: 2,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              const Text(
                                                'حالة الطلب',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 12,
                                                  color:
                                                      Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.salesOrderStatus
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color:
                                                      Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.postingTime!
                                                    .split('.')[0]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(16, context),
                                                  color:
                                                      const Color(0xff6b6b6b),
                                                ),
                                                softWrap: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.grandTotal!
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 22,
                                                  color:
                                                      Color(0xffec7e7e),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.currency!
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 18,
                                                  color:
                                                      Color(0xffec7e7e),
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              const Text(
                                                'الكمية',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 12,
                                                  color:
                                                      Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder.data!
                                                    .orderItems![0].quantity!
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color:
                                                      Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!.date!
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(14, context),
                                                  color:
                                                      const Color(0xff6b6b6b),
                                                ),
                                                softWrap: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(15, context),
                              ),
                              ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: resultOfConfirmDirectOrder
                                      .data!.orderItems![0].stockDetails!
                                      .map<Widget>((data) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Text(
                                            'الرقم السري',
                                            style: TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 14,
                                              color: Color(0xff979797),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                          SizedBox(
                                            height: widgetSize.getHeight(
                                                5, context),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Spacer(),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  data.secretCode!,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 23,
                                                    color:
                                                        Color(0xffec7e7e),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Expanded(
                                                child: SafeOnTap(
                                                    onSafeTap: () async {
                                                      await Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  data.secretCode ??
                                                                      ''));
                                                      var snackBar = const SnackBar(
                                                          content:
                                                              Text("تم النسخ"));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: SvgPicture.asset(
                                                        Assets.svgCopy)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: widgetSize.getHeight(
                                                5, context),
                                          ),
                                          const Text(
                                            'رقم المرجع',
                                            style: TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 13,
                                              color: Color(0xff979797),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                          Text(
                                            data.refNo!,
                                            style: const TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 16,
                                              color: Color(0xff2e2e2e),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: false,
                                          ),
                                          SizedBox(
                                            height: widgetSize.getHeight(
                                                5, context),
                                          ),
                                          const Text(
                                            'الرقم التسلسلي',
                                            style: TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 13,
                                              color: Color(0xff979797),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                          Text(
                                            data.serialNo!,
                                            style: const TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 16,
                                              color: Color(0xff2e2e2e),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: false,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()),
                              SizedBox(
                                height: widgetSize.getHeight(20, context),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SafeOnTap(
                                      onSafeTap: () async {
                                        await shareOrder(
                                            resultOfConfirmDirectOrder.data!,
                                            context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff9f9f9),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xfff3f3f3)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                            SvgPicture.asset(Assets.svgShare),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                            const Text(
                                              'مشاركة',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 11,
                                                color: Color(0xff6b6b6b),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widgetSize.getWidth(10, context),
                                  ),
                                  Visibility(
                                    visible: Platform.isAndroid,
                                    child: Expanded(
                                      child: SafeOnTap(
                                        onSafeTap: () async {
                                          if (androidInfo.model.contains("TPS")) {
                                            await printOnTelpo(
                                                resultOfConfirmDirectOrder
                                                    .data!,
                                                context
                                                        .read<AppProvider>()
                                                        .getEnableMerchantNamePrint()
                                                    ? context
                                                        .read<AppProvider>()
                                                        .utilitiesModel
                                                    : null,
                                                context);
                                          } else {
                                            if (context
                                                    .read<AppProvider>()
                                                    .getBluetoothDevice() ==
                                                null) {
                                              await Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: PrintScreen(
                                                      resultOfConfirmDirectOrder
                                                          .data!),
                                                ),
                                              );
                                            } else {
                                              await printOnBluetoothPrinter(
                                                  resultOfConfirmDirectOrder
                                                      .data!,
                                                  context
                                                          .read<AppProvider>()
                                                          .getEnableMerchantNamePrint()
                                                      ? context
                                                          .read<AppProvider>()
                                                          .utilitiesModel
                                                      : null,
                                                  context);
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff9f9f9),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xfff3f3f3)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              SvgPicture.asset(
                                                  Assets.svgPrinterIcon),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              const Text(
                                                'طباعة البطاقة',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 11,
                                                  color:
                                                      Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widgetSize.getWidth(10, context),
                                  ),
                                  Expanded(
                                    child: SafeOnTap(
                                      onSafeTap: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff9f9f9),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xfff3f3f3)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                            SvgPicture.asset(
                                                Assets.svgHomeDialog),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                            const Text(
                                              'الرئيسية',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 11,
                                                color: Color(0xff6b6b6b),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(20, context),
                              ),
                            ],
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Visibility(
                                  visible: Provider.of<HomeProvider>(context,
                                          listen: true)
                                      .isLoading,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              ColorResources.studio),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
        if (orderReceiptResult != null && orderReceiptResult) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const SharedBottomNavigationBar(widget: MainScreen()),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(
            backgroundColor: ColorResources.studio,
            textColor: Colors.white,
            msg: resultOfConfirmDirectOrder.data!.message!,
            timeInSecForIosWeb: 4,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  confirmDirectOrder(
      BuildContext context,
      DirectOrderRequest directOrderRequest,
      ProductsDetailsData item,
      List<DirectOrderRequest> directOrderList,
      int count) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              //this right here
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widgetSize.getWidth(20, context)),
                child: Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: widgetSize.getHeight(20, context),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: SafeOnTap(
                                    onSafeTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: SvgPicture.asset(
                                        Assets.svgCancelDirectOrder)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'ملخص  الطلب',
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: widgetSize.getHeight(20, context),
                                    color: const Color(0xff2e2e2e),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: widgetSize.getHeight(25, context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.websiteItemName != null
                                  ? item.websiteItemName!
                                  : "",
                              style: TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: widgetSize.getHeight(20, context),
                                color: const Color(0xff2e2e2e),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: false,
                            ),
                            SizedBox(
                              height: widgetSize.getHeight(10, context),
                            ),
                            if (directOrderRequest.qty != null) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "الكمية : ",
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(16, context),
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    softWrap: false,
                                  ),
                                  Text(
                                    directOrderRequest.qty != null
                                        ? directOrderRequest.qty.toString()
                                        : "",
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(16, context),
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    softWrap: false,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            if (item.itemPrice != null) ...[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${double.parse(item.discountedPrice!) * count}',
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: widgetSize.getHeight(22, context),
                                    color: const Color(0xffec7e7e),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            if (directOrderRequest.productOptions != null &&
                                directOrderRequest
                                    .productOptions!.isNotEmpty) ...[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: directOrderRequest.productOptions!
                                      .map<Widget>((e) {
                                    if (e.optionValue != null &&
                                        e.optionValue!.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.optionName!} : ",
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    16, context),
                                                color: const Color(0xff2e2e2e),
                                              ),
                                              softWrap: true,
                                            ),
                                            Text(
                                              e.optionValue!,
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    16, context),
                                                color: const Color(0xff2e2e2e),
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }).toList()),
                              SizedBox(
                                height: widgetSize.getHeight(20, context),
                              ),
                            ],
                            if (item.discountAmount != null &&
                                item.discountAmount != "0.0") ...[
                              Text(
                                item.discountAmount!,
                                style: const TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: 20,
                                  color: Color(0xffec7e7e),
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: false,
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfff6f6f6),
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xffe8e8e8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'الرصيد الحالي',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff2e2e2e),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(
                                      width: widgetSize.getWidth(60, context),
                                    ),
                                    Text(
                                      context
                                          .read<AppProvider>()
                                          .utilitiesModel!
                                          .data!
                                          .walletBalance!,
                                      style: const TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: 16,
                                        color: Color(0xff2e2e2e),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: widgetSize.getHeight(30, context),
                            ),
                            Consumer<HomeProvider>(
                                builder: (context, state, child) {
                              return SafeOnTap(
                                onSafeTap: () async {
                                  if (!state.isLoading) {
                                    var res = await context
                                        .read<HomeProvider>()
                                        .directOrder(directOrderList);

                                    if (res.status == Status.COMPLETED) {
                                      Navigator.pop(context, res);
                                      context
                                          .read<AppProvider>()
                                          .getUtilities();
                                    } else {
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              ColorResources.studio,
                                          textColor: Colors.white,
                                          msg: res.message ?? "",
                                          timeInSecForIosWeb: 4,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          widgetSize.getHeight(30, context)),
                                  height: widgetSize.getHeight(50, context),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: state.isLoading
                                        ? Colors.grey
                                        : const Color(0xff2892d7),
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: state.isLoading
                                            ? Colors.grey
                                            : const Color(0xff2892d7)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x401d4c9b),
                                        offset: Offset(0, 5),
                                        blurRadius: 11,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'تأكيد الشراء',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize:
                                            widgetSize.getHeight(20, context),
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: widgetSize.getHeight(20, context),
                            )
                          ],
                        )
                      ],
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Visibility(
                            visible:
                                Provider.of<HomeProvider>(context, listen: true)
                                    .isLoading,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorResources.studio),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
