import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../model/categories_model.dart';
import 'item_per_categories.dart';

class SubCategroiesScreen extends StatefulWidget {
  int currentIndex;
  String title;
  bool fromCategoriesScreen;

  SubCategroiesScreen(this.currentIndex, this.title, this.fromCategoriesScreen,
      {super.key});

  @override
  _SubCategroiesScreenState createState() => _SubCategroiesScreenState();
}

class _SubCategroiesScreenState extends State<SubCategroiesScreen> {
  CarouselSliderController carouselController = CarouselSliderController();
  List<SubCategories>? subCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.fromCategoriesScreen) {
              subCategories = context
                  .read<HomeProvider>()
                  .categoriesModelResponse
                  ?.data
                  ?.data?[widget.currentIndex]
                  .subCategories;
            }
            context.read<AppProvider>().getUtilities();
          },
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widgetSize.getWidth(16, context)),
              child: widget.fromCategoriesScreen
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: widgetSize.getHeight(30, context)),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subCategories!.length,
                        itemBuilder: (context, childIndex) => SafeOnTap(
                          onSafeTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SharedBottomNavigationBar(
                                  widget: ItemPerCategories(
                                      subCategories![childIndex].itemGroupId !=
                                              null
                                          ? subCategories![childIndex]
                                              .itemGroupId!
                                          : "",
                                      widget.title),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          shape: BoxShape.rectangle,
                                          color: hexToColor(
                                              subCategories![childIndex]
                                                  .backgroundColor!),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: Strings.BASR_URl +
                                              subCategories![childIndex].image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const AspectRatio(
                                            aspectRatio: 1,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          ColorResources
                                                              .studio)),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    child: Text(
                                      subCategories![childIndex].websiteTitle !=
                                              null
                                          ? subCategories![childIndex]
                                              .websiteTitle!
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            widgetSize.getHeight(14, context),
                                        color: const Color(0xff191919),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Consumer<HomeProvider>(
                      builder: (context, homeProvider, child) {
                      if (homeProvider.categoriesList!.isNotEmpty) {
                        var list = homeProvider.categoriesList!;
                        return CarouselSlider(
                          carouselController: carouselController,
                          items: list
                              .map<Widget>((item) => Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(19, context),
                                      ),
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SafeOnTap(
                                                onSafeTap: () {
                                                  carouselController
                                                      .previousPage();
                                                },
                                                child: SvgPicture.asset(
                                                    Assets.svgArrowLeft)),
                                            SizedBox(
                                              width: widgetSize.getWidth(
                                                  15, context),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: hexToColor(
                                                      item.backgroundColor!)),
                                              width: widgetSize.getWidth(
                                                  280, context),
                                              height: widgetSize.getHeight(
                                                  139, context),
                                              child: CachedNetworkImage(
                                                imageUrl: Strings.BASR_URl +
                                                    (item.categoryImage ?? ''),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.contain),
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
                                                        const Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: widgetSize.getWidth(
                                                  15, context),
                                            ),
                                            SafeOnTap(
                                                onSafeTap: () {
                                                  carouselController.nextPage();
                                                },
                                                child: SvgPicture.asset(
                                                    Assets.svgArrow)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            widgetSize.getHeight(34, context),
                                      ),
                                      GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.70,
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: item.subCategories!.length,
                                        itemBuilder: (context, childIndex) =>
                                            SafeOnTap(
                                          onSafeTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    SharedBottomNavigationBar(
                                                  widget: ItemPerCategories(
                                                      item
                                                          .subCategories![
                                                              childIndex]
                                                          .name!,
                                                      widget.title),
                                                ),
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          widgetSize.getHeight(
                                                              10, context),
                                                      horizontal:
                                                          widgetSize.getWidth(
                                                              12, context)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: Strings.BASR_URl +
                                                        item
                                                            .subCategories![
                                                                childIndex]
                                                            .image!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        AspectRatio(
                                                      aspectRatio: 1,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: hexToColor(item
                                                                .subCategories![
                                                                    childIndex]
                                                                .backgroundColor!)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 2),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          10)),
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .contain),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
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
                                                SizedBox(
                                                  height: widgetSize.getHeight(
                                                      5, context),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 1),
                                                    child: Text(
                                                      item
                                                          .subCategories![
                                                              childIndex]
                                                          .name!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: widgetSize
                                                            .getHeight(
                                                                14, context),
                                                        color: const Color(
                                                            0xff191919),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: false,
                            initialPage: widget.currentIndex,
                            height: MediaQuery.of(context).size.height,
                            enableInfiniteScroll: true,
                            pageSnapping: true,
                            autoPlayCurve: Curves.linear,
                            onPageChanged: (index, reason) {
                              setState(() {
                                widget.title = list[index].categoryName!;
                              });
                            },
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })),
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
                  widget.title,
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
    if (widget.fromCategoriesScreen) {
      subCategories = context
          .read<HomeProvider>()
          .categoriesModelResponse
          ?.data
          ?.data?[widget.currentIndex]
          .subCategories;
    }
  }
}
