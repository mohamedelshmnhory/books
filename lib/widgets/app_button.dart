import 'package:books/styles/size_config.dart';
import 'package:books/styles/colors.dart';
import 'package:flutter/material.dart';


class AppButton extends StatelessWidget {
  final double height;
  final double width;
  final Color background;
  final Color textColor;
  final bool isUpperCase;
  final double radius;
  final double textSize;
  final Function function;
  final String? text;
  final bool border;
  final IconData? icon;
  const AppButton({
    Key? key,
    required this.function,
    this.text,
    this.height = 50,
    this.width = double.infinity,
    this.background = mainColor,
    this.textColor = Colors.white,
    this.isUpperCase = false,
    this.radius = 5.0,
    this.textSize = 18,
    this.border = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: SizeConfig.getW(width),
          height: SizeConfig.getH(height),
          child: MaterialButton(
            onPressed: function as void Function()?,
            child: Text(
              isUpperCase ? text!.toUpperCase() : text!,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.getFontSize(textSize)),
            ),
            splashColor: Colors.transparent,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.getR(radius)),
            border: border ? Border.all(color: dark.withOpacity(.5)) : null,
            color: background,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     spreadRadius: 5,
            //     blurRadius: 7,
            //     offset: Offset(0, 3), // changes position of shadow
            //   ),
            // ],
          ),
        ),
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.getW(15)),
            child: Icon(icon, color: Colors.white),
          ),
      ],
    );
  }
}
