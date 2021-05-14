// import '../styles/base.dart';
// import '../styles/colors.dart';
// import '../styles/text.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';

abstract class TextFieldStyles {
  static double get textFieldHorizontal => BaseStyles.listFieldHorizontal;

  static double get textFieldVertical => BaseStyles.listFieldVertical;

  static TextStyle get text => TextStyles.body;

  static double get textBoxHorizontal => BaseStyles.listFieldHorizontal;

  static double get textBoxVertical => BaseStyles.listFieldVertical;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static TextAlign get textAlign => TextAlign.center;

  static TextStyle get placeholder {
    return TextStyles.suggestion;
  }

  static Color get cursorColor {
    return AppColors.darkBlue;
  }

  static Widget prefixIcon(IconData icon) => Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Icon(
          icon,
          size: 30.0,
          color: AppColors.lightBlue,
        ),
      );

  static BoxDecoration get cupertinoDecoration => BoxDecoration(
        border: Border.all(
          color: AppColors.straw,
          width: BaseStyles.borderWidth,
        ),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
      );

  static BoxDecoration get cupertinoErrorDecoration => BoxDecoration(
        border: Border.all(
          color: AppColors.red,
          width: BaseStyles.borderWidth,
        ),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
      );

  static InputDecoration materialDecoration(
      String hintText, IconData icon, String errorText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      errorText: errorText,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.straw, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.straw, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.straw, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.red, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      prefixIcon: prefixIcon(icon),
    );
  }
}
