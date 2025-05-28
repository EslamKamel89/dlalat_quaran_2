import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isInternetAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.other)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  }
  return false;
}
