import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';

class Loading extends StatelessWidget {
  String? loadingText;
  Loading({Key? key, this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          loadingText!,
          style: const TextStyle(color: Colors.amber, fontSize: 19.0),
        ),
        Container(
          padding: const EdgeInsets.all(12.0),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorResources.studio),
          ),
        ),
      ],
    ));
  }
}
