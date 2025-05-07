import 'package:ceyloan_360/utils/popups/loaders.dart';
import "package:connectivity_plus/connectivity_plus.dart";
import 'package:get/get.dart';
import 'dart:async';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    // Use the first result or none if the list is empty
    _connectionStatus.value = results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (_connectionStatus.value == ConnectivityResult.none) {
      APPLoaders.warningSnackBar(title: 'No Internet Connection');
    }
  }

  /// Check the internet connection status.
  /// Returns 'true' if connected, 'false' otherwise.
  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      // If any result is not 'none', then there is some kind of connectivity
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      // Changed from FlutterException to generic catch
      return false;
    }
  }

  /// Dispose or close the active connectivity stream.
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
