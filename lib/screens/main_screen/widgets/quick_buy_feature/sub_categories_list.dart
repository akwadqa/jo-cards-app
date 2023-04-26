import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';

import '../../../../model/home_model.dart';
import '../../../../utill/widget_size.dart';


class SubCategoriesList extends StatefulWidget {
  const SubCategoriesList({Key? key, required this.subCategories, required this.onCategorySelected}) : super(key: key);
  final List<SubCategories> subCategories;
  final void Function(SubCategories subCategory) onCategorySelected;

  @override
  State<SubCategoriesList> createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
  late final List<bool> _isSelectedList = List<bool>.generate(widget.subCategories.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.subCategories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index){
        return ChoiceChip(
            label: Text(widget.subCategories[index].name!, style: TextStyle(fontSize: 12, color: _isSelectedList[index] ? Colors.white : ColorResources.pictonBlue)),
            backgroundColor: ColorResources.babyBlue,
            selectedColor: ColorResources.studio,
            selected: _isSelectedList[index],
            onSelected: (value) {
          if(value == true){
            _isSelectedList.fillRange(0, widget.subCategories.length, false);
            setState((){_isSelectedList[index] = true;});
            widget.onCategorySelected(widget.subCategories[index]);
          }
        });
      }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: widgetSize.getWidth(10, context)),
    );
  }
}
