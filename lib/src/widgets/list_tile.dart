import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';

class AppListTile extends StatelessWidget {
  final String month;
  final String date;
  final String title;
  final String location;
  final bool acceptingOrder;
  final String marketId;

  AppListTile(
      {this.acceptingOrder = false,
      @required this.date,
      @required this.location,
      @required this.month,
      @required this.title,
      @required this.marketId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: AppColors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  month,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                Text(date, style: TextStyles.buttonTextLight),
              ],
            ),
          ),
          title: Text(
            title,
            style: TextStyles.subTitle,
          ),
          subtitle: Text(location),
          trailing: (acceptingOrder)
              ? Icon(
                  FontAwesomeIcons.shoppingBasket,
                  color: AppColors.darkBlue,
                )
              : Text(''),
          onTap: acceptingOrder
              ? () => Navigator.of(context).pushNamed('/customer/$marketId')
              : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseStyles.listFieldHorizontal,
          ),
          child: Divider(color: AppColors.lightGrey),
        ),
      ],
    );
  }
}
