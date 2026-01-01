import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiClient {
  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String url) async {
    return http.get(Uri.parse(url), headers: await _headers());
  }

  static Future<http.Response> post(String url, dynamic body) async {
    return http.post(Uri.parse(url), headers: await _headers(), body: body);
  }
}
