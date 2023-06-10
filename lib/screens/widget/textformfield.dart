import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jocards/utill/color_resources.dart';
import 'package:jocards/utill/utitlities.dart';


class CustomTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData? icon;
  final double? borderRaduis;
  final int? maxLines;
  final TextStyle? hintStyle;
  String? Function(String?)? validate;
  void Function(String?)? onSaved;
  void Function(String?)? onChanged;
  List<TextInputFormatter>? inputFormatters;

  bool? enablePrefix;
  bool? enabled;

  Widget? eye;

  CustomTextField({
    this.onChanged,
    this.enabled,
    Key? key,this.inputFormatters,
    this.enablePrefix,
    this.hint,
    this.maxLines,
    this.borderRaduis,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.validate,
    this.onSaved,
    this.eye,
    this.hintStyle,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: widget.borderRaduis != null
              ? BorderRadius.circular(widget.borderRaduis!)
              : BorderRadius.circular(0),
          border: Border.all(color: ColorResources.sliver)),
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 4),
        child: TextFormField(
          enabled: widget.enabled!=null?false:true,
          maxLines: widget.maxLines,
          style: const TextStyle(color: Colors.black),
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          cursorColor: ColorResources.sliver,
          obscureText: widget.obscureText!,
          validator: widget.validate,
          onSaved: widget.onSaved,
            inputFormatters: widget.inputFormatters!=null?widget.inputFormatters!:null,
          onChanged:widget.onChanged!=null?widget.onChanged!: (value) {
              value = changeDigit(value, NumStrLanguage.English);

              widget.textEditingController!.text = value;
              widget.textEditingController!.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: widget.textEditingController!.text.length));

          },

          decoration: InputDecoration(contentPadding: widget.enablePrefix!=null?const EdgeInsets.symmetric(vertical: 8): const EdgeInsets.symmetric(horizontal: 4) ,
            hintText: widget.hint,
            errorMaxLines: 1,
            prefixIcon: widget.enablePrefix!=null? const Padding(padding: EdgeInsets.symmetric(vertical:16,horizontal: 8), child: Directionality(textDirection: TextDirection.ltr,child: Text('+974',style: TextStyle(color: ColorResources.light_grey),))):null,
            hintStyle: widget.hintStyle ?? const TextStyle(color: ColorResources.sliver),


              errorStyle: const TextStyle(
          fontSize:12, color:  ColorResources.studio),

          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                color:  Colors.transparent),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide:
            BorderSide( color:Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                color:  Colors.transparent),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
                color:  Colors.transparent),

          ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color:  Colors.transparent),

            ),
          ),
        ),
      ),
    );
  }
}
