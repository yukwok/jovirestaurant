import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovirestaurant/src/blocs/auth_bloc.dart';
import 'package:jovirestaurant/src/blocs/vendor_bloc.dart';
import 'package:jovirestaurant/src/models/vendor.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/colors.dart';
import 'package:jovirestaurant/src/styles/text.dart';
import 'package:jovirestaurant/src/widgets/app_textfield.dart';
import 'package:jovirestaurant/src/widgets/button.dart';
import 'package:jovirestaurant/src/widgets/sliver_scaffold.dart';
import 'package:provider/provider.dart';

class EditVendor extends StatefulWidget {
  final String vendorId;

  EditVendor({this.vendorId});

  @override
  _EditVendorState createState() => _EditVendorState();
}

class _EditVendorState extends State<EditVendor> {
  StreamSubscription _savedSubscription;
  @override
  void initState() {
    print('in class EDitVendor');

    var vendorBloc = Provider.of<VendorBloc>(context, listen: false);
    _savedSubscription = vendorBloc.vendorSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
            msg: "Vendor saved.",
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

        if (vendor != null) {
          //Edit product

          loadValues(vendorBloc, vendor, authBloc.userId);
        } else {
          //Add product
          loadValues(vendorBloc, null, authBloc.userId);
        }

        return (Platform.isIOS)
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: authBloc.userId, //name of the products?
                pageBody: pagebody(
                  Platform.isIOS,
                  vendorBloc,
                  context,
                  vendor,
                ),
                context: context,
              )
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: authBloc.userId,
                pageBody: pagebody(
                  Platform.isIOS,
                  vendorBloc,
                  context,
                  vendor,
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
    var pageLabel = (existingVendor != null) ? 'Edit Profile' : 'Add Profile';

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
              cupertinoIcon: FontAwesomeIcons.hashtag,
              materialIcon: FontAwesomeIcons.hashtag,
              hintText: 'description',
              textInputType: TextInputType.text,
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
          stream: vendorBloc.isValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Profile',
              onPressed: vendorBloc.saveVendor,
            );
          }),
    ]);
  }

  loadValues(VendorBloc vendorBloc, Vendor vendor, String venderId) {
    // vendorBloc.changeVendor(vendor);
    vendorBloc.changeVendorId(venderId);

    if (vendor != null) {
      //Edit
      vendorBloc.changeName(vendor.name);
      vendorBloc.changeDescription(vendor.description);
      vendorBloc.changeImageUrl(vendor.imageUrl ?? '');
    } else {
      //Add new vendor information
      vendorBloc.changeName(null);
      vendorBloc.changeDescription(null);
      vendorBloc.changeImageUrl('');
    }
  }
}
