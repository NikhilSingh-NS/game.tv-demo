import 'package:game_tv_demo/ui/widgets/fade_in.dart';
import 'package:game_tv_demo/ui/widgets/scale_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_tv_demo/ui/home_screen.dart';
import 'package:game_tv_demo/ui/login_screen.dart';
import 'package:game_tv_demo/ui/splash_screen.dart';

enum TransitionType { SCALE_IN, FADE_IN }

const String LOGIN_SCREEN = 'login_screen';
const String HOME_SCREEN = 'home_sreen';
const String SPLASH_SCREEN = 'splash';

class Routes {
  factory Routes() {
    return _instance;
  }

  Routes._internal();

  static final Routes _instance = Routes._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, WidgetBuilder> map = <String, WidgetBuilder>{
    '/': (BuildContext context) {
      return Splash();
    },
    LOGIN_SCREEN:(BuildContext context) {
      return LoginScreen();
    },
    HOME_SCREEN:(BuildContext context) {
      return HomeScreen();
    },
  };

  Future<void> navigateWithReplace(String name,
      {Object arguments,
      bool pushNamedAndRemoveUntil = false,
      String lastScreen}) async {
    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    if (pushNamedAndRemoveUntil) {
      if (lastScreen != null) {
        navigatorKey.currentState.pushNamedAndRemoveUntil(
            name, ModalRoute.withName(lastScreen),
            arguments: arguments);
      } else {
        navigatorKey.currentState.pushNamedAndRemoveUntil(
            name, (Route<dynamic> route) => false,
            arguments: arguments);
      }
    } else {
      navigatorKey.currentState
          .pushReplacementNamed(name, arguments: arguments);
    }
  }

  Future<dynamic> navigateTo(
    BuildContext context,
    String name, {
    bool withAnimation = false,
    TransitionType type,
    Object arguments,
  }) async {
    final Widget screen = map[name](context);
    final RouteSettings routeSettings =
        RouteSettings(name: name, arguments: arguments);

    //default only if with Animation
    PageRouteBuilder<dynamic> pageRouteBuilder =
        FadeTransitionRoute(widget: screen, routeSettings: routeSettings);

    switch (type) {
      case TransitionType.SCALE_IN:
        pageRouteBuilder =
            ScaleRoute(widget: screen, routeSettings: routeSettings);
        break;
      case TransitionType.FADE_IN:
        pageRouteBuilder =
            FadeTransitionRoute(widget: screen, routeSettings: routeSettings);
        break;
      default:
        pageRouteBuilder =
            FadeTransitionRoute(widget: screen, routeSettings: routeSettings);
    }

    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    if (withAnimation)
      return await navigatorKey.currentState.push(pageRouteBuilder);
    else
      return await navigatorKey.currentState
          .pushNamed(name, arguments: arguments);
  }

  Future<bool> pop(dynamic data) async {
    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    navigatorKey.currentState.pop<dynamic>(data);
    return true;
  }

  Widget getScreenWidgetFromName(BuildContext context, String name) {
    return map[name](context);
  }
}
