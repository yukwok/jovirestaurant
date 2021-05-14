import 'dart:async';
import 'dart:io';

// import '../blocs/auth_bloc.dart';
// import '../styles/base.dart';
// import '../styles/text.dart';
// import '../widgets/app_textfield.dart';
// import '../widgets/button.dart';
// import '../widgets/social_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jovirestaurant/src/blocs/auth_bloc.dart';
import 'package:jovirestaurant/src/styles/base.dart';
import 'package:jovirestaurant/src/styles/text.dart';
import 'package:jovirestaurant/src/widgets/alerts.dart';
import 'package:jovirestaurant/src/widgets/app_textfield.dart';
import 'package:jovirestaurant/src/widgets/button.dart';
import 'package:jovirestaurant/src/widgets/social_button.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/landing');
    });

    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '') {
        AppAlerts.showErrorDialog(Platform.isIOS, context, errorMessage)
            .then((_) => authBloc.clearErrorMessage());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context, authBloc),
      );
    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return Container(
      decoration: BoxDecoration(
          // color: ApplicationColors.backgndColor,
          ),
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/food_background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jovi_fastfood.png'),
              ),
            ),
          ),
          /////

          StreamBuilder<String>(
              stream: authBloc.email,
              builder: (context, snapshot) {
                return AppTextField(
                  isIOS: Platform.isIOS,
                  hintText: 'Your Email',
                  cupertinoIcon: CupertinoIcons.mail_solid,
                  materialIcon: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  errorText: snapshot.error,
                  onChanged: (value) {
                    print('email: $value');
                    authBloc.setEmail(value);
                  },
                  // onChanged: authBloc.setEmail,
                );
              }),
          StreamBuilder<String>(
              stream: authBloc.password,
              builder: (context, snapshot) {
                return AppTextField(
                  isIOS: Platform.isIOS,
                  hintText: 'Password',
                  cupertinoIcon: CupertinoIcons.padlock_solid,

                  // cupertinoIcon: IconData(0xf4c9,
                  //     fontFamily: CupertinoIcons.iconFont,
                  //     fontPackage: CupertinoIcons.iconFontPackage),
                  materialIcon: Icons.lock,
                  obscureText: true,
                  errorText: snapshot.error,
                  onChanged: authBloc.setPassword,
                );
              }),

          StreamBuilder<bool>(
              stream: authBloc.isValid,
              builder: (context, snapshot) {
                return AppButton(
                  buttonText: 'Login',
                  buttonType: (snapshot.data == true)
                      ? ButtonType.LightBlue
                      : ButtonType.Disabled,
                  onPressed: authBloc.loginEmail,
                );
              }),

          Center(child: Text('Or', style: TextStyles.suggestion)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSocialButton(socialType: SocialType.facebook),
              AppSocialButton(socialType: SocialType.google),
            ],
          ),
          Padding(
            padding: BaseStyles.listFieldPadding,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'New Here ? ',
                    style: TextStyles.body,
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: TextStyles.link,
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/signup'),
                      )
                    ])),
          ),
        ],
      ),
    );
  }
}
