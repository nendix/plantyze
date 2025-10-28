import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return result.isNotEmpty && 
             !result.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
