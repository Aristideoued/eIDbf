import 'dart:convert';
import 'package:e_id_bf/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class LoginService {
  /// 🔐 POST /login avec Bearer token
  static Future<http.Response> login({
    required String iu,
    required String password,
  }) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Bearer token introuvable');
    }

    print("==========Identifiant Unique================" + iu);

    print("==========Password================" + password);

    return http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'iu': iu, 'password': password}),
    );
  }
}
