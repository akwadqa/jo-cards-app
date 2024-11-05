import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jocards/model/app_version_model.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/assets.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key, required this.appVersionModel});
  final AppVersionModel appVersionModel;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, _) => exit(0),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SvgPicture.asset(Assets.svgLogoSvg,
                    height: 300, color: ColorResources.studio)),
            Text('وقت التحديث!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: ColorResources.studio)),
            const SizedBox(height: 20),
            Text(
                'نسخة جديدة: ${Platform.isAndroid ? appVersionModel.androidApiVersion : appVersionModel.iosApiVersion}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
              child: Text(appVersionModel.appUpdateMessage!,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchUpdateUrl,
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                  textStyle: WidgetStateProperty.all(Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
                  minimumSize: WidgetStateProperty.all(const Size(230.0, 50))),
              child: const Text('تحديث'),
            ),
            if (appVersionModel.mandatoryToUpdate == 0)
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('ليس الآن'))
          ],
        ),
      ),
    );
  }

  void _launchUpdateUrl() {
    final url =
        Platform.isAndroid ? Strings.googlePlayLink : Strings.appStoreLink;
    launchUrl(Uri.parse(url));
  }
}
