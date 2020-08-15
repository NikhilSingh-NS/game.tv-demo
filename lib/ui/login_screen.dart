import 'dart:ui';

import 'package:game_tv_demo/provider/login_screen_provider.dart';
import 'package:game_tv_demo/ui/utils/colors.dart';
import 'package:game_tv_demo/ui/utils/size_config.dart';
import 'package:game_tv_demo/ui/widgets/image_loader.dart';
import 'package:game_tv_demo/ui/widgets/text_dialog.dart';
import 'package:game_tv_demo/utils/locale/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController;
  TextEditingController passwordController;

  bool isValid = false;
  bool isValidPhone = true;
  bool isValidPassword = true;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      phoneNumberController.addListener(() {
        checkInputValidation();
      });
      passwordController.addListener(() {
        checkInputValidation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<LoginScreenProvider>(
        create: (_) => LoginScreenProvider(),
        child: Consumer<LoginScreenProvider>(builder:
            (BuildContext context, LoginScreenProvider provider, Widget child) {
          return Stack(children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ImageLoader().loadFromAssets('pubg.jpg')),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: ImageLoader().loadFromAssets('game_tv_logo.png',
                          width: SizeConfig.getWidth(60),
                          height: SizeConfig.getHeight(18)),
                    ),
                    SizedBox(
                      height: SizeConfig.getHeight(2),
                    ),
                    buildTextField(
                        AppTranslations.of(context).getString('enter_phone'),
                        false,
                        phoneNumberController),
                    SizedBox(
                      height: SizeConfig.getHeight(2),
                    ),
                    buildTextField(
                        AppTranslations.of(context).getString('enter_password'),
                        true,
                        passwordController),
                    SizedBox(
                      height: SizeConfig.getHeight(2),
                    ),
                    buildLoginButton(provider),
                  ],
                ),
              ),
            ),
          ]);
        }));
  }

  Widget buildTextField(
    String hintText,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
          ),
          child: Container(
            padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
            width: SizeConfig.getWidth(72),
            height: SizeConfig.getHeight(6),
            decoration: BoxDecoration(
                border: Border.all(
                    color: ratingBorderColor, width: SizeConfig.getWidth(0.5)),
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
                color: whiteColor),
            child: Center(
              child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType:
                      isPassword ? TextInputType.text : TextInputType.number,
                  controller: controller,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.getHeight(1)),
                    isDense: true,
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: SizeConfig.getTextSize(4.5),
                        color: nextIconColor),
                  ),
                  style: TextStyle(
                    fontSize: SizeConfig.getTextSize(4.5),
                  ),
                  maxLines: 1,
                  obscureText: isPassword),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        ((isPassword && !isValidPassword) || (!isPassword && !isValidPhone))
            ? Text(
                isPassword
                    ? AppTranslations.of(context).getString('password_error')
                    : AppTranslations.of(context).getString('phone_error'),
                style: TextStyle(color: endPeachColor),
              )
            : Container()
      ],
    );
  }

  Widget buildLoginButton(LoginScreenProvider provider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
      ),
      child: GestureDetector(
        onTap: () async {
          if (isValid) {
            bool status = await provider.tryLoggingIn(
                phoneNumberController.text.toString(),
                passwordController.text.toString());
            if (status) {
              Routes().navigateWithReplace(HOME_SCREEN);
            } else {
              TextDialog.showTextDialog(context,
                  AppTranslations.of(context).getString('invalid_credentials'));
            }
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
          width: SizeConfig.getWidth(72),
          height: SizeConfig.getHeight(7),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isValid ? initialOrangeColor : Colors.grey.withOpacity(0.9),
                    isValid ? endOrangeColor : Colors.grey.withOpacity(0.2)
                  ])),
          child: Center(
            child: Text(
              AppTranslations.of(context).getString('login'),
              style: TextStyle(
                  color: isValid ? whiteColor : Colors.grey.withOpacity(0.6),
                  fontSize: SizeConfig.getTextSize(5.5),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkInputValidation() {
    //condition for login button...
    if (phoneNumberController.text.toString().length > 2 &&
        phoneNumberController.text.toString().length < 11 &&
        passwordController.text.length > 2) {
      if (!isValid) {
        setState(() {
          isValid = true;
        });
      }
    } else {
      if (isValid)
        setState(() {
          isValid = false;
        });
    }

    //conditions for error text...
    if ((phoneNumberController.text.toString().length > 0 &&
            phoneNumberController.text.toString().length < 3) ||
        phoneNumberController.text.toString().length > 10) {
      if (isValidPhone)
        setState(() {
          isValidPhone = false;
        });
    } else {
      if (!isValidPhone)
        setState(() {
          isValidPhone = true;
        });
    }
    if (passwordController.text.toString().length > 0 &&
        passwordController.text.toString().length < 3) {
      if (isValidPassword)
        setState(() {
          isValidPassword = false;
        });
    } else {
      if (!isValidPassword)
        setState(() {
          isValidPassword = true;
        });
    }
  }
}
