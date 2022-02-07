import 'package:jovirestaurant/src/blocs/customer_bloc.dart';
import 'package:jovirestaurant/src/blocs/product_bloc.dart';
import 'package:jovirestaurant/src/blocs/vendor_bloc.dart';
import 'package:jovirestaurant/src/routes.dart';
import 'package:jovirestaurant/src/screens/landing.dart';
import 'package:jovirestaurant/src/screens/login.dart';
import 'package:jovirestaurant/src/services/firestore_service.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';

final authBloc = AuthBloc();
final productBloc = ProductBloc();
final vendorBloc = VendorBloc();
final firestore = FirestoreService();
final customerBloc = CustomerBloc();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(create: (context) => authBloc),
      Provider(create: (context) => productBloc),
      Provider(create: (context) => customerBloc),
      Provider(create: (context) => vendorBloc),
      FutureProvider(create: (context) => authBloc.isLoggedIn()),
      StreamProvider(create: (context) => firestore.fetchUnitTypes()),
    ], child: PlatformApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    productBloc.dispose();
    customerBloc.dispose();
    vendorBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {
  Widget loadingScreen(bool isIOS) {
    return (isIOS)
        ? CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        home: (isLoggedIn == null)
            ? loadingScreen(true)
            : (isLoggedIn == true)
                ? Landing()
                : Login(),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(
          primaryColor: AppColors.straw,
          scaffoldBackgroundColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            tabLabelTextStyle: TextStyles.suggestion,
          ),
        ),
      );
    } else {
      return MaterialApp(
        home: (isLoggedIn == null)
            ? loadingScreen(false)
            : (isLoggedIn == true)
                ? Landing()
                : Login(),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
    }
  }
}
