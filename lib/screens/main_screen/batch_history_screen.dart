import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/payment_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/widgets/search/search_component.dart';
import 'package:jocards/screens/widget/loading.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/svg.dart';
import '../widget/error.dart';
class BatchHistoryScreen extends StatefulWidget {
  const BatchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BatchHistoryScreen> createState() => _BatchHistoryScreenState();
}

class _BatchHistoryScreenState extends State<BatchHistoryScreen> {
  late String filters =  '{}';

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
              filters =  '{}' ;
              context.read<HomeProvider>().paymentLogPagingController?.refresh();
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
                        vertical: widgetSize.getHeight(20, context),
                        horizontal: widgetSize.getWidth(20, context)
                    ),
                    child: Row(
                      children: [
                        Consumer<HomeProvider>(
                            builder: (context, homeProvider, child) {
                            return Expanded(child: buildBox(context, "الصندوق", homeProvider.paymentModel!.agentPayable != null ? "${homeProvider.paymentModel!.agentPayable!.toStringAsFixed(5)}  دينار" : ""));
                          }
                        ),
                        SizedBox(width: widgetSize.getWidth(20, context)),
                        Consumer <HomeProvider>(
                            builder: (context, homeProvider, child) {
                            return Expanded(child: buildBox(context, "التسويات", homeProvider.paymentModel!.agentPayment != null ? "${removeNegativeSign(homeProvider.paymentModel!.agentPayment).toStringAsFixed(5)}  دينار" : ""));
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: SearchComponent(
                    searchType:  SearchType.batchLog,
                    onSearch: (String filters) {
                      this.filters = filters;
                      context.read<HomeProvider>().paymentLogPagingController?.refresh();
                    },
                  )
              ),
              SliverToBoxAdapter(child: SizedBox(height: widgetSize.getHeight(10, context))),
              PagedSliverList<int, GLEntries>(

                  shrinkWrapFirstPageIndicators: false,
                  pagingController: context.read<HomeProvider>().paymentLogPagingController!,
                  builderDelegate: PagedChildBuilderDelegate<GLEntries>(
                      firstPageProgressIndicatorBuilder:(_)=>Loading(loadingText: ""),

                      newPageProgressIndicatorBuilder: (_)=>Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Loading(loadingText: ""),
                      ),
                      noMoreItemsIndicatorBuilder: (_)=>Container(),
                      noItemsFoundIndicatorBuilder: (_)=>Container(child: Center(child:  Text(
                        'لايوجد طلبات',
                        style: TextStyle(
                          fontFamily: 'DIN Next LT W23',
                          fontSize: widgetSize.getHeight(19, context),
                          color: const Color(0xff2e2e2e),

                        ),
                        softWrap: false,
                      ),),),

                      firstPageErrorIndicatorBuilder: (_)=>
                          Error(errorMsg:Provider.of<HomeProvider>(context,listen: false).
                          paymentLogPagingController!.error!.toString()),
                      itemBuilder: (context, item, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Stack(children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xffe5e5e5)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                      widgetSize.getWidth(20, context)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: widgetSize.getHeight(
                                                28, context)),
                                        child: Row(
                                          children: [
                                            Text(
                                              'رقم الطلب',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff6b6b6b),
                                              ),
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Text(
                                              item.referenceNo!,
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff59bce6),
                                              ),
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: widgetSize.getHeight(
                                                10, context)),
                                        child: Row(
                                          children: [
                                            Text(
                                              'رقم الدفع',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff6b6b6b),
                                              ),
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Text(
                                              item.voucherNo!
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff59bce6),
                                              ),
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: widgetSize.getHeight(
                                                10, context)),
                                        child: Row(
                                          children: [
                                            Text(
                                              'قيمة الدفع',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff6b6b6b),
                                              ),
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Text(
                                              item.typeOfTransiction == "debit" ? "${item.debit!} دينار":"${item.credit!} دينار",
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xffec7e7e),
                                              ),
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: widgetSize.getHeight(
                                                10, context)),
                                        child: Row(
                                          children: [
                                            Text(
                                              'اسم العميل',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff6b6b6b),
                                              ),
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Text(
                                              item.againstParty !=null ? item.againstParty!.toString() : item.partyName!.toString(),
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize
                                                    .getHeight(16, context),
                                                color:
                                                const Color(0xff2e2e2e),
                                                fontWeight: FontWeight.w700,
                                              ),
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: widgetSize.getHeight(5, context)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: ColorResources.whisper,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                item.postingDate!.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize.getHeight(
                                                      14, context),
                                                  color: const Color(0xff6b6b6b),
                                                ),
                                                softWrap: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: item.typeOfTransiction == 'credit' ?
                                  const Color(0xFFEC7E7E)
                                      : item.typeOfTransiction == 'debit'
                                      ? const Color(0xFF4ABFA7)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 2),
                                child: Text(
                                  item.typeOfTransiction == 'credit'
                                      ? 'دفعة'
                                      : item.typeOfTransiction == 'debit'
                                      ? 'تسوية'
                                      : '',
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize:
                                    widgetSize.getHeight(14, context),
                                    color: const Color(0xffffffff),
                                  ),
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )))
            ]),
          ),
        ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: const BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
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
                Expanded(child: SizedBox(width: widgetSize.getWidth(5, context),)),

                Expanded(
                  flex: 2,
                  child: Text(
                  "سجل الدفعات",
                    style: TextStyle(
                      fontSize: widgetSize.getHeight(16, context),
                      color: const Color(0xffffffff),
                    ),
                    softWrap: false,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: widgetSize.getWidth(10, context)),
                    child: SafeOnTap( onSafeTap: ()async {},
                      child: SizedBox(
                        width: widgetSize.getWidth(100, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          const Text("JD ", style: TextStyle(
                            fontFamily: 'DIN Next LT W23',
                            fontSize: 15,
                            color:  Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ), softWrap: false,),
                          Text(
                            context.watch<AppProvider>().utilitiesModel!=null?
                            context.watch<AppProvider>().utilitiesModel!.data!=null?
                            context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!=null?
                            context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!:"":"":"",
                            style: const TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 15,
                              color:  Color(0xffffffff),
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(width: widgetSize.getWidth(5, context)),
                          SvgPicture.asset(Assets.svgWallet,width: widgetSize.getWidth(20, context),color: Colors.white,),
                        ],),
                      ),),
                  ),
                )

              ],
            ),
          ),
        ));
  }

  Card buildBox (BuildContext context, String title, String value){
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(title),
            SizedBox(height: widgetSize.getHeight(5, context)),
            Text(value),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initial();
    //    context.read<HomeProvider>().getShippingOrders();
  }

  initial(){
    context.read<HomeProvider>().paymentLogPagingController = PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    context.read<HomeProvider>().paymentModel = PaymentData(agentPayable: 0.0, agentPayment: 0.0, agentCustomerPayment: 0.0);
    context
        .read<HomeProvider>()
        .paymentLogPagingController!
        .addPageRequestListener((pageKey) {
      context.read<HomeProvider>().fetchPaymentRequest(pageKey, filters);
    });
  }

  @override
  void dispose() {
    context.read<HomeProvider>().paymentLogPagingController!.dispose();
    super.dispose();
  }

  double removeNegativeSign(double? number){
    if(number!<0){
      return number*(-1.0);
    }
    return number;
  }
}
