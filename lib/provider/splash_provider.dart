import 'package:game_tv_demo/utils/shared_preference_interface.dart';
import 'package:flutter/material.dart';

enum SCREEN{
  LOGIN_SCREEN,
  HOME_SCREEN
}

class SplashProvider with ChangeNotifier{

  SCREEN screen;

  Future<void> takeRoutingDecision() async{
    SharedPreferenceInterface sharedPreferenceInterface = SharedPreferenceInterface();
    int id = await sharedPreferenceInterface.getInt(LOGGED_IN_USER_ID);
    if(id != null && id != -1)
      screen = SCREEN.HOME_SCREEN;
    else
      screen = SCREEN.LOGIN_SCREEN;
  }

}