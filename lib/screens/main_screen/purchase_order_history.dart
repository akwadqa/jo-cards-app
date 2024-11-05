import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/model/categories_model.dart';
import 'package:jocards/model/invoice_order_details.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/model/sales_invoice_response_model.dart';
import 'package:jocards/screens/main_screen/print_screen.dart';
import 'package:jocards/screens/main_screen/widgets/search/search_component.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../model/direct_order_response.dart';
import '../../provider/app_provider.dart';
import '../../provider/home_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/strings.dart';
import '../../utill/utitlities.dart';
import '../../utill/widget_size.dart';
import '../widget/error.dart';
import '../widget/loading.dart';
import '../widget/safe_on_tap.dart';

class PurchaseOrderHistory extends StatefulWidget {
  const PurchaseOrderHistory({super.key});

  @override
  _PurchaseOrderHistoryState createState() => _PurchaseOrderHistoryState();
}

// si ===> instead
class _PurchaseOrderHistoryState extends State<PurchaseOrderHistory> {
  String filters = '{}';
  LoginResponseModel? userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteSmoke,
      appBar: buildAppBar(context),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widgetSize.getWidth(15, context)),
          child: RefreshIndicator(
            onRefresh: () => Future.sync(() {
              filters = '{}';
              context
                  .read<HomeProvider>()
                  .salesInvoiceDataPagingController
                  ?.refresh();
              context.read<AppProvider>().getUtilities();
            }),
            child: CustomScrollView(slivers: <Widget>[
              // SliverToBoxAdapter(
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: Padding(
              //         padding: EdgeInsets.only(
              //             top: widgetSize.getHeight(20, context)),
              //         child: const MyWallet()
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widgetSize.getHeight(20, context)),
                    child: Text(
                      'الطلبات',
                      style: TextStyle(
                        fontFamily: 'DIN Next LT W23',
                        fontSize: widgetSize.getHeight(19, context),
                        color: const Color(0xff2e2e2e),
                        fontWeight: FontWeight.w700,
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: SearchComponent(
                searchType: SearchType.salesRequests,
                onSearch: (String filters) {
                  this.filters = filters;
                  context
                      .read<HomeProvider>()
                      .salesInvoiceDataPagingController!
                      .refresh();
                },
              )),
              SliverToBoxAdapter(
                  child: SizedBox(height: widgetSize.getHeight(10, context))),
              PagedSliverList<int, SalesInvoiceData>(
                  shrinkWrapFirstPageIndicators: false,
                  pagingController: context
                      .read<HomeProvider>()
                      .salesInvoiceDataPagingController!,
                  builderDelegate: PagedChildBuilderDelegate<SalesInvoiceData>(
                      firstPageProgressIndicatorBuilder: (_) =>
                          Loading(loadingText: ""),
                      newPageProgressIndicatorBuilder: (_) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Loading(loadingText: ""),
                          ),
                      noMoreItemsIndicatorBuilder: (_) => Container(),
                      noItemsFoundIndicatorBuilder: (_) => Container(
                            child: Center(
                              child: Text(
                                'لايوجد طلبات',
                                style: TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: widgetSize.getHeight(19, context),
                                  color: const Color(0xff2e2e2e),
                                ),
                                softWrap: false,
                              ),
                            ),
                          ),
                      firstPageErrorIndicatorBuilder: (_) => Error(
                          errorMsg:
                              Provider.of<HomeProvider>(context, listen: false)
                                  .salesInvoiceDataPagingController!
                                  .error!
                                  .toString()),
                      itemBuilder: (context, item, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xffe5e5e5)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        widgetSize.getWidth(12, context)),
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
                                        SizedBox(
                                          width:
                                              widgetSize.getWidth(10, context),
                                        ),
                                        Column(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: Strings.BASR_URl +
                                                  item.items![0].webSiteImage!,
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
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      shape: BoxShape.rectangle,
                                                      color: item.items![0]
                                                                  .backgroundColor !=
                                                              null
                                                          ? hexToColor(item
                                                              .items![0]
                                                              .backgroundColor!)
                                                          : Colors.white,
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.contain),
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
                                            LimitedBox(
                                              maxWidth: widgetSize.getWidth(
                                                  100, context),
                                              child: Text(
                                                item.items![0].itemName!,
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
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  25, context),
                                            ),
                                            SafeOnTap(
                                              onSafeTap: () async {
                                                context
                                                    .read<HomeProvider>()
                                                    .getPurchaseInvoiceDetails(
                                                        item.salesInvoiceId
                                                            .toString())
                                                    .then((result) {
                                                  if (result.data != null &&
                                                      result.data!.data !=
                                                          null) {
                                                    var response =
                                                        result.data!.data!;
                                                    directOrderResponse
                                                            .currency =
                                                        response.currency;
                                                    directOrderResponse
                                                            .grandTotal =
                                                        response.grandTotal;
                                                    directOrderResponse.date =
                                                        response.date;
                                                    directOrderResponse
                                                            .postingTime =
                                                        response.postingTime;
                                                    directOrderResponse.owner =
                                                        response.owner;
                                                    directOrderResponse
                                                            .salesOrderId =
                                                        response.salesOrderId;
                                                    directOrderResponse
                                                        .orderItems = [];
                                                    var orderItems = OrderItems(
                                                        websiteItemName: response
                                                            .orderItems![0]
                                                            .websiteItemName,
                                                        websiteItemCode: response
                                                            .orderItems![0]
                                                            .websiteItemCode,
                                                        quantity: response
                                                            .orderItems![0].qty,
                                                        totalAmount: response
                                                            .orderItems![0]
                                                            .netAmount,
                                                        digitalCardDetails: []);
                                                    for (var element in response
                                                        .orderItems![0]
                                                        .serialNumber!) {
                                                      orderItems
                                                          .digitalCardDetails!
                                                          .add(element);
                                                    }

                                                    directOrderResponse
                                                        .orderItems!
                                                        .add(orderItems);
                                                  }
                                                });

                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                    //this right here
                                                    child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: widgetSize
                                                                .getWidth(20,
                                                                    context)),
                                                        child: Consumer<
                                                                HomeProvider>(
                                                            builder: (context,
                                                                homeProvider,
                                                                child) {
                                                          if (homeProvider
                                                                  .salesInvoiceDetailsResponse !=
                                                              null) {
                                                            switch (homeProvider
                                                                .salesInvoiceDetailsResponse!
                                                                .status!) {
                                                              case Status
                                                                    .LOADING:
                                                                return SizedBox(
                                                                  height: 300,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Loading(
                                                                      loadingText: homeProvider
                                                                          .salesInvoiceDetailsResponse!
                                                                          .message),
                                                                );

                                                              case Status
                                                                    .COMPLETED:
                                                                SalesInvoiceDetailsData?
                                                                    items =
                                                                    homeProvider
                                                                        .salesInvoiceDetailsResponse!
                                                                        .data!
                                                                        .data;
                                                                if (items !=
                                                                    null) {
                                                                  return Stack(
                                                                    children: [
                                                                      ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                            height:
                                                                                widgetSize.getHeight(20, context),
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
                                                                                      child: SvgPicture.asset(Assets.svgCancelDirectOrder)),
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
                                                                            height:
                                                                                widgetSize.getHeight(25, context),
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                items.salesOrderId != null ? items.salesOrderId! : "",
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
                                                                              Text(
                                                                                items.orderItems?.first.websiteItemName != null ? items.orderItems!.first.websiteItemName! : "",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'DIN Next LT W23',
                                                                                  fontSize: widgetSize.getHeight(20, context),
                                                                                  color: const Color(0xff2e2e2e),
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                                softWrap: false,
                                                                              ),
                                                                              if (items.orderItems?.first.serialNumber != null && items.orderItems!.first.serialNumber!.isNotEmpty)
                                                                                ListView(
                                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    children: items.orderItems![0].serialNumber!
                                                                                        .map<Widget>((data) => Align(
                                                                                              alignment: Alignment.center,
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    height: widgetSize.getHeight(10, context),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "الرقم التسلسلي:",
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                                      fontSize: widgetSize.getHeight(16, context),
                                                                                                      color: const Color(0xff2e2e2e),
                                                                                                    ),
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    data.serialNo!,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                                      fontSize: widgetSize.getHeight(20, context),
                                                                                                      color: const Color(0xffec7e7e),
                                                                                                    ),
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: widgetSize.getHeight(10, context),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "رقم المرجع:",
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                                      fontSize: widgetSize.getHeight(16, context),
                                                                                                      color: const Color(0xff2e2e2e),
                                                                                                    ),
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    data.refNo!,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                                      fontSize: widgetSize.getHeight(20, context),
                                                                                                      color: const Color(0xffec7e7e),
                                                                                                    ),
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: widgetSize.getHeight(10, context),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "الرقم السري:",
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                                      fontSize: widgetSize.getHeight(16, context),
                                                                                                      color: const Color(0xff2e2e2e),
                                                                                                    ),
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      const Spacer(),
                                                                                                      Expanded(
                                                                                                        flex: 6,
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            data.secretCode!,
                                                                                                            style: const TextStyle(
                                                                                                              fontFamily: 'DIN Next LT W23',
                                                                                                              fontSize: 23,
                                                                                                              color: Color(0xffec7e7e),
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                            textAlign: TextAlign.right,
                                                                                                            softWrap: true,
                                                                                                            maxLines: 2,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        child: SafeOnTap(
                                                                                                            onSafeTap: () async {
                                                                                                              await Clipboard.setData(ClipboardData(text: data.secretCode!));
                                                                                                              var snackBar = const SnackBar(content: Text("تم النسخ"));
                                                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                            },
                                                                                                            child: SvgPicture.asset(Assets.svgCopy)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  const Divider(),
                                                                                                ],
                                                                                              ),
                                                                                            ))
                                                                                        .toList()),
                                                                              SizedBox(
                                                                                height: widgetSize.getHeight(10, context),
                                                                              ),
                                                                              if (items.orderItems?.first.qty != null) ...[
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      "الكمية : ",
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'DIN Next LT W23',
                                                                                        fontSize: widgetSize.getHeight(16, context),
                                                                                        color: const Color(0xff2e2e2e),
                                                                                      ),
                                                                                      softWrap: false,
                                                                                    ),
                                                                                    Text(
                                                                                      items.orderItems?.first.qty != null ? items.orderItems!.first.qty.toString() : "",
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'DIN Next LT W23',
                                                                                        fontSize: widgetSize.getHeight(16, context),
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
                                                                              if (item.totalTaxesAndCharges != null && item.totalTaxesAndCharges != '0.0') ...[
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    item.totalTaxesAndCharges!,
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
                                                                              if (items.orderItems?.first.productOptions != null && items.orderItems!.first.productOptions!.isNotEmpty) ...[
                                                                                Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: items.orderItems!.first.productOptions!.map<Widget>((e) {
                                                                                      if (e.productOptionFieldValue != null && e.productOptionFieldValue!.isNotEmpty) {
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 3),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "${e.productOptionFieldName!} : ",
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'DIN Next LT W23',
                                                                                                  fontSize: widgetSize.getHeight(16, context),
                                                                                                  color: const Color(0xff2e2e2e),
                                                                                                ),
                                                                                                softWrap: true,
                                                                                              ),
                                                                                              Text(
                                                                                                e.productOptionFieldValue!,
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'DIN Next LT W23',
                                                                                                  fontSize: widgetSize.getHeight(16, context),
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
                                                                              if (items.grandTotal != null && item.grandTotal != "0.0") ...[
                                                                                Text(
                                                                                  item.grandTotal!.toString(),
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'DIN Next LT W23',
                                                                                    fontSize: 20,
                                                                                    color: Color(0xffec7e7e),
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                  softWrap: false,
                                                                                ),
                                                                              ],
                                                                              SizedBox(
                                                                                height: widgetSize.getHeight(20, context),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: SafeOnTap(
                                                                                    onSafeTap: () async {
                                                                                      await shareOrder(directOrderResponse, context);
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: const Color(0xfff9f9f9),
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        border: Border.all(width: 1.0, color: const Color(0xfff3f3f3)),
                                                                                      ),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: widgetSize.getHeight(10, context),
                                                                                          ),
                                                                                          SvgPicture.asset(Assets.svgShare),
                                                                                          SizedBox(
                                                                                            height: widgetSize.getHeight(10, context),
                                                                                          ),
                                                                                          const Text(
                                                                                            'مشاركة',
                                                                                            style: TextStyle(
                                                                                              fontFamily: 'DIN Next LT W23',
                                                                                              fontSize: 12,
                                                                                              color: Color(0xff6b6b6b),
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                            softWrap: false,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: widgetSize.getHeight(10, context),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                if (Platform.isAndroid)
                                                                                  SizedBox(
                                                                                    width: widgetSize.getWidth(10, context),
                                                                                  ),
                                                                                Visibility(
                                                                                  visible: Platform.isAndroid,
                                                                                  child: Expanded(
                                                                                    child: SafeOnTap(
                                                                                      onSafeTap: () async {
                                                                                        if (androidInfo.model.contains("TPS")) {
                                                                                          await printOnTelpo(directOrderResponse, context.read<AppProvider>().getEnableMerchantNamePrint() ? context.read<AppProvider>().utilitiesModel : null, context);
                                                                                        } else {
                                                                                          if (context.read<AppProvider>().getBluetoothDevice() == null) {
                                                                                            await Navigator.push(
                                                                                              context,
                                                                                              PageTransition(
                                                                                                type: PageTransitionType.fade,
                                                                                                child: PrintScreen(directOrderResponse),
                                                                                              ),
                                                                                            );
                                                                                          } else {
                                                                                            await printOnBluetoothPrinter(directOrderResponse, context.read<AppProvider>().getEnableMerchantNamePrint() ? context.read<AppProvider>().utilitiesModel : null, context);
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: const Color(0xfff9f9f9),
                                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                                          border: Border.all(width: 1.0, color: const Color(0xfff3f3f3)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              height: widgetSize.getHeight(10, context),
                                                                                            ),
                                                                                            SvgPicture.asset(Assets.svgPrinterIcon),
                                                                                            SizedBox(
                                                                                              height: widgetSize.getHeight(10, context),
                                                                                            ),
                                                                                            const Text(
                                                                                              'طباعة البطاقة',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'DIN Next LT W23',
                                                                                                fontSize: 12,
                                                                                                color: Color(0xff6b6b6b),
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                              softWrap: false,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: widgetSize.getHeight(10, context),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                          SizedBox(
                                                                            height:
                                                                                widgetSize.getHeight(10, context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Positioned
                                                                          .fill(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Visibility(
                                                                              visible: Provider.of<HomeProvider>(context, listen: true).isLoading,
                                                                              child: const Center(
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.studio),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else {
                                                                  return Container();
                                                                }

                                                              case Status.ERROR:
                                                                return SizedBox(
                                                                    height: 300,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Error(
                                                                        errorMsg: homeProvider
                                                                            .salesInvoiceDetailsResponse!
                                                                            .message));
                                                            }
                                                          }
                                                          return Container();
                                                        })),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff2892d7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widgetSize
                                                                    .getWidth(
                                                                        20,
                                                                        context),
                                                            vertical: 2),
                                                    child: Text(
                                                      'التفاصيل',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                14, context),
                                                        color: const Color(
                                                            0xffffffff),
                                                      ),
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  10, context),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width:
                                              widgetSize.getWidth(10, context),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              const Text(
                                                'رقم الطلب',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 12,
                                                  color: Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              SelectableText(
                                                item.salesInvoiceId!,
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color: Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
                                                ),
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
                                                  color: Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                item.orderStatus.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color: Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
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
                                                  color: Color(0xffa2a2a2),
                                                ),
                                                softWrap: false,
                                              ),
                                              Text(
                                                item.items![0].qty!,
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 14,
                                                  color: Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                softWrap: false,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  item.grandTotal!.toString(),
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize: 22,
                                                      color: Color(0xffec7e7e),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  item.currency!.toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 18,
                                                    color: Color(0xffec7e7e),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    80, context),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    item.postingTime!
                                                        .split(".")[0]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              12, context),
                                                      color: const Color(
                                                          0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    item.date!.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              12, context),
                                                      color: const Color(
                                                          0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )))
            ]),
          )),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: const BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SafeOnTap(
                      onSafeTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(Assets.svgBack)),
                ),
                Expanded(
                    child: SizedBox(
                  width: widgetSize.getWidth(5, context),
                )),
                Expanded(
                  flex: 2,
                  child: Text(
                    "الطلبات",
                    style: TextStyle(
                      fontSize: widgetSize.getHeight(16, context),
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: widgetSize.getWidth(10, context)),
                    child: SafeOnTap(
                      onSafeTap: () async {},
                      child: SizedBox(
                        width: widgetSize.getWidth(100, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "JD ",
                              style: TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: 15,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: false,
                            ),
                            Text(
                              context.watch<AppProvider>().utilitiesModel !=
                                      null
                                  ? context
                                              .watch<AppProvider>()
                                              .utilitiesModel!
                                              .data !=
                                          null
                                      ? context
                                                  .watch<AppProvider>()
                                                  .utilitiesModel!
                                                  .data!
                                                  .walletBalance !=
                                              null
                                          ? context
                                              .watch<AppProvider>()
                                              .utilitiesModel!
                                              .data!
                                              .walletBalance!
                                          : ""
                                      : ""
                                  : "",
                              style: const TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: 15,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: false,
                            ),
                            SizedBox(width: widgetSize.getWidth(5, context)),
                            SvgPicture.asset(
                              Assets.svgWallet,
                              width: widgetSize.getWidth(20, context),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  DirectOrderResponse directOrderResponse = DirectOrderResponse();

  @override
  void initState() {
    super.initState();
    userModel = context.read<AppProvider>().getUserInfo();
    context.read<HomeProvider>().salesInvoiceDataPagingController =
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    context
        .read<HomeProvider>()
        .salesInvoiceDataPagingController!
        .addPageRequestListener((pageKey) {
      context.read<HomeProvider>().fetchSalesInvoices(pageKey, filters);
    });
    initlizeCategory();
  }

  initlizeCategory() async {
    List<String> items = [];
    ApiResponse<CategoriesModel> apiResponse =
        await context.read<HomeProvider>().getAllCategories();
    if (apiResponse.status == Status.COMPLETED) {
      if (apiResponse.data!.data != null) {
        List<Data>? list = apiResponse.data!.data;
        for (int i = 0; i < list!.length; i++) {
          items.add(list[i].itemGroupId!);
        }
      }
    }
    context.read<HomeProvider>().setItems = items;
  }

  @override
  void dispose() {
    context.read<HomeProvider>().salesInvoiceDataPagingController!.dispose();
    super.dispose();
  }
}
