import 'dart:async';

// import '../blocs/auth_bloc.dart';
// import '../styles/tabbar.dart';
// import '../widgets/app_nav_bar.dart';
// import '../widgets/orders.dart';
// import '../widgets/products.dart';
// import '../widgets/profile.dart';
// import '../widgets/vendor_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/blocs/auth_bloc.dart';
import 'package:jovirestaurant/src/styles/tabbar.dart';
import 'package:jovirestaurant/src/widgets/app_nav_bar.dart';
import 'package:jovirestaurant/src/widgets/orders.dart';
import 'package:jovirestaurant/src/widgets/products.dart';
import 'package:jovirestaurant/src/widgets/profile.dart';
import 'package:jovirestaurant/src/widgets/vendor_scaffold.dart';
import 'package:provider/provider.dart';

class Vendor extends StatefulWidget {
  @override
  _VendorState createState() => _VendorState();

  static TabBar get vendorTabBar {
    return TabBar(
      unselectedLabelColor: TabBarStyles.unselectedLabelColor,
      labelColor: TabBarStyles.labelColor,
      indicatorColor: TabBarStyles.indicatorColor,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.list)),
        Tab(icon: Icon(Icons.shopping_cart)),
        Tab(icon: Icon(Icons.person)),
      ],
    );
  }
}

class _VendorState extends State<Vendor> {
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
                    title: 'Vendor news', context: context),
              ];
            },
            body: VendorScaffold.cupertinoTabScaffold),
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
                    title: 'Vendor news', tabBar: Vendor.vendorTabBar),
              ];
            },
            body: TabBarView(
              children: [
                Products(),
                Orders(),
                Profile(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
