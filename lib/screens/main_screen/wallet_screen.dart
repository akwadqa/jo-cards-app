import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/main.dart';
import 'package:jocards/model/invoice_order_details.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/print_screen.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/main_screen/shipping_screen.dart';
import 'package:jocards/screens/main_screen/widgets/search/search_component.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../generated/assets.dart';
import '../../model/direct_order_response.dart';
import '../../model/direct_wallet_request_log_model.dart';
import '../../provider/home_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/widget_size.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import 'exchange_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String filters = '{}';
  DirectOrderResponse directOrderResponse = DirectOrderResponse();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteSmoke,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() {
          filters = '{}';
          context.read<HomeProvider>().dwrLogPagingController?.refresh();
          context.read<AppProvider>().getUtilities();
        }),
        child: CustomScrollView(
          controller: PageController(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widgetSize.getWidth(15, context)),
                child: Column(
                  children: [
                    SizedBox(
                      height: widgetSize.getHeight(15, context),
                    ),
                    // const MyWallet(),
                    Container(
                        height:
                            widgetSize.getHeight(150, context), // Border width
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(Assets.imgWalletHh,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned.fill(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          widgetSize.getHeight(20, context)),
                                  Text(
                                    'رصيد المحفظة',
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(18, context),
                                      color: const Color(0xbdffffff),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: false,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: widgetSize.getWidth(35, context),
                                      ),
                                      SvgPicture.asset(
                                        Assets.svgWallet,
                                        height:
                                            widgetSize.getWidth(45, context),
                                        width: widgetSize.getWidth(45, context),
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Text(
                                              context
                                                          .watch<AppProvider>()
                                                          .utilitiesModel !=
                                                      null
                                                  ? context
                                                              .watch<
                                                                  AppProvider>()
                                                              .utilitiesModel!
                                                              .data !=
                                                          null
                                                      ? context
                                                                  .watch<
                                                                      AppProvider>()
                                                                  .utilitiesModel!
                                                                  .data!
                                                                  .walletBalance !=
                                                              null
                                                          ? context
                                                              .watch<
                                                                  AppProvider>()
                                                              .utilitiesModel!
                                                              .data!
                                                              .walletBalance!
                                                          : ""
                                                      : ""
                                                  : "",
                                              style: const TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 44,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              widgetSize.getWidth(15, context)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: widgetSize.getWidth(
                                                  23, context),
                                            ),
                                            Text(
                                              'الرصيد المستحق',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    15, context),
                                                color: const Color(0xffffffff),
                                              ),
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Consumer<HomeProvider>(builder:
                                                (context, homeProvider, child) {
                                              return Text(
                                                '${context.watch<AppProvider>().utilitiesModel != null ? context.watch<AppProvider>().utilitiesModel!.data != null ? context.watch<AppProvider>().utilitiesModel!.data!.unpaidUnits != null ? context.watch<AppProvider>().utilitiesModel!.data!.unpaidUnits! : "" : "" : ""} دينار ',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(15, context),
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                                softWrap: false,
                                              );
                                            }),
                                            // Text(
                                            //   context.watch<AppProvider>().utilitiesModel!=null?
                                            //   context.watch<AppProvider>().utilitiesModel!.data!=null?
                                            //   context.watch<AppProvider>().utilitiesModel!.data!.unpaidUnits!=null?
                                            //   context.watch<AppProvider>().utilitiesModel!.data!.unpaidUnits!:"":"":"",
                                            //   style: TextStyle(
                                            //     fontFamily: 'DIN Next LT W23',
                                            //     fontSize: widgetSize.getHeight(15, context),
                                            //     color: const Color(0xffffffff),
                                            //   ),
                                            //   softWrap: false,
                                            // ),
                                            SizedBox(
                                              width: widgetSize.getWidth(
                                                  23, context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: widgetSize.getHeight(10, context),
                    ),
                    SizedBox(
                      height: widgetSize.getHeight(40, context),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: SafeOnTap(
                              onSafeTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const SharedBottomNavigationBar(
                                        widget: ShippingScreen()),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff8e91ee),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(Assets.svgSh7n),
                                    SizedBox(
                                      width: widgetSize.getWidth(15, context),
                                    ),
                                    const Center(
                                      child: Text(
                                        'شحن',
                                        style: TextStyle(
                                          fontFamily: 'DIN Next LT W23',
                                          fontSize: 16,
                                          color: Color(0xffffffff),
                                        ),
                                        softWrap: false,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (context
                                  .watch<AppProvider>()
                                  .getUserInfo()!
                                  .customerType ==
                              "Agent") ...[
                            SizedBox(
                              width: widgetSize.getWidth(15, context),
                            ),
                            Expanded(
                              child: SafeOnTap(
                                onSafeTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const SharedBottomNavigationBar(
                                          widget: ExchangeScreen()),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff5ccbee),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(Assets.svgExchange),
                                      SizedBox(
                                        width: widgetSize.getWidth(15, context),
                                      ),
                                      const Center(
                                        child: Text(
                                          'تحويل مبلغ',
                                          style: TextStyle(
                                            fontFamily: 'DIN Next LT W23',
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                          ),
                                          softWrap: false,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widgetSize.getHeight(20, context),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchComponent(
                searchType: SearchType.walletRequestsLog,
                onSearch: (String filters) {
                  this.filters = filters;
                  context
                      .read<HomeProvider>()
                      .dwrLogPagingController!
                      .refresh();
                },
              ),
            )),
            // SliverToBoxAdapter(
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Consumer<HomeProvider>(
            //             builder: (context, homeProvider, child) {
            //               return Padding(
            //                 padding: EdgeInsets.symmetric(vertical: widgetSize.getHeight(10, context)),
            //                 child: Container(
            //                   padding: EdgeInsets.all(widgetSize.getWidth(10, context)),
            //                   height: widgetSize.getHeight(100, context),
            //                   width: MediaQuery.of(context).size.width/2.5,
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(widgetSize.getHeight(10, context))
            //                   ),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                     children: [
            //                       const Text("المبلغ المدفوع", softWrap: true,textAlign: TextAlign.center,),
            //                       Text('${homeProvider.directWalletRequestLogModelVar!.totalData == null ? "":homeProvider.directWalletRequestLogModelVar!.totalData!.totalPaid} دينار ', softWrap: true,),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             }
            //         ),
            //         Consumer<HomeProvider>(
            //             builder: (context, homeProvider, child) {
            //               return Padding(
            //                 padding: EdgeInsets.symmetric(vertical: widgetSize.getHeight(10, context)),
            //                 child: Container(
            //                   padding: EdgeInsets.all(widgetSize.getWidth(10, context)),
            //                   height: widgetSize.getHeight(100, context),
            //                   width: MediaQuery.of(context).size.width/2.5,
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(widgetSize.getHeight(10, context))
            //                   ),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                     children: [
            //                       const Text("المبلغ الغير مدفوع", softWrap: true, textAlign: TextAlign.center,),
            //                       Text('${homeProvider.directWalletRequestLogModelVar!.totalData == null ? "" :homeProvider.directWalletRequestLogModelVar!.totalData!.totalUnPaid} دينار ', softWrap: true,),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             }
            //         ),
            //       ]
            //   ),
            // ),
            SliverToBoxAdapter(
                child: SizedBox(height: widgetSize.getHeight(10, context))),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: widgetSize.getHeight(30, context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: widgetSize.getWidth(25, context)),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'العمليات على المحفظة',
                          style: TextStyle(
                            fontFamily: 'DIN Next LT W23',
                            fontSize: 16,
                            color: Color(0xff2e2e2e),
                            fontWeight: FontWeight.w700,
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: widgetSize.getHeight(10, context),
                    ),
                  ],
                ),
              ),
            ),
            if (context.read<HomeProvider>().dwrLogPagingController !=
                null) ...[
              PagedSliverList<int, DirectWalletRequestLogData>(
                  shrinkWrapFirstPageIndicators: false,
                  pagingController:
                      context.read<HomeProvider>().dwrLogPagingController!,
                  builderDelegate: PagedChildBuilderDelegate<
                          DirectWalletRequestLogData>(
                      firstPageProgressIndicatorBuilder: (_) =>
                          const Loading(loadingText: ""),
                      newPageProgressIndicatorBuilder: (_) => Container(
                            height: widgetSize.getHeight(40, context),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: widgetSize.getWidth(25, context)),
                            decoration: BoxDecoration(
                              color: const Color(0xff1d4c9b),
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xff1d4c9b)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x401d4c9b),
                                  offset: Offset(0, 5),
                                  blurRadius: 11,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.svgShowMore),
                                SizedBox(
                                  width: widgetSize.getWidth(10, context),
                                ),
                                const Text(
                                  'تحميل المزيد',
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: 14,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: false,
                                )
                              ],
                            ),
                          ),
                      noMoreItemsIndicatorBuilder: (_) => Container(),
                      noItemsFoundIndicatorBuilder: (_) => Container(
                            child: Center(
                              child: Text(
                                'لايوجد بيانات',
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
                                  .dwrLogPagingController!
                                  .error!
                                  .toString()),
                      itemBuilder: (context, item, index) => Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: widgetSize.getHeight(10, context),
                                  horizontal: widgetSize.getWidth(25, context)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffe5e5e5)),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widgetSize.getWidth(
                                                  20, context)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    5, context),
                                              ),
                                              // TextButton(
                                              //     onPressed: () async {
                                              //       context
                                              //           .read<HomeProvider>()
                                              //           .getPurchaseInvoiceDetails(item
                                              //           .refId
                                              //           .toString())
                                              //           .then((result) {
                                              //         if (result.data != null &&
                                              //             result.data!.data != null) {
                                              //           var response =
                                              //           result.data!.data!;
                                              //           directOrderResponse.currency =
                                              //               response.currency;
                                              //           directOrderResponse
                                              //               .grandTotal =
                                              //               response.grandTotal;
                                              //           directOrderResponse.date =
                                              //               response.date;
                                              //           directOrderResponse
                                              //               .postingTime =
                                              //               response.postingTime;
                                              //           directOrderResponse.owner =
                                              //               response.owner;
                                              //           directOrderResponse.invoiceId =
                                              //               response.salesInvoiceId;
                                              //           directOrderResponse
                                              //               .orderItems = [];
                                              //           var orderItems = OrderItems(
                                              //               websiteItemName: response
                                              //                   .itemsDetail![0]
                                              //                   .websiteItemName,
                                              //               websiteItemCode: response
                                              //                   .itemsDetail![0]
                                              //                   .websiteItemCode,
                                              //               quantity: response
                                              //                   .itemsDetail![0].qty,
                                              //               totalAmount: response
                                              //                   .itemsDetail![0]
                                              //                   .netAmount,
                                              //               stockDetails: []);
                                              //           response.itemsDetail![0]
                                              //               .serialNumber!
                                              //               .forEach((element) {
                                              //             orderItems.stockDetails!
                                              //                 .add(element);
                                              //           });
                                              //
                                              //           directOrderResponse
                                              //               .orderItems!
                                              //               .add(orderItems);
                                              //         }
                                              //       });
                                              //
                                              //       await showDialog(
                                              //           context: context,
                                              //           builder:
                                              //       (BuildContext context) =>
                                              //           Dialog(
                                              //             shape: RoundedRectangleBorder(
                                              //                 borderRadius:
                                              //                 BorderRadius.circular(
                                              //                     12.0)),
                                              //             //this right here
                                              //             child: Padding(
                                              //                 padding: EdgeInsets.symmetric(
                                              //                     horizontal: widgetSize
                                              //                         .getWidth(
                                              //                         20, context)),
                                              //                 child: Consumer<
                                              //                     HomeProvider>(
                                              //                     builder: (context,
                                              //                         homeProvider,
                                              //                         child) {
                                              //                       if (homeProvider
                                              //                           .salesInvoiceDetailsResponse !=
                                              //                           null) {
                                              //                         switch (homeProvider
                                              //                             .salesInvoiceDetailsResponse!
                                              //                             .status!) {
                                              //                           case Status.LOADING:
                                              //                             return Container(
                                              //                               height: 300,
                                              //                               width: MediaQuery.of(
                                              //                                   context)
                                              //                                   .size
                                              //                                   .width,
                                              //                               child: Loading(
                                              //                                   loadingText:
                                              //                                   homeProvider
                                              //                                       .salesInvoiceDetailsResponse!
                                              //                                       .message),
                                              //                             );
                                              //
                                              //                           case Status
                                              //                               .COMPLETED:
                                              //                             SalesInvoiceDetailsData?
                                              //                             items =
                                              //                                 homeProvider
                                              //                                     .salesInvoiceDetailsResponse!
                                              //                                     .data!
                                              //                                     .data;
                                              //                             if (items !=
                                              //                                 null) {
                                              //                               return Stack(
                                              //                                 children: [
                                              //                                   ListView(
                                              //                                     shrinkWrap:
                                              //                                     true,
                                              //                                     children: <
                                              //                                         Widget>[
                                              //                                       SizedBox(
                                              //                                         height: widgetSize.getHeight(
                                              //                                             20,
                                              //                                             context),
                                              //                                       ),
                                              //                                       Row(
                                              //                                         children: [
                                              //                                           Expanded(
                                              //                                             child: Align(
                                              //                                               alignment: AlignmentDirectional.centerStart,
                                              //                                               child: SafeOnTap(
                                              //                                                   onSafeTap: () {
                                              //                                                     Navigator.of(context).pop();
                                              //                                                   },
                                              //                                                   child: SvgPicture.asset(Assets.svgCancelDirectOrder)),
                                              //                                             ),
                                              //                                           ),
                                              //                                           Expanded(
                                              //                                             flex: 2,
                                              //                                             child: Center(
                                              //                                               child: Text(
                                              //                                                 'ملخص  الطلب',
                                              //                                                 style: TextStyle(
                                              //                                                   fontFamily: 'DIN Next LT W23',
                                              //                                                   fontSize: widgetSize.getHeight(20, context),
                                              //                                                   color: const Color(0xff2e2e2e),
                                              //                                                   fontWeight: FontWeight.w500,
                                              //                                                 ),
                                              //                                                 softWrap: false,
                                              //                                               ),
                                              //                                             ),
                                              //                                           ),
                                              //                                           const Spacer(),
                                              //                                         ],
                                              //                                       ),
                                              //                                       SizedBox(
                                              //                                         height: widgetSize.getHeight(
                                              //                                             25,
                                              //                                             context),
                                              //                                       ),
                                              //                                       Column(
                                              //                                         crossAxisAlignment:
                                              //                                         CrossAxisAlignment.center,
                                              //                                         children: [
                                              //                                           Text(
                                              //                                             items.itemsDetail?.first.websiteItemName != null ? items.itemsDetail!.first.websiteItemName! : "",
                                              //                                             style: TextStyle(
                                              //                                               fontFamily: 'DIN Next LT W23',
                                              //                                               fontSize: widgetSize.getHeight(20, context),
                                              //                                               color: const Color(0xff2e2e2e),
                                              //                                               fontWeight: FontWeight.w500,
                                              //                                             ),
                                              //                                             softWrap: false,
                                              //                                           ),
                                              //                                           if(items.itemsDetail?.first.serialNumber != null && items.itemsDetail!.first.serialNumber!.isNotEmpty) ...[
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                             Text(
                                              //                                               "الرقم التسلسلي:",
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: widgetSize.getHeight(16, context),
                                              //                                                 color: const Color(0xff2e2e2e),
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             Text(
                                              //                                               items.itemsDetail!.first.serialNumber!.first.serialNo!,
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: widgetSize.getHeight(20, context),
                                              //                                                 color: const Color(0xffec7e7e),
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                             Text(
                                              //                                               "رقم المرجع:",
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: widgetSize.getHeight(16, context),
                                              //                                                 color: const Color(0xff2e2e2e),
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             Text(
                                              //                                               items.itemsDetail!.first.serialNumber!.first.refNo!,
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: widgetSize.getHeight(20, context),
                                              //                                                 color: const Color(0xffec7e7e),
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                             Text(
                                              //                                               "الرقم السري:",
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: widgetSize.getHeight(16, context),
                                              //                                                 color: const Color(0xff2e2e2e),
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             Row(
                                              //                                               mainAxisAlignment:
                                              //                                               MainAxisAlignment.center,
                                              //                                               children: [
                                              //                                                 Expanded(
                                              //                                                   child: Text(
                                              //                                                     items.itemsDetail!.first.serialNumber!.first.secretCode!,
                                              //                                                     style: TextStyle(
                                              //                                                       fontFamily: 'DIN Next LT W23',
                                              //                                                       fontSize: 23,
                                              //                                                       color:
                                              //                                                       const Color(0xffec7e7e),
                                              //                                                       fontWeight: FontWeight.w500,
                                              //                                                     ),
                                              //                                                     textAlign: TextAlign.right,
                                              //                                                     softWrap: true,
                                              //                                                     maxLines: 2,
                                              //                                                   ),
                                              //                                                 ),
                                              //                                                 SizedBox(
                                              //                                                   width: widgetSize.getWidth(
                                              //                                                       5, context),
                                              //                                                 ),
                                              //                                                 SafeOnTap(
                                              //                                                     onSafeTap: () async {
                                              //                                                       await Clipboard.setData(
                                              //                                                           ClipboardData(
                                              //                                                               text: items.itemsDetail!.first.serialNumber!.first.secretCode!));
                                              //                                                       var snackBar = SnackBar(
                                              //                                                           content:
                                              //                                                           Text("تم النسخ"));
                                              //                                                       ScaffoldMessenger.of(
                                              //                                                           context)
                                              //                                                           .showSnackBar(snackBar);
                                              //                                                     },
                                              //                                                     child: SvgPicture.asset(
                                              //                                                         Assets.svgCopy)),
                                              //                                               ],
                                              //                                             ),
                                              //                                           ],
                                              //                                           SizedBox(
                                              //                                             height: widgetSize.getHeight(10, context),
                                              //                                           ),
                                              //                                           if (items.itemsDetail?.first.qty !=
                                              //                                               null) ...[
                                              //                                             Row(
                                              //                                               mainAxisAlignment: MainAxisAlignment.center,
                                              //                                               children: [
                                              //                                                 Text(
                                              //                                                   "الكمية : ",
                                              //                                                   style: TextStyle(
                                              //                                                     fontFamily: 'DIN Next LT W23',
                                              //                                                     fontSize: widgetSize.getHeight(16, context),
                                              //                                                     color: const Color(0xff2e2e2e),
                                              //                                                   ),
                                              //                                                   softWrap: false,
                                              //                                                 ),
                                              //                                                 Text(
                                              //                                                   items.itemsDetail?.first.qty != null ? items.itemsDetail!.first.qty.toString() : "",
                                              //                                                   style: TextStyle(
                                              //                                                     fontFamily: 'DIN Next LT W23',
                                              //                                                     fontSize: widgetSize.getHeight(16, context),
                                              //                                                     color: const Color(0xff2e2e2e),
                                              //                                                   ),
                                              //                                                   softWrap: false,
                                              //                                                 ),
                                              //                                               ],
                                              //                                             ),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                           ],
                                              //                                           if (items.extraCharges !=
                                              //                                               null && items.extraCharges != '0.0') ...[
                                              //                                             Align(
                                              //                                               alignment: Alignment.center,
                                              //                                               child: Text(
                                              //                                                 items.extraCharges!,
                                              //                                                 style: TextStyle(
                                              //                                                   fontFamily: 'DIN Next LT W23',
                                              //                                                   fontSize: widgetSize.getHeight(22, context),
                                              //                                                   color: const Color(0xffec7e7e),
                                              //                                                   fontWeight: FontWeight.w700,
                                              //                                                 ),
                                              //                                                 softWrap: false,
                                              //                                               ),
                                              //                                             ),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                           ],
                                              //                                           if (items.itemsDetail?.first.productOptions != null &&
                                              //                                               items.itemsDetail!.first.productOptions!.isNotEmpty) ...[
                                              //                                             Column(
                                              //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                              //                                                 children: items.itemsDetail!.first.productOptions!.map<Widget>((e) {
                                              //                                                   if (e.productOptionFieldValue != null && e.productOptionFieldValue!.isNotEmpty) {
                                              //                                                     return Padding(
                                              //                                                       padding: const EdgeInsets.symmetric(vertical: 3),
                                              //                                                       child: Column(
                                              //                                                         mainAxisAlignment: MainAxisAlignment.center,
                                              //                                                         children: [
                                              //                                                           Text(
                                              //                                                             e.productOptionFieldName! + " : ",
                                              //                                                             style: TextStyle(
                                              //                                                               fontFamily: 'DIN Next LT W23',
                                              //                                                               fontSize: widgetSize.getHeight(16, context),
                                              //                                                               color: const Color(0xff2e2e2e),
                                              //                                                             ),
                                              //                                                             softWrap: true,
                                              //                                                           ),
                                              //                                                           Text(
                                              //                                                             e.productOptionFieldValue!,
                                              //                                                             style: TextStyle(
                                              //                                                               fontFamily: 'DIN Next LT W23',
                                              //                                                               fontSize: widgetSize.getHeight(16, context),
                                              //                                                               color: const Color(0xff2e2e2e),
                                              //                                                             ),
                                              //                                                             softWrap: true,
                                              //                                                           ),
                                              //                                                         ],
                                              //                                                       ),
                                              //                                                     );
                                              //                                                   } else {
                                              //                                                     return Container();
                                              //                                                   }
                                              //                                                 }).toList()),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(20, context),
                                              //                                             ),
                                              //                                           ],
                                              //                                           if (items.grandTotal != null &&
                                              //                                               items.grandTotal != "0.0") ...[
                                              //                                             Text(
                                              //                                               items.grandTotal!,
                                              //                                               style: TextStyle(
                                              //                                                 fontFamily: 'DIN Next LT W23',
                                              //                                                 fontSize: 20,
                                              //                                                 color: const Color(0xffec7e7e),
                                              //                                                 fontWeight: FontWeight.w700,
                                              //                                               ),
                                              //                                               softWrap: false,
                                              //                                             ),
                                              //                                             SizedBox(
                                              //                                               height: widgetSize.getHeight(10, context),
                                              //                                             ),
                                              //                                           ],
                                              //                                           Container(
                                              //                                             decoration: BoxDecoration(
                                              //                                               color: const Color(0xfff6f6f6),
                                              //                                               borderRadius: BorderRadius.circular(20.0),
                                              //                                               border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                                              //                                             ),
                                              //                                             child: Padding(
                                              //                                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                              //                                               child: Row(
                                              //                                                 mainAxisAlignment: MainAxisAlignment.center,
                                              //                                                 children: [
                                              //                                                   Text(
                                              //                                                     'الرصيد الحالي',
                                              //                                                     style: TextStyle(
                                              //                                                       fontFamily: 'DIN Next LT W23',
                                              //                                                       fontSize: widgetSize.getHeight(16, context),
                                              //                                                       color: const Color(0xff2e2e2e),
                                              //                                                       fontWeight: FontWeight.w500,
                                              //                                                     ),
                                              //                                                     softWrap: false,
                                              //                                                   ),
                                              //                                                   SizedBox(
                                              //                                                     width: widgetSize.getWidth(60, context),
                                              //                                                   ),
                                              //                                                   Text(
                                              //                                                     context.read<AppProvider>().utilitiesModel!.data!.walletBalance!,
                                              //                                                     style: TextStyle(
                                              //                                                       fontFamily: 'DIN Next LT W23',
                                              //                                                       fontSize: 16,
                                              //                                                       color: const Color(0xff2e2e2e),
                                              //                                                       fontWeight: FontWeight.w500,
                                              //                                                     ),
                                              //                                                     softWrap: false,
                                              //                                                   )
                                              //                                                 ],
                                              //                                               ),
                                              //                                             ),
                                              //                                           ),
                                              //                                           SizedBox(
                                              //                                             height: widgetSize.getHeight(20, context),
                                              //                                           )
                                              //                                         ],
                                              //                                       ),
                                              //                                       Row(
                                              //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //                                           children: [
                                              //                                             Expanded(
                                              //                                               child: SafeOnTap(
                                              //                                                 onSafeTap: () async {
                                              //                                                   await shareOrder(directOrderResponse, context);
                                              //                                                 },
                                              //                                                 child: Container(
                                              //                                                   decoration: BoxDecoration(
                                              //                                                     color: const Color(0xfff9f9f9),
                                              //                                                     borderRadius: BorderRadius.circular(5.0),
                                              //                                                     border: Border.all(width: 1.0, color: const Color(0xfff3f3f3)),
                                              //                                                   ),
                                              //                                                   child: Column(
                                              //                                                     mainAxisAlignment: MainAxisAlignment.center,
                                              //                                                     children: [
                                              //                                                       SizedBox(
                                              //                                                         height: widgetSize.getHeight(10, context),
                                              //                                                       ),
                                              //                                                       SvgPicture.asset(Assets.svgShare),
                                              //                                                       SizedBox(
                                              //                                                         height: widgetSize.getHeight(10, context),
                                              //                                                       ),
                                              //                                                       Text(
                                              //                                                         'مشاركة',
                                              //                                                         style: TextStyle(
                                              //                                                           fontFamily: 'DIN Next LT W23',
                                              //                                                           fontSize: 12,
                                              //                                                           color: const Color(0xff6b6b6b),
                                              //                                                           fontWeight: FontWeight.w500,
                                              //                                                         ),
                                              //                                                         softWrap: false,
                                              //                                                       ),
                                              //                                                       SizedBox(
                                              //                                                         height: widgetSize.getHeight(10, context),
                                              //                                                       ),
                                              //                                                     ],
                                              //                                                   ),
                                              //                                                 ),
                                              //                                               ),
                                              //                                             ),
                                              //                                             if(Platform.isAndroid) SizedBox(
                                              //                                               width: widgetSize.getWidth(10, context),
                                              //                                             ),
                                              //                                             Visibility(
                                              //                                               visible: Platform.isAndroid,
                                              //                                               child: Expanded(
                                              //                                                 child: SafeOnTap(
                                              //                                                   onSafeTap: () async {
                                              //                                                     if (androidInfo.model!.contains("TPS")) {
                                              //                                                       await printOnTelpo(directOrderResponse, context.read<AppProvider>().getEnableMerchantNamePrint() ? context.read<AppProvider>().utilitiesModel : null, context);
                                              //                                                     } else {
                                              //                                                       if (context.read<AppProvider>().getBluetoothDevice() == null) {
                                              //                                                         var result = await Navigator.push(
                                              //                                                           context,
                                              //                                                           PageTransition(
                                              //                                                             type: PageTransitionType.fade,
                                              //                                                             child: PrintScreen(directOrderResponse),
                                              //                                                           ),
                                              //                                                         );
                                              //                                                       } else {
                                              //                                                         await printOnBluetoothPrinter(directOrderResponse, context.read<AppProvider>().getEnableMerchantNamePrint() ? context.read<AppProvider>().utilitiesModel : null, context);
                                              //                                                       }
                                              //                                                     }
                                              //                                                   },
                                              //                                                   child: Container(
                                              //                                                     decoration: BoxDecoration(
                                              //                                                       color: const Color(0xfff9f9f9),
                                              //                                                       borderRadius: BorderRadius.circular(5.0),
                                              //                                                       border: Border.all(width: 1.0, color: const Color(0xfff3f3f3)),
                                              //                                                     ),
                                              //                                                     child: Column(
                                              //                                                       mainAxisAlignment: MainAxisAlignment.center,
                                              //                                                       children: [
                                              //                                                         SizedBox(
                                              //                                                           height: widgetSize.getHeight(10, context),
                                              //                                                         ),
                                              //                                                         SvgPicture.asset(Assets.svgPrinterIcon),
                                              //                                                         SizedBox(
                                              //                                                           height: widgetSize.getHeight(10, context),
                                              //                                                         ),
                                              //                                                         Text(
                                              //                                                           'طباعة البطاقة',
                                              //                                                           style: TextStyle(
                                              //                                                             fontFamily: 'DIN Next LT W23',
                                              //                                                             fontSize: 12,
                                              //                                                             color: const Color(0xff6b6b6b),
                                              //                                                             fontWeight: FontWeight.w500,
                                              //                                                           ),
                                              //                                                           softWrap: false,
                                              //                                                         ),
                                              //                                                         SizedBox(
                                              //                                                           height: widgetSize.getHeight(10, context),
                                              //                                                         ),
                                              //                                                       ],
                                              //                                                     ),
                                              //                                                   ),
                                              //                                                 ),
                                              //                                               ),
                                              //                                             ),
                                              //                                           ]),
                                              //                                       SizedBox(
                                              //                                         height: widgetSize.getHeight(10, context),
                                              //                                       ),
                                              //                                     ],
                                              //                                   ),
                                              //                                   Positioned
                                              //                                       .fill(
                                              //                                     child:
                                              //                                     Align(
                                              //                                       alignment:
                                              //                                       Alignment.center,
                                              //                                       child: Visibility(
                                              //                                           visible: Provider.of<HomeProvider>(context, listen: true).isLoading,
                                              //                                           child: Center(
                                              //                                             child: CircularProgressIndicator(
                                              //                                               valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.studio),
                                              //                                             ),
                                              //                                           )),
                                              //                                     ),
                                              //                                   ),
                                              //                                 ],
                                              //                               );
                                              //                             } else
                                              //                               return Container();
                                              //
                                              //                           case Status.ERROR:
                                              //                             return Container(
                                              //                                 height: 300,
                                              //                                 width: MediaQuery.of(
                                              //                                     context)
                                              //                                     .size
                                              //                                     .width,
                                              //                                 child: Error(
                                              //                                     errorMsg: homeProvider
                                              //                                         .salesInvoiceDetailsResponse!
                                              //                                         .message));
                                              //                         }
                                              //                       }
                                              //                       return Container();
                                              //                     })),
                                              //           ),
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       item.dwrLogId.toString(),
                                              //       style: TextStyle(
                                              //         fontFamily: 'DIN Next LT W23',
                                              //         fontSize: widgetSize.getHeight(15, context),
                                              //         color: const Color(0xffc9c9c9),
                                              //         fontWeight: FontWeight.w500,
                                              //       ),
                                              //       softWrap: false,
                                              //     ),
                                              // ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 8),
                                                child: Text(
                                                  item.dwrLogId.toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(15, context),
                                                    color:
                                                        const Color(0xffc9c9c9),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              if (item.refId != null) ...[
                                                Row(
                                                  children: [
                                                    Text(
                                                      'رقم الطلب',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                15, context),
                                                        color: const Color(
                                                            0xff6b6b6b),
                                                      ),
                                                      softWrap: false,
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (item.refId
                                                            .toString()
                                                            .contains("SAL")) {
                                                          context
                                                              .read<
                                                                  HomeProvider>()
                                                              .getPurchaseInvoiceDetails(
                                                                  item.refId
                                                                      .toString())
                                                              .then((result) {
                                                            if (result.data !=
                                                                    null &&
                                                                result.data!
                                                                        .data !=
                                                                    null) {
                                                              var response =
                                                                  result.data!
                                                                      .data!;
                                                              directOrderResponse
                                                                      .currency =
                                                                  response
                                                                      .currency;
                                                              directOrderResponse
                                                                      .grandTotal =
                                                                  response
                                                                      .grandTotal;
                                                              directOrderResponse
                                                                      .date =
                                                                  response.date;
                                                              directOrderResponse
                                                                      .postingTime =
                                                                  response
                                                                      .postingTime;
                                                              directOrderResponse
                                                                      .owner =
                                                                  response
                                                                      .owner;
                                                              directOrderResponse
                                                                      .salesOrderId =
                                                                  response
                                                                      .salesOrderId;
                                                              directOrderResponse
                                                                  .orderItems = [];
                                                              var orderItems = OrderItems(
                                                                  websiteItemName:
                                                                      response
                                                                          .orderItems![
                                                                              0]
                                                                          .websiteItemName,
                                                                  websiteItemCode:
                                                                      response
                                                                          .orderItems![
                                                                              0]
                                                                          .websiteItemCode,
                                                                  quantity: response
                                                                      .orderItems![
                                                                          0]
                                                                      .qty,
                                                                  totalAmount: response
                                                                      .orderItems![
                                                                          0]
                                                                      .netAmount,
                                                                  digitalCardDetails: []);
                                                              for (var element
                                                                  in response
                                                                      .orderItems![
                                                                          0]
                                                                      .serialNumber!) {
                                                                orderItems
                                                                    .digitalCardDetails!
                                                                    .add(
                                                                        element);
                                                              }

                                                              directOrderResponse
                                                                  .orderItems!
                                                                  .add(
                                                                      orderItems);
                                                            }
                                                          });
                                                        }

                                                        if (item.refId
                                                            .toString()
                                                            .contains("SAL")) {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0)),
                                                              //this right here
                                                              child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          widgetSize.getWidth(
                                                                              20,
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
                                                                            height:
                                                                                300,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Loading(loadingText: homeProvider.salesInvoiceDetailsResponse!.message),
                                                                          );

                                                                        case Status
                                                                              .COMPLETED:
                                                                          SalesInvoiceDetailsData? items = homeProvider
                                                                              .salesInvoiceDetailsResponse!
                                                                              .data!
                                                                              .data;
                                                                          if (items !=
                                                                              null) {
                                                                            return Stack(
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
                                                                                      height: widgetSize.getHeight(25, context),
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                        if (items.orderItems?.first.serialNumber != null && items.orderItems!.first.serialNumber!.isNotEmpty) ...[
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
                                                                                            items.orderItems!.first.serialNumber!.first.serialNo!,
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
                                                                                            items.orderItems!.first.serialNumber!.first.refNo!,
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
                                                                                              Expanded(
                                                                                                child: Text(
                                                                                                  items.orderItems!.first.serialNumber!.first.secretCode!,
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
                                                                                              SizedBox(
                                                                                                width: widgetSize.getWidth(5, context),
                                                                                              ),
                                                                                              SafeOnTap(
                                                                                                  onSafeTap: () async {
                                                                                                    await Clipboard.setData(ClipboardData(text: items.orderItems!.first.serialNumber!.first.secretCode!));
                                                                                                    var snackBar = const SnackBar(content: Text("تم النسخ"));
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                  },
                                                                                                  child: SvgPicture.asset(Assets.svgCopy)),
                                                                                            ],
                                                                                          ),
                                                                                        ],
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
                                                                                        if (items.extraCharges != null && items.extraCharges != '0.0') ...[
                                                                                          Align(
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              items.extraCharges!,
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
                                                                                        if (items.grandTotal != null && items.grandTotal != "0.0") ...[
                                                                                          Text(
                                                                                            items.grandTotal!,
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
                                                                                            border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'الرصيد الحالي',
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: 'DIN Next LT W23',
                                                                                                    fontSize: widgetSize.getHeight(16, context),
                                                                                                    color: const Color(0xff2e2e2e),
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                  softWrap: false,
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: widgetSize.getWidth(60, context),
                                                                                                ),
                                                                                                Text(
                                                                                                  context.read<AppProvider>().utilitiesModel!.data!.walletBalance!,
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
                                                                                          height: widgetSize.getHeight(20, context),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                                                                      height: widgetSize.getHeight(10, context),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Positioned.fill(
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
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

                                                                        case Status
                                                                              .ERROR:
                                                                          Navigator.pop(
                                                                              context);
                                                                          return const SizedBox
                                                                              .shrink();
                                                                      }
                                                                    }
                                                                    return Container();
                                                                  })),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        item.refId.toString(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'DIN Next LT W23',
                                                          fontSize: widgetSize
                                                              .getHeight(
                                                                  15, context),
                                                          color: const Color(
                                                              0xff59bce6),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        softWrap: false,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      10, context),
                                                ),
                                              ],
                                              Row(
                                                children: [
                                                  Text(
                                                    'المبلغ',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "${item.units} دينار",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: item.logType ==
                                                                  "Credit" &&
                                                              double.parse(item
                                                                      .units!) >=
                                                                  0
                                                          ? const Color(
                                                              0xff4abfa7)
                                                          : const Color(
                                                              0xffEC7E7E),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    softWrap: false,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'رصيد المحفظة',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "${item.availableWalletUnits} دينار",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff2e2e2e),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'معتمد الطلب',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    item.owner.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff2e2e2e),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xffe5e5e5),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 2),
                                                child: Text(
                                                  item.time != null
                                                      ? item.time!
                                                          .split(".")[0]
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(13, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 2),
                                                child: Text(
                                                  item.date != null
                                                      ? item.date!
                                                      : "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(13, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: item.logType == "Credit" &&
                                                  double.parse(item.units!) >= 0
                                              ? const Color(0xff4abfa7)
                                              : const Color(0xffEC7E7E),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widgetSize.getWidth(
                                                  25, context),
                                              vertical: widgetSize.getHeight(
                                                  4, context)),
                                          child: Text(
                                            item.logType == "Credit" &&
                                                    double.parse(item.units!) >=
                                                        0
                                                ? 'إيداع'
                                                : 'خصم',
                                            style: const TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: 14,
                                              color: Color(0xffffffff),
                                            ),
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )))
            ],
            SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widgetSize.getHeight(50, context)),
            )),
          ],
        ),
      ),
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
            child: Center(
              child: Text(
                'محفظتي',
                style: TextStyle(
                  fontFamily: 'DIN Next LT W23',
                  fontSize: widgetSize.getHeight(18, context),
                  color: const Color(0xffffffff),
                ),
                softWrap: false,
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().dwrLogPagingController =
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    // context.read<HomeProvider>().directWalletRequestLogModelVar = DirectWalletRequestLogModel(totalData: TotalData( 0.0, 0.0));
    context
        .read<HomeProvider>()
        .dwrLogPagingController!
        .addPageRequestListener((pageKey) {
      context.read<HomeProvider>().fetchDWRLog(pageKey, filters);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.read<AppProvider>().getUtilities();
      context.read<AppProvider>().getAgentCustomers();
    });
  }

  // @override
  // void dispose() {
  //   context.read<HomeProvider>().dwrLogPagingController!.dispose();
  //   super.dispose();
  // }
}
