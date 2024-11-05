import 'package:flutter/material.dart';
import 'package:jocards/model/customer_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class CustomerNameDropDown extends StatefulWidget {
  const CustomerNameDropDown({super.key, this.onSaved});

  final FormFieldSetter<String>? onSaved;

  @override
  State<CustomerNameDropDown> createState() => _CustomerNameDropDownState();
}

class _CustomerNameDropDownState extends State<CustomerNameDropDown> {
  @override
  void initState() {
    context.read<AppProvider>().getAgentCustomersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CustomerModel? customerModel =
        context.watch<AppProvider>().customerModel;
    if (customerModel == null) return const CircularProgressIndicator();
    return SearchField<String>(
        searchInputDecoration: SearchInputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        hint: 'اختر الاسم',
        onSaved: widget.onSaved,
        suggestions: customerModel.data!
            .map((e) => SearchFieldListItem<String>(e.customerName!,
                child: Text(e.customerName!)))
            .toList());
  }
}
