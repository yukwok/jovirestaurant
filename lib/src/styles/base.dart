// import '../styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/styles/colors.dart';

abstract class BaseStyles {
  static List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: AppColors.darkGrey.withOpacity(.5),
        offset: Offset(1.0, 2.5),
        blurRadius: 2.0,
      )
    ];
  }

  static Widget iconPrefix(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(icon, size: 35.0, color: AppColors.lightBlue),
    );
  }

  static List<BoxShadow> get boxShadowPressed {
    return [
      BoxShadow(
        color: AppColors.darkGrey.withOpacity(.5),
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
      )
    ];
  }

  static double get animationOffset => 2.0;

  static double get borderRadius => 25.0;

  //static Radius get borderRadius => Radius.circular(10.0);

  static double get borderradius => 10.0;

  static double get borderWidth => 2.0;

  static double get listFieldHorizontal => 25.0;

  static double get listFieldVertical => 8.0;

  static double get buttonHeight => 60.0;

  static EdgeInsets get listFieldPadding => EdgeInsets.symmetric(
        horizontal: listFieldHorizontal,
        vertical: listFieldVertical,
      );

  static EdgeInsets get socialButtonPadding => EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      );

  static EdgeInsets get listPadding => EdgeInsets.symmetric(
        horizontal: listFieldHorizontal,
        vertical: listFieldVertical,
      );
}
