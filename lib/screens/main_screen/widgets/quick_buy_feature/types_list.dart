import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';

import '../../../../model/home_model.dart';
import '../../../../model/item_category_model.dart';
import '../../../../utill/widget_size.dart';

class TypesList extends StatefulWidget {
  const TypesList({Key? key, required this.items, required this.onItemSelected}) : super(key: key);
  final List<Data> items;
  final void Function(Data item) onItemSelected;

  @override
  State<TypesList> createState() => _TypesListState();
}

class _TypesListState extends State<TypesList> {
  late final List<bool> _isSelectedList = List<bool>.generate(widget.items.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.items.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index){
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ChoiceChip(
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.items[index].productTitle!, style: TextStyle(fontSize: 12, color: _isSelectedList[index] ? Colors.white : ColorResources.pictonBlue)),
                      SizedBox(height: widgetSize.getHeight(5, context)),
                      RichText(
                          text: TextSpan(text: widget.items[index].itemPrice!,
                              style: TextStyle(fontSize: 12, color: _isSelectedList[index] ? Colors.white : ColorResources.rose),
                              children: const [
                                TextSpan(text: ' دينار', style: TextStyle(fontSize: 9))
                              ]
                          )),
                    ],
                  ),
                  backgroundColor: ColorResources.babyBlue,
                  selectedColor: ColorResources.studio,
                  selected: _isSelectedList[index],
                  onSelected: (value) {
                if(value == true && widget.items[index].inStock !=null && widget.items[index].inStock != 0){
                  _isSelectedList.fillRange(0, widget.items.length, false);
                  setState((){_isSelectedList[index] = true;});
                  widget.onItemSelected(widget.items[index]);
                }
              },
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
              ),
            ),
            if(widget.items[index].inStock !=null && widget.items[index].inStock == 0) const Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                  child: Chip(label: Text('غير متوفر', style: TextStyle(fontSize: 9, color: Colors.white)), backgroundColor: ColorResources.rose)),
            ),
          ],
        );
      }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: widgetSize.getWidth(10, context)),
    );
  }
}
