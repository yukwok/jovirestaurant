import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_nav_bar.dart';

abstract class AppSliverScaffold {
  static CupertinoPageScaffold cupertinoSliverScaffold(
      {String navTitle, Widget pageBody, BuildContext context}) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScolled) {
          return <Widget>[
            AppNavBar.cupertinoNavBar(title: navTitle, context: context),
          ];
        },
        body: pageBody,
      ),
    );
  }

  static CupertinoPageScaffold cupertinoSliverScaffoldJulow(
      {String navTitle, Widget pageBody, BuildContext context}) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          AppNavBar.cupertinoNavBar(title: navTitle, context: context),
        ];
      },
      body: pageBody,
    ));
  }

  static Scaffold materialSliverScaffold(
      {String navTitle, Widget pageBody, BuildContext context}) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScolled) {
          return <Widget>[
            AppNavBar.materialNavBar(title: navTitle, pinned: false),
          ];
        },
        body: pageBody,
      ),
    );
  }
}
