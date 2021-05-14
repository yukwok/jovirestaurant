// import '../styles/base.dart';
// import '../styles/colors.dart';
// import '../styles/text.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({@required this.buttonText, this.buttonType, this.onPressed});

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.Straw:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.straw;
        break;
      case ButtonType.LightBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightBlue;
        break;
      case ButtonType.DarkBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkBlue;
        break;
      case ButtonType.LightGray:
        fontStyle = TextStyles.buttonTextDark;
        buttonColor = AppColors.lightGrey;
        break;
      case ButtonType.DarkGray:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkGrey;
        break;
      case ButtonType.Disabled:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightGrey;
        break;
      default:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightBlue;
        break;
    }
    return AnimatedContainer(
      padding: EdgeInsets.only(
          top: (pressed)
              ? BaseStyles.listFieldVertical + BaseStyles.animationOffset
              : BaseStyles.listFieldVertical,
          bottom: (pressed)
              ? BaseStyles.listFieldVertical - BaseStyles.animationOffset
              : BaseStyles.listFieldVertical,
          left: BaseStyles.listFieldHorizontal,
          right: BaseStyles.listFieldHorizontal),
      child: GestureDetector(
        child: Container(
          height: BaseStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
              boxShadow:
                  pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow),
          child: Center(
              child: Text(
            widget.buttonText,
            style: fontStyle,
          )),
        ),
        onTapDown: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTapUp: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTap: () {
          if (widget.buttonType != ButtonType.Disabled) {
            widget.onPressed();
          }
        },
      ),
      duration: Duration(milliseconds: 20),
    );
  }
}

enum ButtonType { LightBlue, Straw, LightGray, DarkGray, DarkBlue, Disabled }
