import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';

class AppCard extends StatelessWidget {
  final String productName;
  final String unitType;
  final double unitPrice;
  final int availableUnits;
  final String imageUrl;
  final String note;

  AppCard({
    @required this.availableUnits,
    this.imageUrl = "",
    this.note = "",
    @required this.productName,
    @required this.unitPrice,
    @required this.unitType,
  });

  final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_zh');

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: BaseStyles.listPadding,
        padding: BaseStyles.listPadding,
        decoration: BoxDecoration(
            boxShadow: BaseStyles.boxShadow,
            color: Colors.white,
            border: Border.all(
              color: AppColors.darkBlue,
              width: BaseStyles.borderWidth,
            )),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (imageUrl != null && imageUrl != "")
                      ? Image.network(imageUrl, height: 100.0)
                      : Image.asset('assets/images/salad.png', height: 100.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName),
                    Text('${formatCurrency.format(unitPrice)}/$unitType'),
                    (availableUnits > 0)
                        ? Text('In stock')
                        : Text('Currently unavailable')
                  ],
                )
              ],
            ),
            Text(note),
          ],
        ));
  }
}
