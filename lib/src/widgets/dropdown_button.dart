import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/buttons.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';

class AppDropdownButton extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final String value;
  final Function(String) onchanged;

  AppDropdownButton(
      {@required this.items,
      @required this.hintText,
      this.cupertinoIcon,
      this.materialIcon,
      this.value,
      this.onchanged});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: BaseStyles.listPadding,
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.straw, width: BaseStyles.borderWidth),
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
          ),
          child: Row(
            children: [
              Container(
                width: 50.0,
                child: BaseStyles.iconPrefix(materialIcon),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    child: (value == null)
                        ? Text(hintText,
                            style: TextStyles.suggestion) // add product
                        : Text(value, style: TextStyles.body), //edit product
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return _selectIOS(context, items, value);
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: BaseStyles.listPadding,
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.straw, width: BaseStyles.borderWidth),
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
          ),
          child: Row(
            children: [
              Container(
                width: 50.0,
                child: BaseStyles.iconPrefix(materialIcon),
              ),
              Expanded(
                child: Center(
                  child: DropdownButton<String>(
                    items: buildMaterialItems(items),
                    value: value,
                    hint: Text(hintText, style: TextStyles.suggestion),
                    style: TextStyles.body,
                    underline: Container(),
                    iconEnabledColor: AppColors.straw,
                    onChanged: (value) => onchanged(value),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  List<DropdownMenuItem<String>> buildMaterialItems(List<String> items) {
    return items != null //checking
        ? items
            .map((item) => DropdownMenuItem<String>(
                  child: Text(
                    item,
                    textAlign: TextAlign.center,
                  ),
                  value: item,
                ))
            .toList()
        : []; //return empty List if items are null(not loaded).
  }

  List<Text> buildCupertinoItems(List<String> items) {
    return items
        .map((item) => Text(
              item,
              textAlign: TextAlign.center,
              style: TextStyles.iOSPicker,
            ))
        .toList();
  }

  Widget _selectIOS(BuildContext context, List<String> items, String value) {
    return GestureDetector(
      onTap: () {
        print('_selectIOS: tapped.');
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.white,
        height: 300.0,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
              initialItem: items.indexWhere((item) => item == value)),
          backgroundColor: Colors.white70,
          itemExtent: 45.0,
          children: buildCupertinoItems(items),
          diameterRatio: 1.0,
          onSelectedItemChanged: (int index) => onchanged(items[index]),
        ),
      ),
    );
  }
}
