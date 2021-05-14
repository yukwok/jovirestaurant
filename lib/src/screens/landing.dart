// import '../widgets/button.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/blocs/customer_bloc.dart';
import 'package:jovirestaurant/src/models/market.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';
import 'dart:io';

import 'package:jovirestaurant/src/widgets/list_tile.dart';
import 'package:jovirestaurant/src/widgets/sliver_scaffold.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var customerBloc = Provider.of<CustomerBloc>(context);
    if (Platform.isIOS) {
      return
          // Container(   //testing page
          //   decoration: BoxDecoration(color: AppColors.facebook),
          //   child: Center(
          //       child: Text(
          //     'landing page, ios',
          //     style: TextStyles.title,
          //   )),
          // );

          AppSliverScaffold.cupertinoSliverScaffold(
        //cupertinoSliverScaffold
        navTitle: 'Upcoming Markets',
        pageBody: Scaffold(body: pageBody(context, customerBloc)),

        // pageBody: pageBody(context),
        context: context,
      );
    } else {
      return AppSliverScaffold.materialSliverScaffold(
        navTitle: 'Upcoming Markets',
        pageBody: pageBody(context, customerBloc),
        context: context,
      );
    }
  }

  Widget pageBody(BuildContext context, CustomerBloc customerBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Stack(
            children: [
              Positioned(
                child: Image.asset('assets/images/chinesefood.jpg'),
                top: -10.0,
              ),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius:
                            BorderRadius.circular(BaseStyles.borderRadius)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('VendorPage', style: TextStyles.buttonTextLight),
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/vendor'),
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: StreamBuilder<List<Market>>(
              stream: customerBloc.fetchUpcomingMarkets,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  );

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var market = snapshot.data[index];
                    var dateEnd = DateTime.parse(market.dateEnd);
                    return AppListTile(
                      marketId: market.marketId,
                      date: formatDate(dateEnd, [d]),
                      month: formatDate(dateEnd, [M]),
                      location: market.location.address +
                          ' ' +
                          market.location.city +
                          ' ' +
                          market.location.state,
                      title: market.title,
                      acceptingOrder: market.acceptingOrders,
                    );
                  },
                );
              }),
        ),

        // AppButton(
        //   buttonText: 'Vendor 1',
        //   buttonType: ButtonType.Straw,
        //   onPressed: () => Navigator.pushNamed(context, '/vendor'),
        // ),
      ],
    );
  }
}
