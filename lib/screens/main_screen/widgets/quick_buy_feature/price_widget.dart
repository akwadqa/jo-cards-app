import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';

import '../../../../utill/widget_size.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({Key? key, required this.price, required this.getTotalPriceAndCount}) : super(key: key);
  final double price;
  final void Function(double totalPrice, int count) getTotalPriceAndCount;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  int _quantity = 1;

  @override
  initState() {
    widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
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
                    onPressed: _quantity >= 100 ? null : () {
                      setState(() => _quantity++);
                      widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                    },
                    child: const Icon(Icons.add),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))))),
                SizedBox(width: widgetSize.getWidth(10, context)),
                Text(_quantity.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(width: widgetSize.getWidth(10, context)),
                ElevatedButton(
                    onPressed: _quantity <= 1 ? null : () {
                      setState(() => _quantity--);
                      widget.getTotalPriceAndCount(widget.price * _quantity, _quantity);
                    },
                    child: const Icon(Icons.remove),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))))),
              ],
            ),
          ],
        ),
        SizedBox(height: widgetSize.getHeight(16, context)),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          color: ColorResources.gray89,
          padding: EdgeInsets.zero,
          dashPattern: const [10, 10],
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
                        text: '${_quantity * widget.price}',
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
