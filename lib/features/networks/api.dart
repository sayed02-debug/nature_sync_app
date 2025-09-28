class Api {
  static const String baseUrl = 'https://api.example.com';

  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    // For future use
    return {'temperature': 25, 'condition': 'sunny'};
  }
}