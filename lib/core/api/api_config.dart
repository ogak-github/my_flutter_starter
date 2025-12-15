class ApiConfig {
  static const String baseUrl = 'https://dummyjson.com';
  static const int maxRedirects = 5;
  static const int maxRetries = 3;
  static const connectionTimeout = Duration(seconds: 15);
  static const connectionReceiveTimeout = Duration(seconds: 15);
  static const sendTimeout = Duration(seconds: 15);
}
