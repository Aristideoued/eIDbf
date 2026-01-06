import 'dart:convert';

import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/services/auth_service.dart';
import 'package:http/http.dart' as http;

class DocumentService {
  static Future<Map<String, dynamic>> getDocument({
    required String typeLibelle,
    required String iu,

    // yyyy-MM-dd
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }
    // ignore: avoid_print

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getDocument(typeLibelle, iu)}',
    );

    final response = await http
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Erreur register (${response.statusCode}) : ${response.body}",
      );
    }
  }

  static Future<Map<String, dynamic>> getDocumentPhoto({
    required String docId,

    // yyyy-MM-dd
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }
    // ignore: avoid_print

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.documentPhoto(docId)}',
    );

    final response = await http
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Erreur register (${response.statusCode}) : ${response.body}",
      );
    }
  }
}
