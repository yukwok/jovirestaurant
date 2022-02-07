import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/blocs/auth_bloc.dart';
import 'package:jovirestaurant/src/blocs/product_bloc.dart';
import 'package:jovirestaurant/src/blocs/vendor_bloc.dart';
import 'package:jovirestaurant/src/models/product.dart';
import 'package:jovirestaurant/src/models/vendor.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';
import 'package:jovirestaurant/src/widgets/app_textfield.dart';
import 'package:jovirestaurant/src/widgets/button.dart';
import 'package:jovirestaurant/src/widgets/dropdown_button.dart';
import 'package:jovirestaurant/src/widgets/sliver_scaffold.dart';
import 'package:provider/provider.dart';

//edit vendor screen

class EditVendor extends StatefulWidget {
  final String vendorId;

  EditVendor({this.vendorId});

  @override
  _EditVendorState createState() => _EditVendorState();
}

class _EditVendorState extends State<EditVendor> {
  StreamSubscription _savedSubscription; // TODO: what is this ??? please study

  @override
  void initState() {
    var vendorBloc = Provider.of<VendorBloc>(context, listen: false);
    _savedSubscription = vendorBloc.vendorSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
            msg: "Vendor profile saved.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightBlue,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _savedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vendorBloc = Provider.of<VendorBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<Vendor>(
      stream: vendorBloc.vendor,
      // future: vendorBloc.fetchVendor(widget.vendorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.vendorId != null) {
          //fetching product data
          return Scaffold(
            body: Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator()),
          );
        }

        //TODO load bloc values
        Vendor existingVendor;

        if (widget.vendorId != null) {
          //Edit product
          existingVendor = snapshot.data;
          loadValues(vendorBloc, existingVendor, authBloc.userId);
        } else {
          //Add product
          loadValues(vendorBloc, null, authBloc.userId);
        }

        return (Platform.isIOS)
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: authBloc.userId, //name of the vendor?
                pageBody: pagebody(
                  Platform.isIOS,
                  vendorBloc,
                  context,
                  existingVendor,
                ),
                context: context,
              )
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: authBloc.userId,
                pageBody: pagebody(
                  Platform.isIOS,
                  vendorBloc,
                  context,
                  existingVendor,
                ),
                context: context,
              );
      },
    );
  }

  Widget pagebody(
    bool isIOS,
    VendorBloc vendorBloc,
    BuildContext context,
    Vendor existingVendor,
  ) {
    var items = Provider.of<List<String>>(context);
    var pageLabel = (existingVendor != null) ? 'Edit vendor' : 'Add vendor';

    // print(user);
    return ListView(children: <Widget>[
      Text(pageLabel, style: TextStyles.subTitle, textAlign: TextAlign.center),
      Padding(
        padding: BaseStyles.listPadding,
        child: Divider(color: AppColors.darkBlue),
      ),
      StreamBuilder<String>(
          stream: vendorBloc.name,
          builder: (context, snapshot) {
            return AppTextField(
              cupertinoIcon: FontAwesomeIcons.shoppingBasket,
              materialIcon: FontAwesomeIcons.shoppingBasket,
              hintText: 'Vendor Name',
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText:
                  (existingVendor != null) ? existingVendor.name : null,
              onChanged: vendorBloc.changeName,
            );
          }),
      StreamBuilder<String>(
          stream: vendorBloc.description,
          builder: (context, snapshot) {
            return AppTextField(
              cupertinoIcon: FontAwesomeIcons.shoppingBasket,
              materialIcon: FontAwesomeIcons.shoppingBasket,
              hintText: 'type description',
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText:
                  (existingVendor != null) ? existingVendor.description : null,
              onChanged: vendorBloc.changeDescription,
            );
          }),
      StreamBuilder<String>(
          stream: vendorBloc.imageUrl,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == "")
              return Column(
                children: [
                  Text('imageUrl: ${snapshot.hasData}'),
                  AppButton(
                      buttonType: ButtonType.Straw,
                      buttonText: 'Add Image',
                      onPressed: () {
                        vendorBloc.pickImage();
                      }),
                ],
              );

            return Column(children: <Widget>[
              Text(
                'imageUrl: ${snapshot.data}',
                style: TextStyle(fontSize: 6.0),
              ),
              StreamBuilder(
                stream: vendorBloc.isUploading,
                builder: (context, snapshot) {
                  return (!snapshot.hasData || snapshot.data == false)
                      ? Container()
                      : Center(
                          child: (Platform.isIOS)
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        );
                },
              ),
              Padding(
                padding: BaseStyles.listPadding,
                child: Image.network(snapshot.data),
              ),
              AppButton(
                  buttonType: ButtonType.Straw,
                  buttonText: 'Change Image',
                  onPressed: vendorBloc.pickImage)
            ]);
          }),
      StreamBuilder<bool>(
          stream: vendorBloc.vendorSaved,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Vendor',
              onPressed: vendorBloc.saveVendor,
            );
          }),
    ]);
  }

  // final _db = FirestoreService();
  // final _name = BehaviorSubject<String>();
  // final _description = BehaviorSubject<String>();
  // final _imageUrl = BehaviorSubject<String>();
  // final _vendorId = BehaviorSubject<String>();
  // final _vendorSaved = PublishSubject<bool>();
  // final _vendor = BehaviorSubject<Vendor>();
  // final _isUploading = BehaviorSubject<bool>();

  loadValues(VendorBloc vendorBloc, Vendor vendor, String venderId) {
    vendorBloc.changeVendor(vendor);
    // vendorBloc.change(venderId);

    if (vendor != null) {
      //Edit
      // vendorBloc.changeProductName(product.productName);
      // vendorBloc.changeUnitType(vendor.unitType);
      // vendorBloc.changeAvailableUnits(vendor.availableUnits.toString());
      // vendorBloc.changeUnitPrice(vendor.unitPrice.toString());
      // vendorBloc.changeImageUrl(vendor.imageUrl ?? '');
    } else {
      //Add
      // productBloc.changeUnitType(null);
      // productBloc.changeProductName(null);
      // productBloc.changeAvailableUnits(null);
      // productBloc.changeUnitPrice(null);
      // productBloc.changeImageUrl('');
    }
  }
}
