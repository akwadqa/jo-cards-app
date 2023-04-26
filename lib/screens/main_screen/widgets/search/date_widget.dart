import 'package:flutter/material.dart';
import 'package:jocards/screens/main_screen/widgets/search/custom_text_form_field.dart';

import '../../../../utill/strings.dart';
import '../../../../utill/widget_size.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({Key? key, required this.getDateRange}) : super(key: key);
  final void Function(DateTimeRange? range) getDateRange;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          hint: const Text('اختر الفترة'),
            items: Strings.periods.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              DateTimeRange range = _getDateRange(value!);
              setState((){
                _startDate = range.start;
                _endDate = range.end;
              });
              widget.getDateRange(DateTimeRange(start: _startDate!, end: _endDate!));
            }
        ),
        SizedBox(height: widgetSize.getHeight(20, context)),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextFormField(
                readOnly: true,
                hintText: _startDate?.dateString,
                onTap: () async {
                  DateTime? date = await _showDatePickerDialog(_startDate ?? DateTime.now());
                  if(date != null){
                    setState((){
                      _startDate = date;
                    });
                    widget.getDateRange(DateTimeRange(start: _startDate!, end: _endDate ?? DateTime.now()));
                  }
                },
              ),
            ),
            const Expanded(child: Center(child: Text('من/إلى'))),
            Expanded(
              flex: 2,
              child: CustomTextFormField(
                readOnly: true,
                hintText: _endDate?.dateString,
                onTap: () async {
                  DateTime? date = await _showDatePickerDialog(_endDate ?? DateTime.now());
                  if(date != null){
                    setState((){
                      _endDate = date;
                    });
                    widget.getDateRange(DateTimeRange(start: _startDate ?? DateTime.now(), end: _endDate!));
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Future<DateTime?> _showDatePickerDialog(DateTime initialDate) async {
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5)
    );
  }

  DateTimeRange _getDateRange(String period){
    switch(period) {
      case 'اليوم':
        return DateTimeRange(start: DateTime.now(), end: DateTime.now());
      case 'الأمس':
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 1)), end: DateTime.now().subtract(const Duration(days: 1)));
      case 'الأسبوع الحالي':
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
      case 'الأسبوع السابق':
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 14)), end: DateTime.now().subtract(const Duration(days: 7)));
      case 'الشهر الحالي':
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
      default:
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 60)), end: DateTime.now().subtract(const Duration(days: 30)));
    }
  }
}

extension DateTimeExtension on DateTime {
  String get dateString {
    return '$year-$month-$day';
  }
}
