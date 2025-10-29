import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return result.any((r) => 
        r == ConnectivityResult.wifi || 
        r == ConnectivityResult.mobile || 
        r == ConnectivityResult.ethernet
      );
    } catch (e) {
      return true;
    }
  }
}
