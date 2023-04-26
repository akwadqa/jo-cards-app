import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/widget_size.dart';
import 'package:provider/provider.dart';



class Error extends StatelessWidget {
  final String ?errorMsg;


  Error({this.errorMsg});


  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
            onTap: ()async{

            },

            child:  RichText(
                text: TextSpan(
                  text: 'Error Was Occurred',
                  style: TextStyle(color: ColorResources.studio,fontSize: widgetSize.getHeight(16, context)),
                  children: <TextSpan>[
                    TextSpan(text: "", style: TextStyle(color:ColorResources.studio,)),

                  ],
                ))
        ));
  }
}