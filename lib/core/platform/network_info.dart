import 'dart:io';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> isConnected() async {
    try {
      final response = await HttpClient().getUrl(
        Uri.parse("https://google.com"),
      ); // Replace with a valid website or API endpoint
      final httpResponse = await response.close();
      if (httpResponse.statusCode == HttpStatus.ok) {
        return true; // Internet connection is available
      } else {
        return false; // No internet connection
      }
    } catch (e) {
      return false; // No internet connection
    }
  }
}
