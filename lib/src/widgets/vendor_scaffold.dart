// import '../styles/colors.dart';
// import '../widgets/products.dart';
// import '../widgets/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/widgets/products.dart';
import 'package:jovirestaurant/src/widgets/profile.dart';

import 'orders.dart';

abstract class VendorScaffold {
  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTabBar,
      tabBuilder: (context, index) {
        return _pageSelection(index);
      },
    );
  }

  static get _cupertinoTabBar {
    return CupertinoTabBar(
      backgroundColor: AppColors.darkBlue,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create), label: 'Products'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person), label: 'Profile'),
      ],
    );
  }

  static Widget _pageSelection(int index) {
    if (index == 0) {
      return Products();
    }

    if (index == 1) {
      return Orders();
    }

    return Profile();
  }
}