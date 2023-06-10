import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jocards/generated/assets.dart';
import 'package:jocards/model/app_message_model.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/main_screen/notification_details_screen.dart';
import 'package:jocards/screens/widget/loading.dart';
import 'package:jocards/screens/widget/safe_on_tap.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';
import '../widget/error.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String appMessageId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(widgetSize.getWidth(15, context)),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            appMessageId = "0";
            context.read<HomeProvider>().appMessageDataPagingController?.refresh();
            // context.read<AppProvider>().getUtilities();
          }),
          child: CustomScrollView(slivers: <Widget>[
            PagedSliverList<int, MessageData>(
              shrinkWrapFirstPageIndicators: false,
              pagingController: context.read<HomeProvider>().appMessageDataPagingController!,
              builderDelegate: PagedChildBuilderDelegate<MessageData>(
                  firstPageProgressIndicatorBuilder:(_)=>Loading(loadingText: ""),
                  newPageProgressIndicatorBuilder: (_)=>Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Loading(loadingText: ""),
                  ),
                  noMoreItemsIndicatorBuilder: (_)=> Container(),
                  noItemsFoundIndicatorBuilder: (_)=> SizedBox(child: Center(child:  Text(
                    'لايوجد إشعارات',
                    style: TextStyle(
                      fontFamily: 'DIN Next LT W23',
                      fontSize: widgetSize.getHeight(19, context),
                      color: const Color(0xff2e2e2e),

                    ),
                    softWrap: false,
                  ),),),
                  firstPageErrorIndicatorBuilder: (_)=> Error(errorMsg:Provider.of<HomeProvider>(context,listen: false).
                    appMessageDataPagingController!.error!.toString()),
                  itemBuilder: (context, item, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationDetailsScreen(messageData: item,)));
                        },
                        trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: (){},),
                        title:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                          child: Text(item.appMessageTitle!, style: const TextStyle(fontWeight: FontWeight.w500),),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(item.content!),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(item.publishedOn ?? "", style: const TextStyle(color: ColorResources.gray61),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ),

          ),],)
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
              color: ColorResources.studio,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
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
                Spacer(),
                Text(
                  "الإشعارات",
                  style: TextStyle(
                    fontSize: widgetSize.getHeight(16, context),
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
    initial();
  }

  initial(){
    context.read<HomeProvider>().appMessageDataPagingController =
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    context
        .read<HomeProvider>()
        .appMessageDataPagingController!
        .addPageRequestListener((pageKey) {
      context.read<HomeProvider>().getAppMessage(pageKey, appMessageId);
    });
  }

  @override
  void dispose() {
    context.read<HomeProvider>().appMessageDataPagingController!.dispose();
    super.dispose();
  }
}
