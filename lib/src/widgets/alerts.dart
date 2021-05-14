import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/styles/text.dart';

abstract class AppAlerts {
  static Future<void> showErrorDialog(
      bool isIOS, BuildContext context, String errorMessage) {
    print('in app alert');
    return isIOS
        ? showCupertinoDialog(
            context: context,
            // barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'error',
                  style: TextStyles.subTitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.subTitle),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () {
                      return Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'error',
                  style: TextStyles.subTitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.subTitle),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () {
                      return Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
  }
}
