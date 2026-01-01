import 'dart:convert';
import 'package:e_id_bf/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PersonneService {
  /// Récupère une personne par IU
  static Future<Map<String, dynamic>?> getByIu(String iu) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.personneByIu(iu)}');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("Data========" + response.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data; // JSON de PersonneDto
    } else if (response.statusCode == 404) {
      return null; // personne non trouvée
    } else {
      throw Exception(
        'Erreur serveur ${response.statusCode}: ${response.body}',
      );
    }
  }
}
