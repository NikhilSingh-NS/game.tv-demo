import 'package:game_tv_demo/service/plugins/connectivity/connectivity_interface.dart';

class Utility {
  static Future<bool> isInternetConnected() async {
    return await ConnectivityInterface().isInternetConnected();
  }
}
