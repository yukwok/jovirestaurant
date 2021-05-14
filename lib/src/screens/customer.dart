import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/blocs/auth_bloc.dart';
import 'package:jovirestaurant/src/styles/tabbar.dart';
import 'package:jovirestaurant/src/widgets/app_nav_bar.dart';
import 'package:jovirestaurant/src/widgets/orders.dart';
import 'package:jovirestaurant/src/widgets/products_customer.dart';
import 'package:jovirestaurant/src/widgets/products.dart';
import 'package:jovirestaurant/src/widgets/profile.dart';
import 'package:jovirestaurant/src/widgets/customer_scaffold.dart';
import 'package:jovirestaurant/src/widgets/profile_customer.dart';
import 'package:jovirestaurant/src/widgets/shopping_bag.dart';
import 'package:provider/provider.dart';

class Customer extends StatefulWidget {
  final String marketId;

  Customer({@required this.marketId});
  @override
  _CustomerState createState() => _CustomerState();

  static TabBar get customerTabBar {
    return TabBar(
      unselectedLabelColor: TabBarStyles.unselectedLabelColor,
      labelColor: TabBarStyles.labelColor,
      indicatorColor: TabBarStyles.indicatorColor,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.list)),
        Tab(icon: Icon(FontAwesomeIcons.shoppingBag)),
        Tab(icon: Icon(Icons.person)),
      ],
    );
  }
}

class _CustomerState extends State<Customer> {
  StreamSubscription _userSubscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(

            /////////////inner??????
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScolled) {
              return <Widget>[
                AppNavBar.cupertinoNavBar(
                    title: 'Customer name', context: context),
              ];
            },
            body: CustomerScaffold.cupertinoTabScaffold),
      );
    } else {
      return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          body: NestedScrollView(
            /////////////inner??????
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScolled) {
              return <Widget>[
                AppNavBar.materialNavBar(
                    title: 'Customer name', tabBar: Customer.customerTabBar),
              ];
            },
            body: TabBarView(
              children: [
                ProductsCustomer(),
                ShoppingBag(),
                ProfileCustomer(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
