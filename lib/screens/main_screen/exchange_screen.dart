import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import '../../Network/api_response.dart';
import '../../generated/assets.dart';
import '../../model/agent_model.dart';
import '../../provider/app_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/validations.dart';
import '../../utill/widget_size.dart';
import '../widget/safe_on_tap.dart';
import '../widget/textformfield.dart';

class ExchangeScreen extends StatefulWidget {

  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  String transferAmount="";
  TextEditingController mobileController = TextEditingController();
  TextEditingController transferAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:buildAppBar(context) ,
      backgroundColor: ColorResources.whiteSmoke,
    body: Stack(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(15, context)),
          child: Padding(
            padding:  EdgeInsets.only(top: widgetSize.getHeight(15, context),),
            child: Container(
              decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: ListView(shrinkWrap: true,children: [

                Container(
                    height: widgetSize.getHeight(140, context), // Border width
                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(Assets.imgWalletHh, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.center,children: [
                            SizedBox(height:widgetSize.getHeight(20, context)),
                            Text(
                              'رصيد المحفظة',
                              style: TextStyle(
                                fontFamily: 'DIN Next LT W23',
                                fontSize: widgetSize.getHeight(18, context),
                                color: const Color(0xbdffffff),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: false,
                            ),
                            Row(children: [
                              SizedBox(width: widgetSize.getWidth(35, context),),
                              SvgPicture.asset(Assets.svgWallet,height: widgetSize.getWidth(45, context),width: widgetSize.getWidth(45, context),color: Colors.white,),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 2),
                                    child: Text(
                                      context.watch<AppProvider>().utilitiesModel!=null?
                                      context.watch<AppProvider>().utilitiesModel!.data!=null?
                                      context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!=null?
                                      context.watch<AppProvider>().utilitiesModel!.data!.walletBalance!:"":"":""
                                      ,
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: 44,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                ),
                              )
                            ],),
                            Spacer(),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10) )),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(children: [
                                    SizedBox(width: widgetSize.getWidth(23, context),),
                                    Text(
                                      'الرصيد المستحق',
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(15, context),
                                        color: const Color(0xffffffff),
                                      ),
                                      softWrap: false,
                                    ),
                                    Spacer(),
                                    Text(
                                      context.read<AppProvider>().utilitiesModel!=null?
                                      context.read<AppProvider>().utilitiesModel!.data!=null?
                                      context.read<AppProvider>().utilitiesModel!.data!.unpaidUnits!=null?
                                      context.read<AppProvider>().utilitiesModel!.data!.unpaidUnits!:"":"":"",
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(15, context),
                                        color: const Color(0xffffffff),
                                      ),
                                      softWrap: false,
                                    ),
                                    SizedBox(width: widgetSize.getWidth(23, context),),
                                  ],),
                                ),
                              ),
                            )
                          ],),
                        )
                      ],
                    )),
                SizedBox(height: widgetSize.getHeight(35, context),),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(15, context)),
                    child: Form(
                      key: _key,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Text(
                        'تحويل مبلغ لمستخدم آخر',
                        style: TextStyle(
                          fontFamily: 'DIN Next LT W23',
                          fontSize: 16,
                          color: const Color(0xff2e2e2e),
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                      ),
                          SizedBox(height: widgetSize.getHeight(15, context)),
                          SafeOnTap(onSafeTap: ()async {
                          await  showAgentCustomersName(context);
                          },child: mobileTextFormField()),
                          SizedBox(height: widgetSize.getHeight(15, context)),
                          transferAmountTextFormField(),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: widgetSize.getHeight(35, context),),

                SafeOnTap(onSafeTap: ()async {
                  FocusScope.of(context).unfocus();
                  if (_key.currentState!.validate()) {

                    _key.currentState!.save();
                    var dialogResult = await showDialog(context: context, builder: (context)=>
                        Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(20, context)),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),
                                Row(children: [

                                  SafeOnTap(
                                      onSafeTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(Assets.svgCancelDirectOrder)),


                                  Spacer(),
                                ],),

                                SizedBox(
                                  height: widgetSize.getHeight(10, context),
                                ),

                                Text(
                                "هل  انت متأكد من متابعة العملية ؟",
                                  style: TextStyle(
                                    fontFamily: 'DIN Next LT W23',
                                    fontSize: widgetSize.getHeight(19, context),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff2e2e2e),

                                  ),
                                  softWrap: false,
                                ),

                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),

                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [

                                  SafeOnTap(
                                    onSafeTap: (){
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text(
                                      "نعم",
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(16, context),
                                        color: const Color(0xff2e2e2e),

                                      ),
                                      softWrap: false,
                                    ),
                                  ),

                                  SizedBox(
                                    width: widgetSize.getWidth(90, context),
                                  ),

                                  SafeOnTap(
                                    onSafeTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "لا",
                                      style: TextStyle(
                                        fontFamily: 'DIN Next LT W23',
                                        fontSize: widgetSize.getHeight(16, context),
                                        color: const Color(0xff2e2e2e),

                                      ),
                                      softWrap: false,
                                    ),
                                  ),



                                ],),
                                SizedBox(
                                  height: widgetSize.getHeight(20, context),
                                ),











                              ],
                            ),
                          ),));
                    if(dialogResult!=null&&dialogResult){
                    if (!context.read<HomeProvider>().isLoading) {
                   var res =  await context.read<HomeProvider>().requestTransferShipping(transferAmount,customerName: mobileController.text);
                   if(res.status==Status.COMPLETED){
                     var result = await showDialog(
                         barrierDismissible: false,
                         context: context,
                         builder: (context) => Dialog(

                           shape: RoundedRectangleBorder(
                               borderRadius:
                               BorderRadius.circular(12.0)),
                           child: Padding(
                             padding: EdgeInsets.symmetric(
                                 horizontal: widgetSize.getWidth(
                                     20, context)),
                             child: ListView(
                               physics:
                               NeverScrollableScrollPhysics(),
                               shrinkWrap: true,
                               children: <Widget>[
                                 SizedBox(
                                   height: widgetSize.getHeight(
                                       20, context),
                                 ),
                                 Row(
                                   children: [
                                     SafeOnTap(
                                         onSafeTap: () {
                                           Navigator.pop(
                                               context,true);
                                         },
                                         child: SvgPicture.asset(
                                             Assets
                                                 .svgCancelDirectOrder)),
                                     Spacer(),
                                   ],
                                 ),
                                 SizedBox(
                                   height: widgetSize.getHeight(
                                       10, context),
                                 ),
                                 Text(
                                   res.data!.message!,maxLines: null,
                                   style: TextStyle(
                                     fontFamily:
                                     'DIN Next LT W23',
                                     fontSize: widgetSize
                                         .getHeight(19, context),
                                     fontWeight: FontWeight.w500,
                                     color:
                                     const Color(0xff2e2e2e),
                                   ),
                                   textAlign: TextAlign.center,
                                 ),
                                 SizedBox(
                                   height: widgetSize.getHeight(
                                       20, context),
                                 ),
                               ],
                             ),
                           ),
                         ));
                     if(result!=null&&result){
                       Navigator.pop(context);
                     }
                   }
                   else{
                     Fluttertoast.showToast(
                         backgroundColor: Colors.red,
                         textColor: Colors.white,
                         msg: res.message ?? "",
                         timeInSecForIosWeb: 4,
                         toastLength: Toast.LENGTH_LONG);
                   }
                    }}
                  }
                },
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(15, context)),
                    child: Container(
                      height: widgetSize.getHeight(50, context),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff2892d7),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 1.0, color: const Color(0xff2892d7)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x401d4c9b),
                            offset: Offset(0, 5),
                            blurRadius: 11,
                          ),
                        ],
                      ),
                      child: Center(child: Text(
                        'تحويل المبلغ',
                        style: TextStyle(
                          fontFamily: 'DIN Next LT W23',
                          fontSize: widgetSize.getHeight(16, context),
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: false,
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: widgetSize.getHeight(10, context),),

                SafeOnTap(onSafeTap: (){
                  Navigator.pop(context);
                },
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(15, context)),
                    child: Container(
                      height: widgetSize.getHeight(50, context),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 1.0, color: const Color(0xff1d4c9b)),

                      )
                      ,
                      child: Center(child:
                      Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: 'DIN Next LT W23',
                          fontSize: widgetSize.getHeight(16, context),
                          color: const Color(0xff1d4c9b),
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: false,
                      ),),
                    ),
                  ),
                )


              ],),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Visibility(
                visible: Provider.of<HomeProvider>(context, listen: true)
                    .isLoading,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        ColorResources.studio),
                  ),
                )),
          ),
        ),
      ],
    ),);
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

                SafeOnTap(onSafeTap: () { Navigator.pop(context); },
                    child: SvgPicture.asset(Assets.svgBack)),
                Spacer(),
                Text(
                 "محفظتي",
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


  Widget mobileTextFormField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SearchField<Data>(
        controller: mobileController,
        searchInputDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
                14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
                14.0),
            borderSide: const BorderSide(
                color: ColorResources.sliver),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
                14.0),
            borderSide: const BorderSide(
                color: ColorResources.sliver),
          ),
        ),
        hint: "هاتف المستخدم المرتبط به",
        suggestions: context.read<AppProvider>().agentModel!.data!
            .map(
              (e) => SearchFieldListItem<Data>(
            e.customerName!,
            item: e,
          ),
        )
            .toList(),
        validator: Validations().filedRequired,
      ),
    );
  }

  Widget transferAmountTextFormField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomTextField(
        maxLines: 1,
        borderRaduis: 10,
        keyboardType: TextInputType.phone,
        textEditingController: transferAmountController,
        hint: "المبلغ المراد تحويله",
        validate: Validations().filedRequired,
        onSaved: (String? value) {
          transferAmount=value!;
        },
      ),
    );
  }

  Future<void> showAgentCustomersName(BuildContext context) async {
    if( context.read<AppProvider>().agentModel!=null&&context.read<AppProvider>().agentModel!.data!=null&&context.read<AppProvider>().agentModel!.data!.isNotEmpty) {
      var res = await showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) =>
              SafeArea(

                child:   Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius
                              .circular(
                              50),
                          topLeft: const Radius
                              .circular(
                              50))),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: widgetSize.getWidth(16, context)),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                            height: widgetSize
                                .getHeight(
                                10,
                                context)),
                        // Adobe XD layer: 'Home Indicator' (shape)
                        Align(
                            alignment:
                            Alignment
                                .center,
                            child:
                            Container(
                              height: widgetSize
                                  .getHeight(
                                  5,
                                  context),
                              width: widgetSize.getWidth(
                                  134,
                                  context),
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(100.0),
                                color: const Color(
                                    0xffEEEEEE),

                              ),
                            )),
                        SizedBox(height: widgetSize.getHeight(30, context),),

                        Align(
                          alignment:
                          Alignment
                              .center,
                          child: Text(
                            'اسماء الزبائن ',
                            style: TextStyle(
                              fontFamily: 'DIN Next LT W23',
                              fontSize: widgetSize.getHeight(17, context),
                              color: const Color(0xff2e2e2e),
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: false,
                          ),
                        ),
                        SizedBox(height: widgetSize.getHeight(15, context),),

                        ListView.separated(

                          itemCount: context.read<AppProvider>().agentModel!.data!.length,
                          itemBuilder: (context,index){
                            return  SafeOnTap(
                              onSafeTap: () {
                                mobileController.text=context.read<AppProvider>().agentModel!.data![index].name!;
                                Navigator.pop(context);


                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context.read<AppProvider>().agentModel!.data![index].name!,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: widgetSize.getHeight(17, context),
                                    color: const Color(0xff707070),
                                  ),

                                ),
                              ),
                            );
                          },
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) => Divider(height: 1,color: Color(0xffC9C9C9),),



                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      );
    }


  }
  final picker = ImagePicker();

  Future<XFile?> getImagePicker(ImageSource source) async {
    File? image;
    final pickedFile =
    await picker.pickImage(source: source, maxHeight: 480, maxWidth: 640);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {}
    });

    return pickedFile;
  }

  String? imageB64;
  String? imageName;

  showImagePicker(context) async {
    var res = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text("صورة كاميرا "),
                      onTap: () async {
                        var value = await getImagePicker(ImageSource.camera);
                        if (value != null) {
                          List<int> imageBytes =
                          File(value.path).readAsBytesSync();
                          imageB64 = base64Encode(imageBytes);
                          imageName = "receipt."+value.path.split(".")[1];


                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text("صورة من الاستديو"),
                        onTap: () async {
                          var value = await getImagePicker(ImageSource.gallery);
                          if (value != null) {
                            List<int> imageBytes =
                            File(value.path).readAsBytesSync();
                            imageB64 = base64Encode(imageBytes);
                            imageName = "receipt."+value.path.split(".")[1];

                            Navigator.pop(context, true);
                            //    sendImageOrVideoMessage(context,Provider.of<ChatProvider>(context,listen:false),"Image",File(value.path));

                          }
                        }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return res;
  }
}
