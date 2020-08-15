import 'dart:async';

import 'package:game_tv_demo/provider/splash_provider.dart';
import 'package:game_tv_demo/routes.dart';
import 'package:game_tv_demo/ui/utils/size_config.dart';
import 'package:game_tv_demo/ui/widgets/image_loader.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<StatefulWidget> {
  final int milliseconds = 2000;
  final SplashProvider splashProvider = SplashProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Timer(Duration(milliseconds: milliseconds), () {
              takeRoutingDecisions();
            }));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Hero(
            tag: 'logo',
            child: ImageLoader().loadFromAssets('game_tv_logo.png',
                width: SizeConfig.getWidth(60),
                height: SizeConfig.getHeight(18)),
          ),
        ),
      ),
    );
  }

  Future<void> takeRoutingDecisions() async {
    await splashProvider.takeRoutingDecision();
    if (splashProvider.screen == SCREEN.LOGIN_SCREEN)
      Routes().navigateWithReplace(LOGIN_SCREEN);
    else
      Routes().navigateWithReplace(HOME_SCREEN);
  }
}
