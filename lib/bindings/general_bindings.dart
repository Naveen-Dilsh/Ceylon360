import 'package:get/get.dart';
import '../data/services/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}


// you gain access to the following data and functionality through the NetworkManager:

// Network Connection Status: You can check if the device is connected to the internet
// Connection Type Information: Determine whether the connection is WiFi, mobile data, etc.
// API Responses: All data fetched from your backend services
// HTTP Status Codes: Response codes from network requests
// Error Information: Detailed error data when network requests fail
// Request Headers/Parameters: Access to request configuration data
// Response Metadata: Information like timestamps, cache status, etc.
// Download/Upload Progress: For file transfers or large data operations