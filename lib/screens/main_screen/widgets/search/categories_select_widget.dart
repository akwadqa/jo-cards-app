import 'package:flutter/material.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';

class CategorySelectWidget extends StatefulWidget {
  final void Function(String? category) getSelectedCategory;
  const CategorySelectWidget({Key? key, required this.getSelectedCategory}) : super(key: key);

  @override
  State<CategorySelectWidget> createState() => _CategorySelectWidgetState();
}

class _CategorySelectWidgetState extends State<CategorySelectWidget> {
  String? _category;

  // @override
  // void initState() {
  //
  //   SchedulerBinding.instance.addPostFrameCallback((_) async {
  //     print("print it");
  //     print(context.read<HomeProvider>().categoriesModelResponse);
  //     ApiResponse<CategoriesModel>? apiResponse = context.read<HomeProvider>().categoriesModelResponse;
  //     if (apiResponse!.status == Status.COMPLETED) {
  //       print(apiResponse.data!.data);
  //       if(apiResponse.data!.data != null){
  //         List<Data>? list = apiResponse.data!.data;
  //         for(int i=0; i< list!.length; i++){
  //           items.add(list[i].itemGroupId!);
  //         }
  //       }
  //     }
  //   });
  //   super.initState();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
            hint: const Text('اختر الفئة'),
            items: context.read<HomeProvider>().items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              setState((){
                _category = value;
              });
              widget.getSelectedCategory(_category);
            }
        ),
        SizedBox(height: widgetSize.getHeight(20, context)),
      ],
    );
  }
}
