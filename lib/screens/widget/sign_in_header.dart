import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';

class SignInHeaderWidget extends StatelessWidget {
  final bool? visibleArrow;

  const SignInHeaderWidget({super.key, this.visibleArrow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.65,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned.fill(
              child: SvgPicture.asset(
            Assets.svgLoginHeader,
          )),
          Visibility(
            visible: visibleArrow != null ? visibleArrow! : false,
            child: Positioned(
              left: 0,
              top: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeOnTap(
                  onSafeTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
