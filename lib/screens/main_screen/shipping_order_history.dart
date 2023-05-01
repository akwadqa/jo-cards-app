import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/widgets/search/search_component.dart';
import 'package:jocards/screens/main_screen/widgets/wallet/my_wallet.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../generated/assets.dart';
import '../../model/shipping_order_response_model.dart';
import '../../provider/home_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/widget_size.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../widget/safe_on_tap.dart';

enum ShippingType{wallet, customers}

class ShippingOrderHistory extends StatefulWidget {
  final ShippingType shippingType;

  const ShippingOrderHistory({Key? key, required this.shippingType}) : super(key: key);
  @override
  _ShippingOrderHistoryState createState() => _ShippingOrderHistoryState();
}

class _ShippingOrderHistoryState extends State<ShippingOrderHistory> {
  late String filters = widget.shippingType == ShippingType.wallet ? context.read<AppProvider>().agentModel?.data != null &&  context.read<AppProvider>().agentModel!.data!.isNotEmpty ? '{"is_transfer": "0"}' : '{}' : '{"is_transfer": "1"}';
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
              filters = widget.shippingType == ShippingType.wallet ? context.read<AppProvider>().agentModel?.data != null &&  context.read<AppProvider>().agentModel!.data!.isNotEmpty ? '{"is_transfer": "0"}' : '{}' : '{"is_transfer": "1"}';
              context.read<HomeProvider>().shippingOrdersPagingController?.refresh();
              context.read<AppProvider>().getUtilities();
            }),
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: widgetSize.getHeight(20, context)),
                    child: const MyWallet()
                  ),
                ),
              ),
              if(widget.shippingType == ShippingType.customers) ...[
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: widgetSize.getHeight(20, context)),
                      child: Text(
                        'إجمالي الصندوق',
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
                  child: Container(
                    padding: EdgeInsets.all(
                        widgetSize.getHeight(8, context)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          widgetSize.getHeight(10, context)),
                    ),
                    child: Center(child: Text('${context.read<AppProvider>().utilitiesModel!.data?.payableAmount} دينار أردني', style: const TextStyle(color: ColorResources.red, fontSize: 20, fontWeight: FontWeight.w500),)),
                  ),
                ),
              ],
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
                    searchType: widget.shippingType == ShippingType.wallet ? SearchType.walletRequests : SearchType.customersRequests,
                    onSearch: (String filters) {
                      this.filters = filters;
                      context.read<HomeProvider>().shippingOrdersPagingController?.refresh();
                    },
                  )
              ),
              SliverToBoxAdapter(child: SizedBox(height: widgetSize.getHeight(10, context))),
              PagedSliverList<int, ShippingOrdeData>(

                  shrinkWrapFirstPageIndicators: false,
                  pagingController: context
                      .read<HomeProvider>()
                      .shippingOrdersPagingController!,
                  builderDelegate: PagedChildBuilderDelegate<ShippingOrdeData>(
                      firstPageProgressIndicatorBuilder:(_)=>Loading(loadingText: "")
                      ,

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
                          shippingOrdersPagingController!.error!.toString()),
                      itemBuilder: (context, item, index) => Padding(
                            padding: EdgeInsets.only(bottom: 20),
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
                                                Spacer(),
                                                Text(
                                                  item.digitalWalletRequestId!,
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
                                                  'مبلغ الشحن',
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Spacer(),
                                                Text(
                                                  item.requestedAmount!
                                                      .toString(),
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
                                                  'الحالة',
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Spacer(),
                                                Text(
                                                  item.status!.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                        const Color(0xff2e2e2e),
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
                                                  'المتبقي',
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                    const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Spacer(),
                                                Text(
                                                  item.unpaidAmount!,
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
                                                  'مقدم الطلب',
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Spacer(),
                                                Text(
                                                  item.owner!.toString(),
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: widgetSize.getHeight(
                                                    10, context)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'العميل',
                                                  style: TextStyle(
                                                    fontFamily: 'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                    const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Spacer(),
                                                Text(
                                                  item.customer!,
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
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: widgetSize.getHeight(5, context)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: ColorResources.whisper,
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    item.postingTime!.toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'DIN Next LT W23',
                                                      fontSize: widgetSize.getHeight(
                                                          14, context),
                                                      color: const Color(0xff6b6b6b),
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
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
                                            if(context.read<AppProvider>().agentModel?.data != null &&  context.read<AppProvider>().agentModel!.data!.isNotEmpty && item.workflowState == 'Pending' && item.docstatus == 0 && widget.shippingType == ShippingType.customers)
                                            SizedBox(
                                              width: 100,
                                              child: DropdownButtonFormField<String>(
                                                iconEnabledColor: Colors.white,
                                                selectedItemBuilder: (context){
                                                  return [const Text('اعتماد', style: TextStyle(color: Colors.white)), const Text('رفض', style: TextStyle(color: Colors.white))];
                                                },
                                                decoration: const InputDecoration(filled: true, fillColor: ColorResources.studio, border: InputBorder.none),
                                                hint: const Text('الإجراء', style: TextStyle(color: Colors.white)), items: const [DropdownMenuItem<String>(value: 'اعتماد', child: Text('اعتماد')), DropdownMenuItem<String>(value: 'رفض', child: Text('رفض'))],
                                                onChanged: (value) {
                                                  if(value != null){
                                                    showDialog(
                                                        context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            title: const Align(
                                                                alignment: AlignmentDirectional.center,
                                                                child: Text('تأكيد الإجراء')),
                                                            content: const Text('هل أنت متأكد من الإجراء. لا يمكن تغيير الاجراء بعد التأكيد.'),
                                                            actions: [
                                                              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء'), style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black), backgroundColor: MaterialStateProperty.all(ColorResources.gray89), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 10)))),
                                                              Consumer<HomeProvider>(
                                                                  builder: (context, data, _) {
                                                                    if(data.isLoading){
                                                                      return const CircularProgressIndicator(color: ColorResources.rose);
                                                                    }
                                                                    return ElevatedButton(onPressed: () async {
                                                                      var res = await context.read<HomeProvider>().dwrApproval(item.digitalWalletRequestId!, value == 'اعتماد' ? 'Approve' : 'Reject');
                                                                      if(res.status == Status.COMPLETED){
                                                                        context
                                                                            .read<HomeProvider>()
                                                                            .shippingOrdersPagingController!.refresh();
                                                                        Navigator.of(context).pop();
                                                                        Fluttertoast.showToast(
                                                                            backgroundColor: Colors.green,
                                                                            textColor: Colors.white,
                                                                            msg: res.data?.message ?? "",
                                                                            timeInSecForIosWeb: 4,
                                                                            toastLength: Toast.LENGTH_LONG);
                                                                      }
                                                                      else{
                                                                        Fluttertoast.showToast(
                                                                            backgroundColor: Colors.red,
                                                                            textColor: Colors.white,
                                                                            msg: res.data?.message ?? "",
                                                                            timeInSecForIosWeb: 4,
                                                                            toastLength: Toast.LENGTH_LONG);
                                                                      }
                                                                    }, child: const Text('تأكيد'), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorResources.rose), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 10))));
                                                                  }
                                                              ),
                                                            ],
                                                            alignment: AlignmentDirectional.center,
                                                            actionsAlignment: MainAxisAlignment.center,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          );
                                                        }
                                                    );
                                                  }
                                                },),
                                            ),
                                            if(context.read<AppProvider>().agentModel?.data != null &&  context.read<AppProvider>().agentModel!.data!.isNotEmpty && item.workflowState == 'Approved' && item.docstatus == 1 && (item.status == 'Partially Paid' || item.status == 'Unpaid') && widget.shippingType == ShippingType.customers)
                                              Container(
                                                decoration: const BoxDecoration(color: ColorResources.summerSky),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () => _showAgentPaymentEntryDialog(item),
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                      child: Text('سند قبض', style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ),
                                                ),
                                              )
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
                                      color: item.workflowState == 'Pending' ?
                                          Color(0xffECAE7E)
                                          : item.workflowState == 'Approved'
                                              ? Color(0xff4ABFA7)
                                              : item.workflowState == 'Rejected'
                                                  ? ColorResources.red
                                                  : Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 2),
                                    child: Text(
                                      item.workflowState == 'Pending'
                                          ? 'تحت الاجراء'
                                          : item.workflowState == 'Approved'
                                          ? 'معتمد'
                                          : item.workflowState == 'Rejected'
                                          ? 'مرفوض'
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
        ));
  }

  void _showAgentPaymentEntryDialog(ShippingOrdeData item){
    final _formKey = GlobalKey<FormState>();
    String? amount;
    showDialog(
        context: context,
        builder: (context){
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Row(
                children: [
                  Expanded(child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)))),
                  const Expanded(flex: 2, child: Text('تسجيل سند قبض')),
                  const Spacer()
                ],
              ),
              content: SizedBox(
                width: widgetSize.getWidth(200, context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('رقم الطلب'),
                        Text(item.digitalWalletRequestId.toString(), style: const TextStyle(color: ColorResources.pictonBlue, decoration: TextDecoration.underline))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('مقدم الطلب'),
                        const SizedBox(width: 20.0),
                        Expanded(
                            child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(item.owner!, style: const TextStyle(fontWeight: FontWeight.bold))))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الحالة'),
                        Text(item.status!, style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    const Text('المبلغ المستلم'),
                    const SizedBox(height: 5),
                    TextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'مطلوب';
                        }
                        if(double.parse(value) > double.parse(item.unpaidAmount!)){
                          return 'المبلغ لا يمكن أن يتعدى المبلغ المتبقي';
                        }
                        return null;
                      },
                      onSaved: (value) => amount = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorResources.mainColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorResources.mainColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorResources.mainColor)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 5)
                  ],
                ),
              ),
              actions: [
                Consumer<HomeProvider>(
                    builder: (context, data, child) {
                      if(data.isLoading){
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton.icon(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                            var res = await context.read<HomeProvider>().agentPaymentEntry(item.digitalWalletRequestId!, amount!);
                            if(res.status == Status.COMPLETED){
                              context.read<HomeProvider>().shippingOrdersPagingController?.refresh();
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  msg: res.data?.message ?? "",
                                  timeInSecForIosWeb: 4,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                            else{
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  msg: res.message ?? "",
                                  timeInSecForIosWeb: 4,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          }
                        }, label: const Text('تسجيل استلام'), style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 10))), icon: const Icon(Icons.file_download_rounded),);
                    }
                ),
              ],
              alignment: AlignmentDirectional.center,
              actionsAlignment: MainAxisAlignment.center,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          );
        }
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeOnTap(
                    onSafeTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(Assets.svgBack)),
                Spacer(),
                Text(
                  widget.shippingType == ShippingType.wallet ? "طلبات شحن المحفظة" : "طلبات شحن العملاء",
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(16, context),
                    color: const Color(0xffffffff),
                  ),
                  softWrap: false,
                ),
                Spacer(),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    initial();
      //    context.read<HomeProvider>().getShippingOrders();
  }

  initial(){
    context.read<HomeProvider>().shippingOrdersPagingController =
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    context
        .read<HomeProvider>()
        .shippingOrdersPagingController!
        .addPageRequestListener((pageKey) {
      context.read<HomeProvider>().fetchShippingOrders(pageKey, context, filters);
    });
  }

  @override
  void dispose() {
    context.read<HomeProvider>().shippingOrdersPagingController!.dispose();
    super.dispose();
  }
}
