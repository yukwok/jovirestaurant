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

        Vendor vendor = snapshot.data;

        if (widget.vendorId != null) {
          //Edit product

          loadValues(VendorBloc, existingProduct, authBloc.userId);
        } else {
          //Add product
          loadValues(VendorBloc, null, authBloc.userId);
        }

        return (Platform.isIOS)
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: authBloc.userId, //name of the products?
                pageBody: pagebody(
                  Platform.isIOS,
                  VendorBloc,
                  context,
                  existingProduct,
                ),
                context: context,
              )
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: authBloc.userId,
                pageBody: pagebody(
                  Platform.isIOS,
                  VendorBloc,
                  context,
                  existingProduct,
                ),
                context: context,
              );
      },
    );
  }

  Widget pagebody(
    bool isIOS,
    VendorBloc productBloc,
    BuildContext context,
    Product existingProduct,
  ) {
    var items = Provider.of<List<String>>(context);
    var pageLabel = (existingProduct != null) ? 'Edit product' : 'Add product';

    // print(user);
    return ListView(children: <Widget>[
      Text(pageLabel, style: TextStyles.subTitle, textAlign: TextAlign.center),
      Padding(
        padding: BaseStyles.listPadding,
        child: Divider(color: AppColors.darkBlue),
      ),
      StreamBuilder<String>(
          stream: productBloc.productName,
          builder: (context, snapshot) {
            return AppTextField(
              cupertinoIcon: FontAwesomeIcons.shoppingBasket,
              materialIcon: FontAwesomeIcons.shoppingBasket,
              hintText: 'Product Name',
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingProduct != null)
                  ? existingProduct.productName
                  : null,
              onChanged: productBloc.changeProductName,
            );
          }),
      StreamBuilder<String>(
          stream: productBloc.unitType,
          builder: (context, snapshot) {
            return AppDropdownButton(
              items: (items != null) ? items : ['no unit type loaded.'],
              hintText: 'Unit Type',
              materialIcon: FontAwesomeIcons.balanceScale,
              cupertinoIcon: FontAwesomeIcons.balanceScale,
              value: snapshot.data, ////////////////////////////////////
              onchanged: productBloc.changeUnitType,
            );
          }),
      StreamBuilder<double>(
          stream: productBloc.unitPrice,
          builder: (context, snapshot) {
            return AppTextField(
              cupertinoIcon: FontAwesomeIcons.tag,
              materialIcon: FontAwesomeIcons.tag,
              hintText: 'Unit Price',
              textInputType: TextInputType.number,
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingProduct != null)
                  ? existingProduct.unitPrice.toString()
                  : null,
              onChanged: productBloc.changeUnitPrice,
            );
          }),
      StreamBuilder<int>(
          stream: productBloc.availableUnits,
          builder: (context, snapshot) {
            return AppTextField(
              cupertinoIcon: FontAwesomeIcons.hashtag,
              materialIcon: FontAwesomeIcons.hashtag,
              hintText: 'Available Units',
              textInputType: TextInputType.number,
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingProduct != null)
                  ? existingProduct.availableUnits.toString()
                  : null,
              onChanged: productBloc.changeAvailableUnits,
            );
          }),
      StreamBuilder<String>(
          stream: productBloc.imageUrl,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == "")
              return Column(
                children: [
                  Text('imageUrl: ${snapshot.hasData}'),
                  AppButton(
                      buttonType: ButtonType.Straw,
                      buttonText: 'Add Image',
                      onPressed: () {
                        productBloc.pickImage();
                      }),
                ],
              );

            return Column(children: <Widget>[
              Text(
                'imageUrl: ${snapshot.data}',
                style: TextStyle(fontSize: 6.0),
              ),
              StreamBuilder(
                stream: productBloc.isUploading,
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
                  onPressed: productBloc.pickImage)
            ]);
          }),
      StreamBuilder<bool>(
          stream: productBloc.isValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Product',
              onPressed: productBloc.saveProduct,
            );
          }),
    ]);
  }

  loadValues(VendorBloc vendorBloc, Vendor vendor, String venderId) {
    // vendorBloc.(product);
    vendorBloc.changeVendorId(venderId);

    if (vendor != null) {
      //Edit
      vendorBloc.changeName(vendor.name);
      vendorBloc.changeDescription(vendor.description);

      vendorBloc.changeImageUrl(vendor.imageUrl ?? '');
    } else {
      //Add
      vendorBloc.changeName(null);
      vendorBloc.changeDescription(null);

      vendorBloc.changeImageUrl('');
    }
  }
}
