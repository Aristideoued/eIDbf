import 'dart:convert';

import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/services/auth_service.dart';
import 'package:http/http.dart' as http;

class QrcodeService {
  static Future<Map<String, dynamic>> createQrcode({
    required int personneId,
    // yyyy-MM-dd
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }
    // ignore: avoid_print

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createqr}');

    final body = {"personneId": personneId};

    print("id envoyé====${personneId}");

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Erreur register (${response.statusCode}) : ${response.body}",
      );
    }
  }

  static Future<Map<String, dynamic>> scanQrcode({
    required String code,
    // yyyy-MM-dd
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }
    // ignore: avoid_print

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.scanqrcode(code)}');

    final response = await http
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Erreur register (${response.statusCode}) : ${response.body}",
      );
    }
  }
}
