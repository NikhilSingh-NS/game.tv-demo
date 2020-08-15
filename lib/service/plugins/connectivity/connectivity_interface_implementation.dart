import 'package:game_tv_demo/service/plugins/connectivity/connectivity_interface.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityImpl implements ConnectivityInterface {
  @override
  Future<bool> isInternetConnected() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
