import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/product_details.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../model/item_category_model.dart';
import '../widget/loading.dart';
import '../widget/error.dart';

class ItemPerCategories extends StatefulWidget {
  final String parentName;
  final String catName;

  const ItemPerCategories(this.catName, this.parentName, {super.key});

  @override
  _ItemPerCategoriesState createState() => _ItemPerCategoriesState();
}

class _ItemPerCategoriesState extends State<ItemPerCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.whiteSmoke,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeProvider>().getItemPerCat(widget.catName);
            context.read<AppProvider>().getUtilities();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widgetSize.getWidth(16, context),
                vertical: widgetSize.getHeight(30, context)),
            child: ListView(
              children: [
                ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: widgetSize.getWidth(8, context)),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'DIN Next LT W23',
                            fontSize: widgetSize.getHeight(18, context),
                            color: const Color(0xff2e2e2e),
                          ),
                          children: [
                            TextSpan(
                              text: widget.parentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: "/",
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: widget.catName,
                              style: const TextStyle(
                                color: Color(0xff6b6b6b),
                              ),
                            ),
                          ],
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        softWrap: false,
                      ),
                    ),
                  )
                ],
                SizedBox(
                  height: widgetSize.getHeight(18, context),
                ),
                Align(child: Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) {
                  if (homeProvider.itemCategoryResponse != null) {
                    switch (homeProvider.itemCategoryResponse!.status!) {
                      case Status.LOADING:
                        return Loading(
                            loadingText:
                                homeProvider.itemCategoryResponse!.message);

                      case Status.COMPLETED:
                        List<Data>? items =
                            homeProvider.itemCategoryResponse?.data?.data;
                        if (items != null) {
                          return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.52,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, childIndex) {
                                return SafeOnTap(
                                  onSafeTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: SharedBottomNavigationBar(
                                            widget: ProductDetailsScreen(
                                                items[childIndex].productTitle!,
                                                items[childIndex]
                                                    .websiteItemId!)),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widgetSize
                                                      .getHeight(10, context),
                                                  horizontal: widgetSize
                                                      .getWidth(14, context)),
                                              child: CachedNetworkImage(
                                                imageUrl: Strings.BASR_URl +
                                                    items[childIndex]
                                                        .websiteImage!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      shape: BoxShape.rectangle,
                                                      color: hexToColor(items[
                                                              childIndex]
                                                          .backgroundColor!),
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const AspectRatio(
                                                  aspectRatio: 1.2,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                ColorResources
                                                                    .studio)),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            if (items[childIndex]
                                                        .discountPercent !=
                                                    null &&
                                                items[childIndex]
                                                    .discountPercent!
                                                    .isNotEmpty &&
                                                items[childIndex]
                                                        .discountPercent !=
                                                    "0.0%") ...[
                                              Positioned(
                                                top: 4,
                                                left: 4,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffe46060),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11.0),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                    child: Text(
                                                      items[childIndex]
                                                          .discountPercent!
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'DIN Next LT W23',
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                12, context),
                                                        color: const Color(
                                                            0xffffffff),
                                                      ),
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              widgetSize.getHeight(5, context),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            child: Text(
                                              items[childIndex].productTitle!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: widgetSize.getHeight(
                                                    14, context),
                                                color: const Color(0xff191919),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              widgetSize.getHeight(5, context),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  items[childIndex]
                                                      .itemPrice
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(18, context),
                                                    color: ColorResources.green,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                                SizedBox(
                                                  width: widgetSize.getWidth(
                                                      5, context),
                                                ),
                                                Text(
                                                  items[childIndex]
                                                      .currency
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'DIN Next LT W23',
                                                    fontSize: widgetSize
                                                        .getHeight(14, context),
                                                    color: ColorResources.green,
                                                  ),
                                                  softWrap: false,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              widgetSize.getHeight(5, context),
                                        ),
                                        if (items[childIndex].inStock != null &&
                                            items[childIndex].inStock == 1) ...[
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: widgetSize.getWidth(
                                                      5, context)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                      Assets.svgCheckCircle,
                                                      height:
                                                          widgetSize.getHeight(
                                                              14, context),
                                                      width:
                                                          widgetSize.getWidth(
                                                              14, context)),
                                                  SizedBox(
                                                    width: widgetSize.getWidth(
                                                        5, context),
                                                  ),
                                                  Text(
                                                    'متوفر',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              15, context),
                                                      color: const Color(
                                                          0xff2892d7),
                                                    ),
                                                    softWrap: false,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        if (items[childIndex].inStock != null &&
                                            items[childIndex].inStock == 0) ...[
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: widgetSize.getWidth(
                                                      5, context)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    Assets.svgControlclose,
                                                    height: widgetSize
                                                        .getHeight(14, context),
                                                    width: widgetSize.getWidth(
                                                        14, context),
                                                  ),
                                                  SizedBox(
                                                    width: widgetSize.getWidth(
                                                        5, context),
                                                  ),
                                                  Text(
                                                    'غير متوفر',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'DIN Next LT W23',
                                                      fontSize:
                                                          widgetSize.getHeight(
                                                              14, context),
                                                      color: const Color(
                                                          0xffff6060),
                                                    ),
                                                    softWrap: false,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Container();
                        }

                      case Status.ERROR:
                        return Error(
                            errorMsg: homeProvider.homsResponse!.message);
                    }
                  }
                  return Container();
                })),
              ],
            ),
          ),
        ));
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
                    },
                    child: SvgPicture.asset(Assets.svgBack)),
                const Spacer(),
                Text(
                  widget.catName,
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(18, context),
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

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeProvider>().getItemPerCat(widget.catName);
    });
  }
}
