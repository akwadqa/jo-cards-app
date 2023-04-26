import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/subcategories_screen.dart';
import 'package:jocards/utill/strings.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Network/api_response.dart';
import '../../utill/color_resources.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../widget/safe_on_tap.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
        backgroundColor: ColorResources.whiteSmoke,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            context.read<HomeProvider>().getAllCategories();
          }),
          child: Consumer<HomeProvider>(builder: (context, homeProvider, child) {
            if (homeProvider.categoriesModelResponse != null) {
              switch (homeProvider.categoriesModelResponse!.status!) {
                case Status.LOADING:
                  return Align(
                    child: Loading(
                        loadingText: homeProvider.categoriesModelResponse!.message),
                  );

                case Status.COMPLETED:
                  var items =  homeProvider.categoriesModelResponse!.data!.data;
                  if(items!=null) {
                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context),
                      vertical: widgetSize.getHeight(30, context)),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        shrinkWrap: true,

                        itemCount:items.length,
                        itemBuilder: (context, childIndex) => SafeOnTap(
                          onSafeTap: (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                           child: SubCategroiesScreen(childIndex,items[childIndex].itemGroupId!=null?items[childIndex].itemGroupId.toString():"",true),

                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                    Expanded(
                                      child: Stack(
                                        children: [

                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                shape: BoxShape.rectangle,
                                                color: hexToColor(
                                                    items[childIndex].backgroundColor!),

                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl:items[childIndex].image!=null?Strings.BASR_URl +
                                                  items[childIndex].image!
                                              :"",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  shape: BoxShape.rectangle,

                                                  image: DecorationImage(
                                                      image: imageProvider, fit: BoxFit.contain),
                                                ),
                                              ),
                                              placeholder: (context, url) => AspectRatio(
                                                aspectRatio: 1,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                      new AlwaysStoppedAnimation<Color>(ColorResources.studio)),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Center(
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
                                    padding:  EdgeInsets.symmetric(horizontal: 1,vertical: 2),
                                    child: Text(
                                      items[childIndex].websiteTitle!=null? items[childIndex].websiteTitle!:"",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(

                                        fontSize: widgetSize.getHeight(14, context),
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
                    );
                  } else{
                    return Container();}

                case Status.ERROR:
                  return Error(errorMsg: homeProvider.categoriesModelResponse!.message);
              }
            }
            return Container();
          }),
        ));
  }
  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.only(
                top: widgetSize.getHeight(30, context),
                right: widgetSize.getWidth(16, context),
                left: widgetSize.getWidth(16, context)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Spacer(),
                Text(
                 "جميع الفئات",
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(18, context),
                    color: const Color(0xffffffff),
                  ),
                  softWrap: false,
                ),
                Spacer(),
           

              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      context.read<HomeProvider>().getAllCategories();
    });
  }

}
