import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/model/app_version_model.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:store_redirect/store_redirect.dart';

import '../generated/assets.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key? key, required this.appVersionModel}) : super(key: key);
  final AppVersionModel appVersionModel;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svgLogoSvg, height: 300, color: ColorResources.studio),
            Text('وقت التحديث!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: ColorResources.studio)),
            const SizedBox(height: 20),
            Text('نسخة جديدة: ${Platform.isAndroid ? appVersionModel.androidApiVersion : appVersionModel.iosApiVersion}', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
              child: Text(appVersionModel.appUpdateMessage!, style: Theme.of(context).textTheme.bodyText1),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: StoreRedirect.redirect, child: const Text('تحديث'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                minimumSize: MaterialStateProperty.all(const Size(230.0, 50))
            ),),
            if(appVersionModel.mandatoryToUpdate == 0) TextButton(onPressed: Navigator.of(context).pop, child: const Text('ليس الآن'))
          ],
        ),
      ),
    );
  }
}
