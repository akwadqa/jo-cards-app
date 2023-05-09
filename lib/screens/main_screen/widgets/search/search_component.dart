import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jocards/screens/main_screen/widgets/check_box/akwad_checkbox.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/titled_list.dart';
import 'package:jocards/screens/main_screen/widgets/search/date_widget.dart';
import 'package:jocards/screens/main_screen/widgets/search/transfer_check_box.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../../provider/app_provider.dart';
import '../../../../utill/color_resources.dart';
import 'custom_text_form_field.dart';

enum SearchType {
  salesRequests,
  walletRequests,
  customersRequests,
  walletRequestsLog,
  batchLog,
}

class SearchComponent extends StatelessWidget {
  const SearchComponent({Key? key, required this.searchType, required this.onSearch}) : super(key: key);
  final SearchType searchType;
  final void Function(String filters) onSearch;
  @override
  Widget build(BuildContext context) {
    String _searchText = (searchType == SearchType.walletRequestsLog || searchType == SearchType.batchLog) ? 'البحث  في عمليات المحفظة' : 'البحث في الطلبات';
    return TextFormField(
      readOnly: true,
      onTap: () {
        String? _orderNumber;
        String? _customerName;
        String? _transactionNumber;
        String? _paymentStatus;
        String? _orderStatus;
        String? _transactionType;
        bool? _isTransfer;
        DateTimeRange? _dateTimeRange;
        final _formKey = GlobalKey<FormState>();
        showBarModalBottomSheet(
            context: context,
            builder: (context){
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_searchText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: widgetSize.getHeight(10, context)),
                    if(searchType != SearchType.walletRequestsLog && searchType != SearchType.batchLog)...[
                      const Text('رقم الطلب', style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                    ],
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: searchType == SearchType.walletRequestsLog ? 4 : searchType == SearchType.walletRequests ? 3 : searchType == SearchType.batchLog ? 1: 2,
                                child: CustomTextFormField(
                                  hintText: 'رقم الطلب',
                                  onSaved: (value) => _orderNumber = value,
                                ),
                              ),
                              if(searchType != SearchType.walletRequests && searchType != SearchType.batchLog)
                                const Spacer(),
                               if(searchType == SearchType.walletRequests)
                                Expanded(flex : 3, child: Row(
                                  children: [
                                    TransferCheckBox(onChanged: (bool value) => _isTransfer = value),
                                    const Text("تحويل"),
                                  ],
                                ),),

                              if(searchType == SearchType.walletRequestsLog)
                                Expanded(
                                  flex: 4,
                                  child: CustomTextFormField(
                                    hintText: 'رقم التحويل',
                                    onSaved: (value) => _transactionNumber = value,
                                  ),
                                ),

                              if(searchType == SearchType.batchLog)...[
                                SizedBox(width: widgetSize.getWidth(10, context)),
                                Expanded(
                                  flex: 1,
                                  child: CustomTextFormField(
                                    hintText: 'رقم الدفع',
                                    onSaved: (value) => _transactionNumber = value,
                                  ),
                                ),
                                ],
                            ],
                          ),
                          SizedBox(height: widgetSize.getHeight(10, context)),
                          if(searchType == SearchType.walletRequests || searchType == SearchType.walletRequestsLog) ...[
                            CustomTextFormField(
                              hintText: 'اسم العميل',
                              onSaved: (value) => _customerName = value,
                            ),
                            SizedBox(height: widgetSize.getHeight(10, context)),
                          ],
                          if(searchType == SearchType.walletRequests || searchType == SearchType.salesRequests ||  searchType == SearchType.walletRequestsLog) ...[
                            const Text('الإجمالي (دينار)', style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: widgetSize.getHeight(10, context)),
                            Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextFormField(
                                  readOnly: true,
                                  hintText: "00",
                                  align: TextAlign.center,
                                  onTap: () async {},
                                ),
                              ),
                              const Expanded(child: Center(child: Text('من/إلى'))),
                              Expanded(
                                flex: 2,
                                child: CustomTextFormField(
                                  readOnly: true,
                                  hintText: "500000",
                                  align: TextAlign.center,
                                  onTap: () async {},
                                ),
                              )
                            ],
                          ),
                            SizedBox(height: widgetSize.getHeight(10, context)),
                          ],
                        ],
                      ),
                    ),
                    // TODO 2: إضافة حقل الفئة بس سألي شو بدك تضيفي بقلبه لانو ماله موجود من قبل والداتا مو عنا
                    if(searchType == SearchType.salesRequests)...[
                      TitledList(
                          title: 'حالة الطلب',
                        height: 200,
                          child: _ChipsRow(
                            titles: const ['تعبئة ناجحة لمحفظة البرهان', 'شراء ناجح للبطاقة', 'الطلب ملغي', "طلب منتهي", "فشل الطلب", "تحت الطلب", "طلب مكتمل للأرشفة", "طلب مفتوح", "بإنتظار مكالمة"],
                            onItemSelected: (String? item) => _paymentStatus =  item
                          ),
                      ),

                    ],
                    if(searchType == SearchType.walletRequests || searchType == SearchType.customersRequests)...[
                      TitledList(
                          title: 'حالة الدفع',
                          child: _ChipsRow(
                            titles: const ['مدفوع', 'غير مدفوع', 'مدفوع جزئيا'],
                            onItemSelected: (String? item) => _paymentStatus = item,
                          )
                      ),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                      TitledList(
                          title: 'حالة الطلب',
                          child: _ChipsRow(
                            titles: const ['معتمد', 'مرفوض', 'تحت الإجراء'],
                            onItemSelected: (String? item) => _orderStatus = item,
                          )
                      ),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                    ],
                    if(searchType == SearchType.walletRequestsLog)...[
                      TitledList(
                          title: 'نوع الحركة',
                          child: Row(
                            children: [
                              _ChipsRow(
                                titles: const ['  ايداع    ', '  خصم    '],
                                onItemSelected: (String? item) => _transactionType = item,
                              ),
                              SizedBox(width: widgetSize.getWidth(20, context)),
                            //   TransferCheckBox(onChanged: (bool value) => _isTransfer = value),
                            //   const Text('تحويل', style: TextStyle(fontWeight: FontWeight.w500)),
                             ],
                          )
                      ),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                      TitledList(
                        title: 'حالة الطلب',
                        height: 100,
                        child: _ChipsRow(
                            titles: const ['إيداع من قبل برهان', 'خصم من قبل برهان', 'طلب شحن من قبل العميل', ],
                            onItemSelected: (String? item) => _paymentStatus =  item
                        ),
                      ),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                    ],
                    if(searchType == SearchType.batchLog)...[
                      TitledList(
                          title: 'نوع الحركة',
                          child: Row(
                            children: [
                              _ChipsRow(
                                titles: const ['   التسويات    ', '   الدفعات    '],
                                onItemSelected: (String? item) => _transactionType = item,
                              ),
                              SizedBox(width: widgetSize.getWidth(20, context)),
                            ],
                          )
                      ),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                    ],
                    if(searchType != SearchType.batchLog) ...[
                      const Text('الفترة الزمنية', style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: widgetSize.getHeight(10, context)),
                    DateWidget(getDateRange: (DateTimeRange? range) => _dateTimeRange = range),
                    SizedBox(height: widgetSize.getHeight(20, context)),],
                    if(searchType == SearchType.batchLog)...[
                      const Text('الفترة الزمنية', style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: widgetSize.getHeight(10, context)),
                      DateWidget(getDateRange: (DateTimeRange? range) => _dateTimeRange = range, isFromBatchScreen: true),

                    ],
                    ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          _filter(context, _orderNumber, _transactionNumber, _paymentStatus, _orderStatus, _transactionType, _isTransfer, _dateTimeRange);
                          },
                        child: const Text('بحث'),
                        style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                            backgroundColor: MaterialStateProperty.all(ColorResources.lightBlue),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                    )
                  ],
                ),
              );
            }
        );
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: _searchText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: const Icon(Icons.arrow_forward_ios)
      ),
    );
  }

  void _filter(BuildContext context, String? orderNumber, String? transactionNumber, String? paymentStatus, String? orderStatus, String? transactionType, bool? isTransfer, DateTimeRange? dateTimeRange) {
    Navigator.of(context).pop();
    String? startDate = dateTimeRange?.start.dateString;
    String? endDate = dateTimeRange?.end.dateString;
    Map<String, dynamic> filters;
    switch(searchType){
      case SearchType.salesRequests:
        filters = {
          if(orderNumber != null && orderNumber.isNotEmpty) 'order_no': orderNumber,
          if(startDate != null && startDate.isNotEmpty) 'from_date': startDate,
          if(endDate != null && endDate.isNotEmpty) 'to_date': endDate,
        };
        break;
      case SearchType.walletRequests:
        filters = {
          if(orderNumber != null && orderNumber.isNotEmpty) 'name': orderNumber,
          if(context.read<AppProvider>().agentModel?.data != null &&  context.read<AppProvider>().agentModel!.data!.isNotEmpty) 'is_transfer': '0',
          if(paymentStatus != null && paymentStatus.isNotEmpty) 'status': _getPaymentState(paymentStatus),
          if(orderStatus != null && orderStatus.isNotEmpty) 'workflow_state': _getWorkFlowState(orderStatus),
          if(startDate != null && startDate.isNotEmpty) 'from_date': startDate,
          if(endDate != null && endDate.isNotEmpty) 'to_date': endDate,
        };
        break;
      case SearchType.customersRequests:
        filters = {
          if(orderNumber != null && orderNumber.isNotEmpty) 'name': orderNumber,
          'is_transfer': '1',
          if(paymentStatus != null && paymentStatus.isNotEmpty) 'status': _getPaymentState(paymentStatus),
          if(orderStatus != null && orderStatus.isNotEmpty) 'workflow_state': _getWorkFlowState(orderStatus),
          if(startDate != null && startDate.isNotEmpty) 'from_date': startDate,
          if(endDate != null && endDate.isNotEmpty) 'to_date': endDate,
        };
        break;
      case SearchType.walletRequestsLog:
        filters = {
          if(orderNumber != null && orderNumber.isNotEmpty) 'order_number': orderNumber,
          if(transactionNumber != null && transactionNumber.isNotEmpty) 'dwr_number' : transactionNumber,
          if(transactionType != null && transactionType.isNotEmpty) 'log_type': _getTransactionType(transactionType),
          if(isTransfer != null) 'is_transfer': isTransfer? '1' : '0',
          if(startDate != null && startDate.isNotEmpty) 'from_date': startDate,
          if(endDate != null && endDate.isNotEmpty) 'to_date': endDate,
        };
        break;
      case SearchType.batchLog:
        filters = {
          if(orderNumber != null && orderNumber.isNotEmpty) 'order_number': orderNumber,
          if(transactionNumber != null && transactionNumber.isNotEmpty) 'dwr_number' : transactionNumber,
          if(transactionType != null && transactionType.isNotEmpty) 'log_type': _getTransactionType(transactionType),
          if(isTransfer != null) 'is_transfer': isTransfer? '1' : '0',
          if(startDate != null && startDate.isNotEmpty) 'from_date': startDate,
          if(endDate != null && endDate.isNotEmpty) 'to_date': endDate,
        };
        break;
    }
    onSearch(jsonEncode(filters));
  }

  String _getWorkFlowState(String value){
    switch(value){
      case 'معتمد':
        return 'Approved';
      case 'مرفوض':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  String _getPaymentState(String value){
    switch(value){
      case 'مدفوع':
        return 'Paid';
      case 'غير مدفوع':
        return 'Unpaid';
      default:
        return 'Partially Paid';
    }
  }

  String _getTransactionType(String value){
    switch(value){
      case 'خصم':
        return 'Debit';
      default:
        return 'Credit';
    }
  }
}

class _ChipsRow extends StatefulWidget {
  const _ChipsRow({Key? key, required this.titles, required this.onItemSelected}) : super(key: key);
  final List<String> titles;
  final void Function(String? item) onItemSelected;

  @override
  State<_ChipsRow> createState() => _ChipsRowState();
}

class _ChipsRowState extends State<_ChipsRow> {
  late final List<bool> _isSelectedList = List<bool>.generate(widget.titles.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: widget.titles.map((e) => ChoiceChip(
        backgroundColor: ColorResources.babyBlue,
        selectedColor: Colors.blue,
          label: Text(e),
          labelStyle: TextStyle(color: _isSelectedList[widget.titles.indexOf(e)] ? Colors.white : Colors.blue),
          selected: _isSelectedList[widget.titles.indexOf(e)],
        onSelected: (bool value) {
          if(value) {
            setState(() {
              _isSelectedList.fillRange(0, widget.titles.length, false);
              _isSelectedList[widget.titles.indexOf(e)] = value;
            });
            widget.onItemSelected(e);
          }
        },
      )).toList()
    );
  }
}

