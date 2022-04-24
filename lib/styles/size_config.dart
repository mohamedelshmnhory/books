import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static Size? size;
  static double? screenWidth;
  static double? screenHeight;

  void init(BuildContext context) {
    if (_mediaQueryData == null) {
      _mediaQueryData = MediaQuery.of(context);
      size = _mediaQueryData!.size;
      screenWidth = _mediaQueryData!.size.width;
      screenHeight = _mediaQueryData!.size.height;
    }
  }

  static double getH(double height) => height.h;
  static double getW(double width) => width.w;
  static double getFontSize(double size) => size.sp;
  static double getR(double radius) => radius.r;
}

sizedBoxH(double h) => SizedBox(height: SizeConfig.getH(h));
sizedBoxW(double w) => SizedBox(width: SizeConfig.getW(w));