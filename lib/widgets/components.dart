import 'package:books/styles/size_config.dart';
import 'package:books/styles/colors.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required String? Function(String?)? validate,
  required String? label,
  required IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  min = 1,
  double prefixWidth = 0,
  double vPadding = 2,
  direction = TextDirection.ltr,
  inputAction = TextInputAction.done,
  boarderColor = dark,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      autocorrect: false,
      obscureText: isPassword,
      enabled: isClickable,
      textInputAction: inputAction,
      onFieldSubmitted: onSubmit as void Function(String)?,
      textDirection: direction,
      textAlign: TextAlign.left,
      onChanged: onChange as void Function(String)?,
      onTap: onTap as void Function()?,
      validator: validate,
      minLines: min,
      maxLines: isPassword ? 1 : 5,
      cursorColor: dark,
      cursorHeight: SizeConfig.getH(20),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
            color: dark.withOpacity(.5),
            fontSize: SizeConfig.getFontSize(14),
            height: SizeConfig.getH(.2)),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.getH(vPadding), horizontal: SizeConfig.getW(10)),
        // border: InputBorder.none,
        border: outlineInputBorder(boarderColor),
        enabledBorder: outlineInputBorder(boarderColor),
        focusedBorder: outlineInputBorder(boarderColor),
        disabledBorder: outlineInputBorder(boarderColor),
        prefixIcon: Icon(
          prefix,
          size: SizeConfig.getFontSize(20),
          color: dark.withOpacity(.5),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: prefixWidth),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed as void Function()?,
                icon: Icon(
                  suffix,
                  color: dark.withOpacity(.5),
                  size: SizeConfig.getFontSize(20),
                ),
              )
            : null,
        // border: OutlineInputBorder(),
      ),
    );

OutlineInputBorder outlineInputBorder(boarderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(SizeConfig.getR(4))),
    borderSide: BorderSide(color: boarderColor, width: 1.5),
  );
}

String emptyError = '';
