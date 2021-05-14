// import '../styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jovirestaurant/src/styles/colors.dart';

abstract class TextStyles {
  static TextStyle get navTitle {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold));
  }

  static TextStyle get title {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
      color: AppColors.darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 40.0,
    ));
  }

  static TextStyle get subTitle {
    return GoogleFonts.economica(
        textStyle: TextStyle(
      color: AppColors.straw,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    ));
  }

  static TextStyle get listTitle {
    return GoogleFonts.economica(
        textStyle: TextStyle(
      color: AppColors.straw,
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
    ));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  static TextStyle get body => GoogleFonts.roboto(
        fontSize: 20.0,
        color: AppColors.darkGrey,
      );

  static TextStyle get iOSPicker => GoogleFonts.roboto(
        fontSize: 30.0,
        color: AppColors.darkGrey,
      );

  static TextStyle get link => GoogleFonts.roboto(
        fontSize: 20.0,
        color: AppColors.straw,
      );

  static TextStyle get suggestion => GoogleFonts.roboto(
        fontSize: 14.0,
        color: AppColors.lightGrey,
      );

  static TextStyle get buttonTextLight => GoogleFonts.roboto(
        fontSize: 17.0,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get buttonTextDark => GoogleFonts.roboto(
        fontSize: 17.0,
        color: AppColors.darkGrey,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get error => GoogleFonts.roboto(
        fontSize: 17.0,
        color: AppColors.red,
        fontWeight: FontWeight.normal,
      );
}
