// import '../styles/base.dart';
// import '../styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';

class AppSocialButton extends StatelessWidget {
  final SocialType socialType;

  AppSocialButton({@required this.socialType});

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color iconColor;
    IconData icon;

    switch (socialType) {
      case SocialType.facebook:
        iconColor = AppColors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebookF;
        break;
      case SocialType.google:
        iconColor = AppColors.white;
        buttonColor = AppColors.google;
        icon = FontAwesomeIcons.google;

        break;

      default:
        iconColor = AppColors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebookF;
        break;
    }
    return Padding(
      padding: BaseStyles.socialButtonPadding,
      child: Container(
        height: BaseStyles.buttonHeight,
        width: BaseStyles.buttonHeight,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: BaseStyles.boxShadow,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}

enum SocialType { facebook, google }
