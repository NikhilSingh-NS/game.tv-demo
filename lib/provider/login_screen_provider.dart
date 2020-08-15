import 'package:game_tv_demo/service/data_repo/repository.dart';
import 'package:game_tv_demo/utils/shared_preference_interface.dart';
import 'package:flutter/material.dart';

enum SCREEN_STATE { SUCCESS, FAILURE, IDLE }

class LoginScreenProvider with ChangeNotifier {
  SCREEN_STATE screenState = SCREEN_STATE.IDLE;

  Future<bool> tryLoggingIn(String phoneNumber, String password) async {
    int result = Repository().verifyUser(phoneNumber, password);
    await SharedPreferenceInterface().setInt(LOGGED_IN_USER_ID, result);
    return result != -1;
  }
}
