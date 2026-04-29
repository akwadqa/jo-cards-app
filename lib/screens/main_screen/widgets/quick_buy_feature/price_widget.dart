import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:jocards/model/products_details_model.dart';
import 'package:jocards/utill/color_resources.dart';

import '../../../../utill/widget_size.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({Key? key, required this.price, required this.getTotalPriceAndCount, required this.productsDetailsData}) : super(key: key);
  final double price;
  final void Function(double totalPrice, int count) getTotalPriceAndCount;
  final ProductsDetailsData productsDetailsData;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  int _quantity = 2;
  bool isPressed = false;

  @override
  initState() {
    widget.getTotalPriceAndCount(widget.price * _quantity, !isPressed ? int.parse(widget.productsDetailsData.minimumOrderQuantities!) :_quantity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الكمية',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                      if(!isPressed){
                    setState(() {
                      isPressed = true;
                      _quantity = int.parse(widget.productsDetailsData.minimumOrderQuantities!);
                    });
                  }
                      if(widget.productsDetailsData.maximumOrderQuantities == null ? _quantity < 100 : _quantity < int.parse(widget.productsDetailsData.maximumOrderQuantities!)){
                        setState(() {
                          _quantity = _quantity + 1;
                          widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                        });
                      }
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    // onPressed: _quantity >= 100 ? null : () {
                    //   setState(() => _quantity++);
                    //   widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                    // },
                    child: const Icon(Icons.add)),
                SizedBox(width: widgetSize.getWidth(10, context)),
                Text((isPressed && widget.productsDetailsData.minimumOrderQuantities != null) ? _quantity.toString() : widget.productsDetailsData.minimumOrderQuantities!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(width: widgetSize.getWidth(10, context)),
                ElevatedButton(
                    onPressed: () {
                      if(!isPressed){
                        setState(() {
                          isPressed = true;
                          _quantity = int.parse(widget.productsDetailsData.minimumOrderQuantities!);
                        });
                      }
                      if (_quantity > 1 && _quantity > int.parse(widget.productsDetailsData.minimumOrderQuantities!)) {
                        setState(() {
                          _quantity = _quantity - 1;
                          widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                        });
                      }
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    // onPressed: _quantity <= 1 ? null : () {
                    //   setState(() => _quantity--);
                    //   widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                    // },
                    child: const Icon(Icons.remove)),
              ],
            ),
          ],
        ),
        SizedBox(height: widgetSize.getHeight(16, context)),
        DottedBorder(
          // borderType: BorderType.RRect,
          // radius: const Radius.circular(10),
          // color: ColorResources.gray89,
          // padding: EdgeInsets.zero,
          // dashPattern: const [10, 10],
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorResources.veryLightShadeOfGray,
              ),
              padding: EdgeInsets.all(widgetSize.getHeight(20, context)),
              child: Center(
                child: RichText(
                    text: TextSpan(
                        text: (!isPressed) ? '${int.parse(widget.productsDetailsData.minimumOrderQuantities!) * widget.price}' :'${_quantity * widget.price}' ,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.black),
                        children: const [
                      TextSpan(
                          text: ' دينار',
                          style: TextStyle(
                              color: ColorResources.gray61, fontSize: 19))
                    ])),
              ),
            ),
          ),
        )
      ],
    );
  }
}
