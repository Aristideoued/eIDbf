import 'dart:convert';
import 'package:e_id_bf/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';

  static Future<void> initializeAuth() async {
    /*final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(_tokenKey);

  if (token != null && token.isNotEmpty) return;*/

    // ⚠️ Timeout pour éviter blocage
    print("Lancement de la connexion");
    final success =
        await signin(
          username: ApiConfig.username,
          password: ApiConfig.password,
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            return false;
          },
        );

    print("Fin du Lancement de la connexion");

    if (!success) {
      throw Exception('Impossible de récupérer le token');
    }
  }

  /// 🔐 Signin → récupère le Bearer token
  static Future<bool> signin({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signin}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['token']; // adapt selon backend

      if (token == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);

      return true;
    }

    return false;
  }

  /// 📥 Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 🚪 Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
