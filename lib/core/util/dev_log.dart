import 'dart:developer' as developer;

class DevLog {
  static void logRequest(String url, {Map<String, dynamic>? params}) {
    developer.log('API REQUEST: $url', name: 'DEV_LOG');
    if (params != null) {
      developer.log('Params: $params', name: 'DEV_LOG');
    }
  }

  static void logResponse(String url, String body) {
    developer.log('API RESPONSE: $url', name: 'DEV_LOG');
    developer.log('Body: $body', name: 'DEV_LOG');
  }

  static void logError(String url, dynamic error) {
    developer.log('API ERROR: $url', name: 'DEV_LOG', error: error);
  }

  static void logLocalFetch(String key, String? data) {
    developer.log('LOCAL FETCH: $key', name: 'DEV_LOG');
    if (data != null) {
      developer.log('Data: $data', name: 'DEV_LOG');
    } else {
      developer.log('No local data found for $key', name: 'DEV_LOG');
    }
  }

  static void logLocalSave(String key, String data) {
    developer.log('LOCAL SAVE: $key', name: 'DEV_LOG');
    developer.log('Data: $data', name: 'DEV_LOG');
  }
}
