import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/direct_order_request_model.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/print_screen.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../main.dart';
import '../../model/direct_order_response.dart';
import '../../model/products_details_model.dart';
import '../../provider/app_provider.dart';
import '../../utill/validations.dart';
import '../auth/sign_in_screen.dart';
import '../widget/error.dart';
import '../widget/loading.dart';
import '../widget/textformfield.dart';
import 'main_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String title;
  final String id;

  const ProductDetailsScreen(this.title, this.id, {super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int count = 1;
  bool isPressed = false;
  late TabController tabController;
  int selectedIndex = 0;
  final GlobalKey<FormState> _key = GlobalKey();
  bool moreThanAvailableWalletBalance = false;
  double percent = 0.0;
  // 1
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, _) => _onWillPop(),
      child: Scaffold(
          backgroundColor: ColorResources.gray89,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              count = 1;
              isPressed = false;
              selectedIndex = 0;
              moreThanAvailableWalletBalance = false;
              var res = await context
                  .read<HomeProvider>()
                  .getProductDetails(widget.id);
              if (res.data != null && res.data!.data != null) {
                var temp = res.data!.data![0];
                if (temp.productOptions != null &&
                    temp.productOptions!.isNotEmpty) {
                  for (ProductOptions productOptions in temp.productOptions!) {
                    multiLineAreaOptions.add(TextEditingController());
                    textAreaOptions.add(TextEditingController());
                    numberOptions.add(TextEditingController());
                  }
                }
              }
              context.read<AppProvider>().getUtilities();
            },
            child:
                Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              if (homeProvider.productDetailsResponse != null) {
                switch (homeProvider.productDetailsResponse!.status!) {
                  case Status.LOADING:
                    return Align(
                      child: Loading(
                          loadingText:
                              homeProvider.productDetailsResponse!.message),
                    );

                  case Status.COMPLETED:
                    var item =
                        homeProvider.productDetailsResponse!.data!.data![0];
                    return ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widgetSize.getWidth(16, context),
                              vertical: widgetSize.getHeight(20, context)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: item.backgroundColor == null
                                  ? Colors.white
                                  : hexToColor(item.backgroundColor!),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                imageUrl: Strings.BASR_URl + item.websiteImage!,
                                imageBuilder: (context, imageProvider) =>
                                    AspectRatio(
                                  aspectRatio: 2.46,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const AspectRatio(
                                  aspectRatio: 2.46,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                ColorResources.studio)),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const AspectRatio(
                                  aspectRatio: 2.46,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        widgetSize.getWidth(16, context),
                                    vertical:
                                        widgetSize.getHeight(20, context)),
                                child: Align(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          item.websiteItemName!,
                                          style: TextStyle(
                                            fontFamily: 'DIN Next LT W23',
                                            fontSize: widgetSize.getHeight(
                                                23, context),
                                            color: const Color(0xff2e2e2e),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.right,
                                          softWrap: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(26, context),
                                      ),
                                      if (item.productOptions != null &&
                                          item.productOptions!.isEmpty) ...[
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'التفاصيل',
                                            style: TextStyle(
                                              fontFamily: 'DIN Next LT W23',
                                              fontSize: widgetSize.getHeight(
                                                  18, context),
                                              color: const Color(0xff6b6b6b),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: false,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              widgetSize.getHeight(5, context),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: buildTextWithURL(
                                                text: item.webLongDescription ??
                                                    "",
                                                defaultTextStyle: TextStyle(
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color: const Color(
                                                        0xff2e2e2e)))),
                                      ],
                                      if (item.productOptions != null &&
                                          item.productOptions!.isNotEmpty) ...[
                                        TabBar(
                                          indicatorColor: ColorResources.studio,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          indicatorWeight: 2,
                                          indicatorPadding:
                                              const EdgeInsets.all(0),
                                          controller: tabController,
                                          labelColor: ColorResources.studio,
                                          unselectedLabelColor:
                                              ColorResources.dimGray,
                                          onTap: (int index) {
                                            setState(() {
                                              selectedIndex = index;
                                              tabController.animateTo(index);
                                            });
                                          },
                                          tabs: [
                                            Tab(
                                              child: Text('الخيارات',
                                                  style: TextStyle(
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context))),
                                            ),
                                            Tab(
                                              child: Text('التفاصيل',
                                                  style: TextStyle(
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context))),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              widgetSize.getHeight(20, context),
                                        ),
                                        IndexedStack(
                                          index: selectedIndex,
                                          children: <Widget>[
                                            Visibility(
                                              maintainState: true,
                                              visible: selectedIndex == 0,
                                              child: Form(
                                                key: _key,
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: item
                                                        .productOptions!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (item
                                                              .productOptions![
                                                                  index]
                                                              .optionType ==
                                                          "Radio Group") {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item
                                                                  .productOptions![
                                                                      index]
                                                                  .optionName!,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'DIN Next LT W23',
                                                                fontSize: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                                color: const Color(
                                                                    0xff6b6b6b),
                                                              ),
                                                              softWrap: false,
                                                            ),
                                                            SizedBox(
                                                              height: widgetSize
                                                                  .getHeight(12,
                                                                      context),
                                                            ),
                                                            item
                                                                        .productOptions![
                                                                            index]
                                                                        .viewOption ==
                                                                    'Label'
                                                                ? Wrap(
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runSpacing:
                                                                        10,
                                                                    spacing: 30,
                                                                    children: item
                                                                        .productOptions![
                                                                            index]
                                                                        .radioGroupOption!
                                                                        .map<Widget>((e) =>
                                                                            SafeOnTap(
                                                                              onSafeTap: () {
                                                                                for (RadioGroupOption item in item.productOptions![index].radioGroupOption!) {
                                                                                  item.selected = false;
                                                                                }
                                                                                item.productOptions![index].answer = e.name1;
                                                                                e.selected = true;
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: e.selected! ? ColorResources.studio : const Color(0xfff8f2ff),
                                                                                  borderRadius: BorderRadius.circular(14.0),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                                                  child: Text(
                                                                                    e.name1!,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'DIN Next LT W23',
                                                                                      fontSize: widgetSize.getHeight(14, context),
                                                                                      color: e.selected! ? Colors.white : const Color(0xff2e2e2e),
                                                                                    ),
                                                                                    softWrap: false,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        .toList(),
                                                                  )
                                                                : DropdownButtonFormField<
                                                                        RadioGroupOption>(
                                                                    hint: const Text(
                                                                        'اختر الخيار'),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                        borderSide:
                                                                            const BorderSide(color: ColorResources.sliver),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                        borderSide:
                                                                            const BorderSide(color: ColorResources.sliver),
                                                                      ),
                                                                    ),
                                                                    items: item
                                                                        .productOptions![
                                                                            index]
                                                                        .radioGroupOption!
                                                                        .map((e) => DropdownMenuItem<RadioGroupOption>(
                                                                            value:
                                                                                e,
                                                                            child: Text(e
                                                                                .name1!)))
                                                                        .toList(),
                                                                    onChanged:
                                                                        (value) {
                                                                      for (RadioGroupOption item in item
                                                                          .productOptions![
                                                                              index]
                                                                          .radioGroupOption!) {
                                                                        item.selected =
                                                                            false;
                                                                      }
                                                                      item.productOptions![index].answer =
                                                                          value!
                                                                              .name1;
                                                                      value.selected =
                                                                          true;
                                                                    }),
                                                            if (item.productOptions!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                height: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                              ),
                                                            ]
                                                          ],
                                                        );
                                                      }
                                                      if (item
                                                              .productOptions![
                                                                  index]
                                                              .optionType ==
                                                          "Text Area") {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item
                                                                  .productOptions![
                                                                      index]
                                                                  .optionName!,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'DIN Next LT W23',
                                                                fontSize: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                                color: const Color(
                                                                    0xff6b6b6b),
                                                              ),
                                                              softWrap: false,
                                                            ),
                                                            SizedBox(
                                                              height: widgetSize
                                                                  .getHeight(8,
                                                                      context),
                                                            ),
                                                            CustomTextField(
                                                              maxLines: 6,
                                                              borderRaduis: 10,
                                                              obscureText:
                                                                  false,
                                                              hint: item
                                                                  .productOptions![
                                                                      index]
                                                                  .hint,
                                                              validate: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? Validations()
                                                                      .filedRequired
                                                                  : null,
                                                              hintStyle: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? const TextStyle(
                                                                      color: ColorResources
                                                                          .red)
                                                                  : null,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              textEditingController:
                                                                  multiLineAreaOptions[
                                                                      index],
                                                              onSaved: (String?
                                                                  value) {
                                                                item
                                                                    .productOptions![
                                                                        index]
                                                                    .answer = value;
                                                              },
                                                            ),
                                                            if (item.productOptions!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                height: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                              ),
                                                            ]
                                                          ],
                                                        );
                                                      }
                                                      if (item
                                                              .productOptions![
                                                                  index]
                                                              .optionType ==
                                                          "Number Input") {
                                                        if (item
                                                                .productOptions![
                                                                    index]
                                                                .isPriceModifier ==
                                                            1) {
                                                          percent = percent +
                                                              item
                                                                  .productOptions![
                                                                      index]
                                                                  .percentage;
                                                        }
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item
                                                                  .productOptions![
                                                                      index]
                                                                  .optionName!,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'DIN Next LT W23',
                                                                fontSize: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                                color: const Color(
                                                                    0xff6b6b6b),
                                                              ),
                                                              softWrap: false,
                                                            ),
                                                            SizedBox(
                                                              height: widgetSize
                                                                  .getHeight(8,
                                                                      context),
                                                            ),
                                                            CustomTextField(
                                                              maxLines: 1,
                                                              borderRaduis: 10,
                                                              onChanged:
                                                                  (value) {
                                                                value = changeDigit(
                                                                    value!,
                                                                    NumStrLanguage
                                                                        .English);

                                                                numberOptions[
                                                                        index]
                                                                    .text = value;
                                                                numberOptions[
                                                                            index]
                                                                        .selection =
                                                                    TextSelection.fromPosition(TextPosition(
                                                                        offset: numberOptions[index]
                                                                            .text
                                                                            .length));

                                                                _key.currentState!
                                                                    .save();
                                                                setState(() {
                                                                  getFinalPriceModifier(
                                                                      item);
                                                                });
                                                              },
                                                              hint: item
                                                                  .productOptions![
                                                                      index]
                                                                  .hint,
                                                              obscureText:
                                                                  false,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textEditingController:
                                                                  numberOptions[
                                                                      index],
                                                              validate: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? Validations()
                                                                      .filedRequired
                                                                  : null,
                                                              hintStyle: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? const TextStyle(
                                                                      color: ColorResources
                                                                          .red)
                                                                  : null,
                                                              onSaved: (String?
                                                                  value) {
                                                                item
                                                                    .productOptions![
                                                                        index]
                                                                    .answer = value;
                                                              },
                                                            ),
                                                            if (item.productOptions!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                height: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                              ),
                                                            ]
                                                          ],
                                                        );
                                                      }
                                                      if (item
                                                              .productOptions![
                                                                  index]
                                                              .optionType ==
                                                          "Text Input") {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item
                                                                  .productOptions![
                                                                      index]
                                                                  .optionName!,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'DIN Next LT W23',
                                                                fontSize: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                                color: const Color(
                                                                    0xff6b6b6b),
                                                              ),
                                                              softWrap: false,
                                                            ),
                                                            SizedBox(
                                                              height: widgetSize
                                                                  .getHeight(8,
                                                                      context),
                                                            ),
                                                            CustomTextField(
                                                              maxLines: 1,
                                                              borderRaduis: 10,
                                                              obscureText:
                                                                  false,
                                                              hint: item
                                                                  .productOptions![
                                                                      index]
                                                                  .hint,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              textEditingController:
                                                                  textAreaOptions[
                                                                      index],
                                                              validate: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? Validations()
                                                                      .filedRequired
                                                                  : null,
                                                              hintStyle: item
                                                                          .productOptions![
                                                                              index]
                                                                          .isMandatory ==
                                                                      1
                                                                  ? const TextStyle(
                                                                      color: ColorResources
                                                                          .red)
                                                                  : null,
                                                              onSaved: (String?
                                                                  value) {
                                                                item
                                                                    .productOptions![
                                                                        index]
                                                                    .answer = value;
                                                              },
                                                            ),
                                                            if (item.productOptions!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                height: widgetSize
                                                                    .getHeight(
                                                                        15,
                                                                        context),
                                                              ),
                                                            ]
                                                          ],
                                                        );
                                                      }
                                                      return const Text("");
                                                    }),
                                              ),
                                            ),
                                            Visibility(
                                                maintainState: true,
                                                visible: selectedIndex == 1,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: buildTextWithURL(
                                                    text:
                                                        item.webLongDescription ??
                                                            '',
                                                    defaultTextStyle: TextStyle(
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              16, context),
                                                      color: const Color(
                                                          0xff2e2e2e),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                      Visibility(
                                        visible: !hideQuantity(item),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  30, context),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'الكمية',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(18, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  width: widgetSize.getWidth(
                                                      50, context),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SafeOnTap(
                                                          onSafeTap: () {
                                                            if (!isPressed) {
                                                              setState(() {
                                                                isPressed =
                                                                    true;
                                                                count = int
                                                                    .parse(item
                                                                        .minimumOrderQuantities!);
                                                              });
                                                            }
                                                            if (item.maximumOrderQuantities ==
                                                                    null
                                                                ? count < 100
                                                                : count <
                                                                    int.parse(item
                                                                        .maximumOrderQuantities!)) {
                                                              setState(() {
                                                                count =
                                                                    count + 1;
                                                                getFinalPrice(
                                                                    item);
                                                              });
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                                  Assets
                                                                      .svgAdd)),
                                                      SizedBox(
                                                        width:
                                                            widgetSize.getWidth(
                                                                10, context),
                                                      ),
                                                      Text(
                                                        (isPressed &&
                                                                item.minimumOrderQuantities !=
                                                                    null)
                                                            ? count.toString()
                                                            : item
                                                                .minimumOrderQuantities!,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'DIN Next LT W23',
                                                          fontSize: widgetSize
                                                              .getHeight(
                                                                  16, context),
                                                          color: const Color(
                                                              0xff6b6b6b),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        softWrap: false,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            widgetSize.getWidth(
                                                                10, context),
                                                      ),
                                                      SafeOnTap(
                                                          onSafeTap: () {
                                                            if (!isPressed) {
                                                              setState(() {
                                                                isPressed =
                                                                    true;
                                                                count = int
                                                                    .parse(item
                                                                        .minimumOrderQuantities!);
                                                              });
                                                            }
                                                            if (count > 1 &&
                                                                count >
                                                                    int.parse(item
                                                                        .minimumOrderQuantities!)) {
                                                              setState(() {
                                                                count =
                                                                    count - 1;
                                                                getFinalPrice(
                                                                    item);
                                                              });
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                                  Assets
                                                                      .svgSub)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(30, context),
                                      ),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'السعر الإجمالي',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    18, context),
                                                color: const Color(0xff6b6b6b),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                          ),
                                          SizedBox(
                                            height: widgetSize.getHeight(
                                                8, context),
                                          ),
                                          Container(
                                            height: widgetSize.getHeight(
                                                70, context),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff6f6f6),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xffe3e3e3)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  hideQuantity(item)
                                                      ? getFinalPriceModifier(
                                                          item)
                                                      : getFinalPrice(item),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(32, context),
                                                    color:
                                                        const Color(0xff2e2e2e),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  width: widgetSize.getWidth(
                                                      8, context),
                                                ),
                                                Text(
                                                  item.currency!,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(18, context),
                                                    color:
                                                        const Color(0xff9c9c9c),
                                                  ),
                                                  softWrap: false,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(70, context),
                                      ),
                                      if (item.inStock != null &&
                                          item.inStock == 1) ...[
                                        SafeOnTap(
                                          onSafeTap: () async {
                                            FocusScope.of(context).unfocus();
                                            if (!moreThanAvailableWalletBalance &&
                                                double.parse(item
                                                        .discountedPrice!) !=
                                                    0.0) {
                                              if (context
                                                      .read<AppProvider>()
                                                      .getUserInfo() !=
                                                  null) {
                                                await checkValidationAndDirectRequest(
                                                    item);
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignInScreen(
                                                              fromSetting: true,
                                                            )));
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: widgetSize.getHeight(
                                                60, context),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: !moreThanAvailableWalletBalance &&
                                                      double.parse(item
                                                              .discountedPrice!) !=
                                                          0.0
                                                  ? const Color(0xff2892d7)
                                                  : const Color(0xffa2a2a2),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff2892d7)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x401d4c9b),
                                                  offset: Offset(0, 5),
                                                  blurRadius: 11,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                !moreThanAvailableWalletBalance &&
                                                        double.parse(item
                                                                .discountedPrice!) !=
                                                            0.0
                                                    ? 'متابعة الشراء'
                                                    : 'لا يوجد رصيد كافي',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(20, context),
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                      if (item.inStock != null &&
                                          item.inStock == 0) ...[
                                        SafeOnTap(
                                          onSafeTap: () {},
                                          child: Container(
                                            height: widgetSize.getHeight(
                                                60, context),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffa2a2a2),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xffa2a2a2)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x401d4c9b),
                                                  offset: Offset(0, 5),
                                                  blurRadius: 11,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'غير متوفر بالمخزون',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: widgetSize
                                                      .getHeight(20, context),
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: widgetSize.getWidth(50, context),
                                child: SafeOnTap(
                                    onSafeTap: () {
                                      if (item.shortDescription != null) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0)),
                                            //this right here
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: widgetSize
                                                      .getWidth(20, context)),
                                              child: ListView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: widgetSize
                                                        .getHeight(20, context),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SafeOnTap(
                                                          onSafeTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: SvgPicture
                                                              .asset(Assets
                                                                  .svgCancelDirectOrder)),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: widgetSize
                                                        .getHeight(10, context),
                                                  ),
                                                  Text(
                                                    item.shortDescription!,
                                                    maxLines: null,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              18, context),
                                                      color: const Color(
                                                          0xff2e2e2e),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: widgetSize
                                                        .getHeight(20, context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: SvgPicture.asset(
                                        Assets.svgProductInfo)))
                          ],
                        )
                      ],
                    );

                  case Status.ERROR:
                    return Error(
                        errorMsg: homeProvider.productDetailsResponse!.message);
                }
              }
              return Container();
            }),
          )),
    );
  }

  checkValidationAndDirectRequest(ProductsDetailsData item) async {
    if (_key.currentState != null) {
      _key.currentState!.save();
      if (_key.currentState!.validate()) {
        if (item.productOptions != null) {
          var radioGroupListExist = item.productOptions!
              .where((element) =>
                  element.optionType == "Radio Group" &&
                  element.isMandatory == 1)
              .toList();

          if (radioGroupListExist.isEmpty) {
            await directOrderRequest(item);
          } else {
            if (radioGroupListExist
                    .singleWhere((element) => element.answer == null,
                        orElse: () => ProductOptions(answer: "null"))
                    .answer ==
                "null") {
              await directOrderRequest(item);
            } else {
              Fluttertoast.showToast(
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  msg: "يرجى الاجابة على جميع الاسئلة",
                  timeInSecForIosWeb: 4,
                  toastLength: Toast.LENGTH_LONG);
            }
          }
        } else {
          await directOrderRequest(item);
        }
      }
    } else {
      await directOrderRequest(item);
    }
  }

  directOrderRequest(ProductsDetailsData item) async {
    List<DirectOrderRequest> directOrderList = [];
    DirectOrderRequest directOrderRequest = DirectOrderRequest();
    directOrderRequest.websiteItemCode = item.websiteItemId;
    directOrderRequest.itemUom = item.stockUom;
    directOrderRequest.qty = count;
    if (item.productOptions != null && item.productOptions!.isNotEmpty) {
      directOrderRequest.productOptions = [];
      for (ProductOptions p in item.productOptions!) {
        directOrderRequest.productOptions!.add(RProductOptions(
            optionName: p.optionName,
            optionValue: p.answer,
            isPriceModifier: p.isPriceModifier));
      }
    } else {
      directOrderRequest.productOptions = [];
    }
    directOrderList.add(directOrderRequest);
    ApiResponse<DirectOrderResponse> resultOfConfirmDirectOrder =
        await confirmDirectOrder(
            context, directOrderRequest, item, directOrderList);
    print("resultOfConfirmDirectOrder.status");
    print(resultOfConfirmDirectOrder.status);
    print(resultOfConfirmDirectOrder.data!.salesOrderId);

    if (resultOfConfirmDirectOrder.status == Status.COMPLETED) {
      if (resultOfConfirmDirectOrder.data != null &&
          resultOfConfirmDirectOrder.data!.error == null) {
        try {
          if (context.read<AppProvider>().getEnablePrintAuto()) {
            if (!androidInfo.model.contains("TPS")) {
              await printOnBluetoothPrinter(
                  resultOfConfirmDirectOrder.data!,
                  context.read<AppProvider>().getEnableMerchantNamePrint()
                      ? context.read<AppProvider>().utilitiesModel
                      : null,
                  context);
            } else {
              await printOnTelpo(
                  resultOfConfirmDirectOrder.data!,
                  context.read<AppProvider>().getEnableMerchantNamePrint()
                      ? context.read<AppProvider>().utilitiesModel
                      : null,
                  context);
            }
          }
        } on Exception catch (e) {
          print(e);
        }
        var orderReceiptResult = await showDialog(
            context: context,
            builder: (BuildContext context) => PopScope(
                  onPopInvokedWithResult: (result, _) async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: StatefulBuilder(
                    builder: (context, setState) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      //this right here
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widgetSize.getWidth(10, context)),
                        child: Stack(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),
                                Row(
                                  children: [
                                    SafeOnTap(
                                        onSafeTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                            Assets.svgCancelDirectOrder)),
                                    const Spacer(),
                                    Text(
                                      'تفاصيل الطلب',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize:
                                            widgetSize.getHeight(20, context),
                                        color: const Color(0xff2e2e2e),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(25, context),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff6f6f6),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: const Color(0xffe8e8e8)),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(20, context),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: widgetSize.getWidth(
                                                10, context),
                                          ),
                                          Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: Strings.BASR_URl +
                                                    resultOfConfirmDirectOrder
                                                        .data!
                                                        .orderItems![0]
                                                        .itemImage!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: hexToColor(
                                                            resultOfConfirmDirectOrder
                                                                .data!
                                                                .orderItems![0]
                                                                .backgroundColor!),
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.contain),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorResources
                                                                  .studio)),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    15, context),
                                              ),
                                              Text(
                                                resultOfConfirmDirectOrder
                                                    .data!
                                                    .orderItems![0]
                                                    .websiteItemName!,
                                                style: const TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 16,
                                                  color: Color(0xff2e2e2e),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    25, context),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: widgetSize.getWidth(
                                                10, context),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'رقم الطلب',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 12,
                                                    color: Color(0xffa2a2a2),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.salesOrderId!,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 14,
                                                    color: Color(0xff6b6b6b),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      15, context),
                                                ),
                                                const Text(
                                                  'حالة الطلب',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 12,
                                                    color: Color(0xffa2a2a2),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.salesOrderStatus
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 14,
                                                    color: Color(0xff6b6b6b),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      15, context),
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.postingTime!
                                                      .split('.')[0]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(16, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.grandTotal!
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 22,
                                                    color: Color(0xffec7e7e),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.currency!
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 18,
                                                    color: Color(0xffec7e7e),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      15, context),
                                                ),
                                                const Text(
                                                  'الكمية',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 12,
                                                    color: Color(0xffa2a2a2),
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!
                                                      .orderItems![0]
                                                      .quantity!
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 14,
                                                    color: Color(0xff6b6b6b),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  resultOfConfirmDirectOrder
                                                      .data!.date!
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(14, context),
                                                    color:
                                                        const Color(0xff6b6b6b),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(15, context),
                                ),
                                ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: resultOfConfirmDirectOrder.data!
                                        .orderItems![0].digitalCardDetails!
                                        .map<Widget>((data) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'الرقم السري',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 14,
                                                color: Color(0xff979797),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.right,
                                              softWrap: false,
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  5, context),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Spacer(),
                                                Expanded(
                                                  flex: 6,
                                                  child: Center(
                                                    child: Text(
                                                      data.secretCode!,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: 23,
                                                        color:
                                                            Color(0xffec7e7e),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SafeOnTap(
                                                      onSafeTap: () async {
                                                        await Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    data.secretCode ??
                                                                        ''));
                                                        var snackBar =
                                                            const SnackBar(
                                                                content: Text(
                                                                    "تم النسخ"));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      },
                                                      child: SvgPicture.asset(
                                                          Assets.svgCopy)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  5, context),
                                            ),
                                            const Text(
                                              'رقم المرجع',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 13,
                                                color: Color(0xff979797),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.right,
                                              softWrap: false,
                                            ),
                                            Text(
                                              data.refNo!,
                                              style: const TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 16,
                                                color: Color(0xff2e2e2e),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                            SizedBox(
                                              height: widgetSize.getHeight(
                                                  5, context),
                                            ),
                                            const Text(
                                              'الرقم التسلسلي',
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 13,
                                                color: Color(0xff979797),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.right,
                                              softWrap: false,
                                            ),
                                            Text(
                                              data.serialNo!,
                                              style: const TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: 16,
                                                color: Color(0xff2e2e2e),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SafeOnTap(
                                        onSafeTap: () async {
                                          await shareOrder(
                                              resultOfConfirmDirectOrder.data!,
                                              context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff9f9f9),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xfff3f3f3)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              SvgPicture.asset(Assets.svgShare),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              const Text(
                                                'مشاركة',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 11,
                                                  color: Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Visibility(
                                      visible: Platform.isAndroid,
                                      child: Expanded(
                                        child: SafeOnTap(
                                          onSafeTap: () async {
                                            if (androidInfo.model
                                                .contains("TPS")) {
                                              await printOnTelpo(
                                                  resultOfConfirmDirectOrder
                                                      .data!,
                                                  context
                                                          .read<AppProvider>()
                                                          .getEnableMerchantNamePrint()
                                                      ? context
                                                          .read<AppProvider>()
                                                          .utilitiesModel
                                                      : null,
                                                  context);
                                            } else {
                                              if (context
                                                      .read<AppProvider>()
                                                      .getBluetoothDevice() ==
                                                  null) {
                                                await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: PrintScreen(
                                                        resultOfConfirmDirectOrder
                                                            .data!),
                                                  ),
                                                );
                                              } else {
                                                await printOnBluetoothPrinter(
                                                    resultOfConfirmDirectOrder
                                                        .data!,
                                                    context
                                                            .read<AppProvider>()
                                                            .getEnableMerchantNamePrint()
                                                        ? context
                                                            .read<AppProvider>()
                                                            .utilitiesModel
                                                        : null,
                                                    context);
                                              }
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff9f9f9),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xfff3f3f3)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      10, context),
                                                ),
                                                SvgPicture.asset(
                                                    Assets.svgPrinterIcon),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      10, context),
                                                ),
                                                const Text(
                                                  'طباعة البطاقة',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: 11,
                                                    color: Color(0xff6b6b6b),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      10, context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: widgetSize.getWidth(10, context),
                                    ),
                                    Expanded(
                                      child: SafeOnTap(
                                        onSafeTap: () {
                                          Navigator.pop(context, true);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SharedBottomNavigationBar(
                                                          widget:
                                                              MainScreen())),
                                              (route) => false);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff9f9f9),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xfff3f3f3)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              SvgPicture.asset(
                                                  Assets.svgHomeDialog),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                              const Text(
                                                'الرئيسية',
                                                style: TextStyle(
                                                  fontFamily: 'DIN Next LT W23',
                                                  fontSize: 11,
                                                  color: Color(0xff6b6b6b),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: false,
                                              ),
                                              SizedBox(
                                                height: widgetSize.getHeight(
                                                    10, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Visibility(
                                    visible: Provider.of<HomeProvider>(context,
                                            listen: true)
                                        .isLoading,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                ColorResources.studio),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
        if (orderReceiptResult != null && orderReceiptResult) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const SharedBottomNavigationBar(widget: MainScreen()),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: resultOfConfirmDirectOrder.data!.message!,
            timeInSecForIosWeb: 4,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: const BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeOnTap(
                    onSafeTap: () {
                      Navigator.pop(context);
                      context.read<HomeProvider>().productDetailsResponse =
                          null;
                    },
                    child: SvgPicture.asset(Assets.svgBack)),
                const Spacer(),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(20, context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffffffff),
                  ),
                  softWrap: false,
                ),
                if (context.read<AppProvider>().getUserInfo() != null &&
                    context.read<AppProvider>().getUserInfo()!.profileDetails !=
                        null)
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widgetSize.getWidth(10, context)),
                      child: SafeOnTap(
                        onSafeTap: () async {},
                        child: SizedBox(
                          width: widgetSize.getWidth(100, context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "JD ",
                                style: TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: 15,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: false,
                              ),
                              Text(
                                context.watch<AppProvider>().utilitiesModel !=
                                        null
                                    ? context
                                                .watch<AppProvider>()
                                                .utilitiesModel!
                                                .data !=
                                            null
                                        ? context
                                                    .watch<AppProvider>()
                                                    .utilitiesModel!
                                                    .data!
                                                    .walletBalance !=
                                                null
                                            ? context
                                                .watch<AppProvider>()
                                                .utilitiesModel!
                                                .data!
                                                .walletBalance!
                                            : ""
                                        : ""
                                    : "",
                                style: const TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: 15,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: false,
                              ),
                              SizedBox(width: widgetSize.getWidth(5, context)),
                              SvgPicture.asset(
                                Assets.svgWallet,
                                width: widgetSize.getWidth(20, context),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  List<TextEditingController> numberOptions = [];
  List<TextEditingController> multiLineAreaOptions = [];
  List<TextEditingController> textAreaOptions = [];

  confirmDirectOrder(
      BuildContext context,
      DirectOrderRequest directOrderRequest,
      ProductsDetailsData item,
      List<DirectOrderRequest> directOrderList) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              //this right here
              /// Dialog for ( تأكيد الشراء )
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widgetSize.getWidth(20, context)),
                child: Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: widgetSize.getHeight(20, context),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: SafeOnTap(
                                    onSafeTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: SvgPicture.asset(
                                        Assets.svgCancelDirectOrder)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'ملخص  الطلب',
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: widgetSize.getHeight(20, context),
                                    color: const Color(0xff2e2e2e),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: widgetSize.getHeight(25, context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.websiteItemName != null
                                  ? item.websiteItemName!
                                  : "",
                              style: TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: widgetSize.getHeight(20, context),
                                color: const Color(0xff2e2e2e),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: false,
                            ),
                            SizedBox(
                              height: widgetSize.getHeight(10, context),
                            ),
                            if (directOrderRequest.qty != null) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "الكمية : ",
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(16, context),
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    softWrap: false,
                                  ),
                                  Text(
                                    directOrderRequest.qty != null
                                        ? directOrderRequest.qty.toString()
                                        : "",
                                    style: TextStyle(
                                      fontFamily: 'DIN Next LT W23',
                                      fontSize:
                                          widgetSize.getHeight(16, context),
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    softWrap: false,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            if (item.itemPrice != null) ...[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  hideQuantity(item)
                                      ? getFinalPriceModifier(item)
                                      : getFinalPrice(item),
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: widgetSize.getHeight(22, context),
                                    color: const Color(0xffec7e7e),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            if (directOrderRequest.productOptions != null &&
                                directOrderRequest
                                    .productOptions!.isNotEmpty) ...[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: directOrderRequest.productOptions!
                                      .map<Widget>((e) {
                                    if (e.optionValue != null &&
                                        e.optionValue!.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.optionName!} : ",
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    16, context),
                                                color: const Color(0xff2e2e2e),
                                              ),
                                              softWrap: true,
                                            ),
                                            Text(
                                              e.optionValue!,
                                              style: TextStyle(
                                                fontFamily: 'DIN Next LT W23',
                                                fontSize: widgetSize.getHeight(
                                                    16, context),
                                                color: const Color(0xff2e2e2e),
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }).toList()),
                              SizedBox(
                                height: widgetSize.getHeight(20, context),
                              ),
                            ],
                            if (item.discountAmount != null &&
                                item.discountAmount != "0.0") ...[
                              Text(
                                item.discountAmount!,
                                style: const TextStyle(
                                  fontFamily: 'DIN Next LT W23',
                                  fontSize: 20,
                                  color: Color(0xffec7e7e),
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: false,
                              ),
                              SizedBox(
                                height: widgetSize.getHeight(10, context),
                              ),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfff6f6f6),
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xffe8e8e8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'الرصيد الحالي',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize:
                                            widgetSize.getHeight(16, context),
                                        color: const Color(0xff2e2e2e),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(
                                      width: widgetSize.getWidth(60, context),
                                    ),
                                    Text(
                                      context
                                          .read<AppProvider>()
                                          .utilitiesModel!
                                          .data!
                                          .walletBalance!,
                                      style: const TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: 16,
                                        color: Color(0xff2e2e2e),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: widgetSize.getHeight(30, context),
                            ),
                            Consumer<HomeProvider>(
                                builder: (context, state, child) {
                              return SafeOnTap(
                                onSafeTap: () async {
                                  if (!state.isLoading) {
                                    var res = await state
                                        .directOrder(directOrderList);
                                    print("after assign value to res");
                                    print("res.stats.toString()");
                                    print(res.message);
                                    if (res.status == Status.COMPLETED) {
                                      Navigator.pop(context, res);
                                      context
                                          .read<AppProvider>()
                                          .getUtilities();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ProductDetailsScreen(
                                                      item.websiteItemName!,
                                                      item.websiteItemId!)));
                                    } else {
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              ColorResources.nightRider,
                                          textColor: Colors.white,
                                          msg: res.message ==
                                                  "Error During Communication: Error while Communication with Server with StatusCode : EXPECTATION FAILED"
                                              ? "منته من المتجر"
                                              : "",
                                          timeInSecForIosWeb: 4,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          widgetSize.getHeight(30, context)),
                                  height: widgetSize.getHeight(50, context),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: state.isLoading
                                        ? Colors.grey
                                        : const Color(0xff2892d7),
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: state.isLoading
                                            ? Colors.grey
                                            : const Color(0xff2892d7)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x401d4c9b),
                                        offset: Offset(0, 5),
                                        blurRadius: 11,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'تأكيد الشراء',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize:
                                            widgetSize.getHeight(20, context),
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: widgetSize.getHeight(20, context),
                            )
                          ],
                        )
                      ],
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Visibility(
                            visible:
                                Provider.of<HomeProvider>(context, listen: true)
                                    .isLoading,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorResources.studio),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  hideQuantity(ProductsDetailsData item) {
    var tempList = item.productOptions!
        .where((element) =>
            element.optionType == "Number Input" &&
            element.isPriceModifier == 1)
        .toList();

    if (tempList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  getFinalPrice(ProductsDetailsData item) {
    double finalPrice = 0.0;
    finalPrice = (!isPressed)
        ? (double.parse(item.discountedPrice!)) *
            int.parse(item.minimumOrderQuantities!)
        : (double.parse(item.discountedPrice!)) * count;
    if (context.read<AppProvider>().utilitiesModel != null &&
        context.read<AppProvider>().utilitiesModel!.data != null &&
        context.read<AppProvider>().utilitiesModel!.data!.walletBalance !=
            null &&
        context
            .read<AppProvider>()
            .utilitiesModel!
            .data!
            .walletBalance!
            .isNotEmpty) {
      var walletBalance = double.parse(
          context.read<AppProvider>().utilitiesModel!.data!.walletBalance!);
      if (finalPrice > walletBalance) {
        moreThanAvailableWalletBalance = true;
      } else {
        moreThanAvailableWalletBalance = false;
      }
    }

    return finalPrice.toStringAsFixed(4);
  }

  getFinalPriceModifier(ProductsDetailsData item) {
    double finalPrice = (double.parse(item.discountedPrice!)) * count;

    var tempList = item.productOptions!
        .where((element) =>
            element.optionType == "Number Input" &&
            element.isPriceModifier == 1)
        .toList();
    if (tempList.isNotEmpty) {
      for (ProductOptions p in tempList) {
        if (p.answer != null && p.answer!.isNotEmpty) {
          finalPrice = (!isPressed && percent == 0.0)
              ? (double.parse(item.discountedPrice!)) *
                      int.parse(item.minimumOrderQuantities!) +
                  double.parse(p.answer!)
              : (!isPressed && percent != 0.0)
                  ? (double.parse(item.discountedPrice!)) *
                          int.parse(item.minimumOrderQuantities!) +
                      (double.parse(p.answer!) +
                          ((double.parse(p.answer!) * (p.percentage / 100))))
                  : (double.parse(item.discountedPrice!)) * count +
                      double.parse(p.answer!);
        }
      }
    }

    if (context.read<AppProvider>().utilitiesModel != null &&
        context.read<AppProvider>().utilitiesModel!.data != null &&
        context.read<AppProvider>().utilitiesModel!.data!.walletBalance !=
            null &&
        context
            .read<AppProvider>()
            .utilitiesModel!
            .data!
            .walletBalance!
            .isNotEmpty) {
      var walletBalance = double.parse(
          context.read<AppProvider>().utilitiesModel!.data!.walletBalance!);
      if (finalPrice > walletBalance) {
        moreThanAvailableWalletBalance = true;
      } else {
        moreThanAvailableWalletBalance = false;
      }
    }

    return finalPrice.toStringAsFixed(4);
  }

  void calculatePercentPrice(double additionalData, double percentage) {
    double amount = ((percentage / 100) * additionalData) + additionalData;
    setState(() {
      percent = percent + amount;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(initialIndex: selectedIndex, length: 2, vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var res = await context.read<HomeProvider>().getProductDetails(widget.id);
      if (res.data != null && res.data!.data != null) {
        var temp = res.data!.data![0];
        if (temp.productOptions != null && temp.productOptions!.isNotEmpty) {
          for (ProductOptions productOptions in temp.productOptions!) {
            multiLineAreaOptions.add(TextEditingController());
            textAreaOptions.add(TextEditingController());
            numberOptions.add(TextEditingController());
          }
        }
      }
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    context.read<HomeProvider>().productDetailsResponse = null;
    return true;
  }
}
