import 'dart:convert';
import 'dart:typed_data';
import 'package:e_id_bf/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    // ignore: avoid_print
    print("Data========$response");
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

  static Future<Map<String, dynamic>> registerPersonne({
    required String nom,
    required String prenom,
    required String lieuNaissance,
    required String sexe,
    required String dateNaissance,
    required String iu,
    required String password,
    // yyyy-MM-dd
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }
    // ignore: avoid_print
    print("Token====== dans register  " + token.toString());

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.updatePersonne(iu)}',
    );

    final body = {
      "nom": nom,
      "prenom": prenom,
      "lieuNaissance": lieuNaissance,
      "sexe": sexe,
      "dateNaissance": dateNaissance,
      "password": password,
    };

    final response = await http
        .put(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
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

  static Future<String> getSavedIu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('iu') ?? '';
  }

  static Future<Uint8List?> fetchPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final iu = prefs.getString('iu') ?? '';
    final token = await AuthService.getToken(); // Ton token JWT

    if (iu.isEmpty || token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/personnes/photo/$iu');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Retourne les bytes de l'image
    } else {
      print("Erreur récupération photo : ${response.statusCode}");
      return null;
    }
  }
}
