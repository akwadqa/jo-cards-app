import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RefreshSpinkit extends StatelessWidget {
  final double circleSize;
  final double iconSize;
  const RefreshSpinkit({Key? key, required this.circleSize, required this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitCircle(size: circleSize,
        itemBuilder: (context, index)=>  Icon(Icons.circle, size: iconSize)));
  }
}
