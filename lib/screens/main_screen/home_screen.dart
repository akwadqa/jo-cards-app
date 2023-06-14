
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jocards/Network/api_response.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/home_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/notification_screen.dart';
import 'package:jocards/screens/main_screen/product_details.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/main_screen/subcategories_screen.dart';
import 'package:jocards/screens/main_screen/widgets/quick_buy_feature/quick_buy_widget.dart';
import 'package:jocards/screens/widget/loading.dart';
import 'package:jocards/screens/widget/error.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'item_per_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<int, int>> currentIndexCarousal = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widgetSize.getWidth(16, context)),
          child:
              Consumer<HomeProvider>(builder: (context, homeProvider, child) {
            if (homeProvider.homsResponse != null) {
              switch (homeProvider.homsResponse!.status!) {
                case Status.LOADING:
                  return Loading(
                      loadingText: homeProvider.homsResponse!.message);

                case Status.COMPLETED:
                  List<HomeBlock> homeList =
                      homeProvider.homsResponse!.data!.homeBlock!;
                  print(homeList);
                  return RefreshIndicator(
                    onRefresh: () => Future.sync(() {
                      homeProvider.getHomePage();
                      context.read<AppProvider>().getUtilities();
                    }),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: homeList.length,
                        itemBuilder: (context, index) {
                          switch (homeList[index].type) {
                            case "Banner":
                              List<HomeBlockData>? bannerList =
                                  homeList[index].data!;
                              currentIndexCarousal[index].putIfAbsent(
                                index,
                                () => 0,
                              );
                              return buildBanner(
                                  context, homeList, index, bannerList);
                            case "Categories":
                              List<HomeBlockData>? categories =
                                  homeList[index].data!;

                              return buildCategory(
                                  homeList, index, context, categories);
                            // case "Wallet":
                            //   return buildWallet();
                            default:
                              return Container();
                          }
                        }),
                  );

                case Status.ERROR:
                  return Error(errorMsg: homeProvider.homsResponse!.message);
              }
            }
            return Container();
          }),
        ),
      ),
    );
  }

  ExpansionTile buildCategory(List<HomeBlock> homeList, int index,
      BuildContext context, List<HomeBlockData> categories) {
    return ExpansionTile(
      initiallyExpanded:homeList[index].expanded! ,
      onExpansionChanged: (changed) {
        setState(() {
          homeList[index].expanded = changed;
        });
      },
      tilePadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            child: Text(
              homeList[index].title!,

              style: TextStyle(
                fontFamily: 'DIN Next LT W23',
                fontSize: widgetSize.getHeight(22, context),
                color: const Color(0xff2e2e2e),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

        ],
      ),
      trailing: homeList[index].expanded!
          ? SvgPicture.asset(Assets.svgCollapseArrow)
          : SvgPicture.asset(Assets.svgExpandArrow),
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.8,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, childIndex) => SafeOnTap(
            onSafeTap: () {
              var list = context.read<HomeProvider>().categoriesList;
              if(list!=null) {
                Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: SharedBottomNavigationBar(widget: SubCategroiesScreen(list.indexOf(categories[childIndex]),categories[childIndex].categoryName!,false)),
                ),
              );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widgetSize.getHeight(10, context),
                        horizontal: widgetSize.getWidth(12, context)),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.12,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              shape: BoxShape.rectangle,
                              color: hexToColor(
                                  categories[childIndex].backgroundColor!),

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: Strings.BASR_URl +
                                (categories[childIndex].categoryImage ?? ""),
                            imageBuilder: (context, imageProvider) => AspectRatio(
                              aspectRatio: 1.12,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,

                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.contain),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const AspectRatio(
                              aspectRatio: 1.2,
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorResources.studio)),
                              ),
                            ),
                            errorWidget: (context, url, error) => const AspectRatio(
                              aspectRatio: 1.2,
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: widgetSize.getHeight(5, context),
                  ),
                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      categories[childIndex].categoryName!,
                      maxLines: 1,
                      overflow:TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: widgetSize.getHeight(14, context),
                        color: const Color(0xff191919),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widgetSize.getHeight(6, context),
                  ),
                  InkWell(
                    onTap: () async {
                      context.read<HomeProvider>().itemCategoryResponse = null;
                      context.read<HomeProvider>().productDetailsResponse = null;
                      showBarModalBottomSheet(
                          context: context,
                          expand: false,
                          builder: (context){
                            return QuickBuyWidget(homeBlockData: categories[childIndex]);
                          }
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widgetSize.getWidth(12, context)),
                      child: Image.asset(
                        Assets.imgQuickBuy,
                        height: widgetSize.getHeight(20, context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Padding buildWallet(){
  //   return Padding(
  //     padding: EdgeInsets.only(top: widgetSize.getHeight(12, context)),
  //     child: const MyWallet(),
  //   );
  // }

  Padding buildBanner(BuildContext context, List<HomeBlock> homeList, int index,
      List<HomeBlockData> bannerList) {
    return Padding(
      padding: EdgeInsets.only(top: widgetSize.getHeight(12, context)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: hexToColor(homeList[index].background!),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: CarouselSlider(
              items: bannerList
                  .map<Widget>((item) => SafeOnTap(onSafeTap: (){
                    if(item.bannerType!=null) {
                      if (item.bannerType == "Website Item") {
                        if(item.bannerLink!=null) {
                          Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: ProductDetailsScreen(item.bannerView,item.bannerLink!),
                          ),
                        );
                        }
                      }
                      if (item.bannerType == "Item Group") {
                        if(item.bannerLink!=null) {
                          Navigator.push(
                              context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ItemPerCategories(
                                item.bannerLink!,
                                item.bannerView),
                          ));
                        }
                      }

                    }

              },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                                imageUrl: Strings.BASR_URl +item.bannerImage!,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(ColorResources.studio)),
                                ),
                                errorWidget: (context, url, error) => const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                          Image.asset(Assets.imgOverlay,height: widgetSize.getHeight(141, context),)
                        ],
                      ),
                    ),
                  ))
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                height: widgetSize.getHeight(141, context),
                enableInfiniteScroll: true,
                pageSnapping: true,
                autoPlayCurve: Curves.linear,
                onPageChanged: (indexx, reason) {
                  setState(() {
                    currentIndexCarousal[index].update(
                      index,
                      (existingValue) => indexx,
                    );
                  });
                },
                viewportFraction: 1,
                enlargeCenterPage: false,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerList.asMap().entries.map((entry) {
                    if (currentIndexCarousal[index][index] != entry.key) {
                      return Container(
                            width: 10.0,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2.0, color: Colors.white),
                                color: Colors.transparent),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent),
                            ),
                          );
                    } else {
                      return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            width: widgetSize.getWidth(25, context),
                            height: widgetSize.getWidth(7, context),
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

   buildAppBar(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: Container(
                //     height: widgetSize.getHeight(50, context),
                //     decoration: BoxDecoration(
                //       color: const Color(0xffffffff),
                //       borderRadius: BorderRadius.circular(10.0),
                //       border: Border.all(
                //           width: 1.0, color: const Color(0x00ebebeb)),
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: widgetSize.getWidth(20, context)),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             'البحث في البطاقات',
                //             style: TextStyle(
                //               fontFamily: 'DIN Next LT W23',
                //               fontSize: widgetSize.getHeight(14, context),
                //               color: const Color(0xff848484),
                //             ),
                //             softWrap: false,
                //           ),
                //           const Spacer(),
                //           Image.asset(
                //             Assets.imgSearch,
                //             height: widgetSize.getHeight(24, context),
                //             width: widgetSize.getWidth(24, context),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                if(context.read<AppProvider>().getUserInfo()!=null && context.read<AppProvider>().getUserInfo()!.profileDetails!=null) Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                      horizontal: widgetSize.getWidth(10, context)),
                      child: SafeOnTap( onSafeTap: ()async {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: const SharedBottomNavigationBar(widget: NotificationScreen(),)));
                        },
                        child:  Icon(Icons.notifications_active_outlined, color: Colors.white, size: widgetSize.getHeight(28, context),)),),
                ),
                if(context.read<AppProvider>().getUserInfo()!=null && context.read<AppProvider>().getUserInfo()!.profileDetails!=null) Expanded(child: SizedBox(width: widgetSize.getWidth(5, context),)),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    Assets.imgHomeLogo,
                    height: widgetSize.getHeight(50, context),
                    width: widgetSize.getWidth(60, context),
                  ),
                ),
                if(context.read<AppProvider>().getUserInfo()!=null && context.read<AppProvider>().getUserInfo()!.profileDetails!=null) Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: widgetSize.getWidth(10, context)),
                    child: SafeOnTap( onSafeTap: ()async {},
                        child: SizedBox(
                          width: widgetSize.getWidth(100, context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            const Text("JD ", style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: 16,
                              color:  Color(0xffffffff),
                              fontWeight: FontWeight.w400,
                            ), softWrap: false,),
                            Text(
                             context.watch<AppProvider>().utilitiesModel!=null?
                              context.watch<AppProvider>().utilitiesModel!.data!=null?
                              context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!=null?
                              context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!:"":"":"",
                              style: const TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: 16,
                                color:  Color(0xffffffff),
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: false,
                            ),
                            SizedBox(width: widgetSize.getWidth(5, context)),
                            SvgPicture.asset(Assets.svgWallet,width: widgetSize.getWidth(20, context),color: Colors.white,),
                          ],),
                        ),),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void deactivate() {
    super.deactivate();


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentIndexCarousal=[];
    SchedulerBinding.instance.addPostFrameCallback((_) async {
     var res = await  context.read<HomeProvider>().getHomePage();

     for( HomeBlock homeBlock in  res.data!.homeBlock! ){

         currentIndexCarousal.add({});

     }

    });
  }
}
