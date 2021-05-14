import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/widgets/products_customer.dart';

import 'package:jovirestaurant/src/widgets/profile_customer.dart';
import 'package:jovirestaurant/src/widgets/shopping_bag.dart';

abstract class CustomerScaffold {
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
            icon: Icon(FontAwesomeIcons.shoppingBag), label: 'Cart'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person), label: 'Profile'),
      ],
    );
  }

  static Widget _pageSelection(int index) {
    if (index == 0) {
      return ProductsCustomer();
    }

    if (index == 1) {
      return ShoppingBag();
    }

    return ProfileCustomer();
  }
}
