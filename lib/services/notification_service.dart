import 'dart:convert';

import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/models/Notification.dart';
import 'package:e_id_bf/services/auth_service.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<List<NotificationModel>> getMyNotifications() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }

    final id = await PersonneService.getSavedId();

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getNotifByPersonneId(id)}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(data);

      return data.map((json) => NotificationModel.fromJson(json)).toList();
    }

    if (response.statusCode == 404) {
      return []; // ✅ aucune notification
    }

    throw Exception('Erreur serveur ${response.statusCode}: ${response.body}');
  }

  static Future<Map<String, dynamic>?> markAsRead(int notificationId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.readNotif(notificationId.toString())}',
    );

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

  static Future<int> getUnreadNotificationsCount() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Bearer token introuvable');
    }

    final id = await PersonneService.getSavedId();

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.unReadNotif(id)}');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // ⚡ data est un nombre entier
      return data as int;
    }

    if (response.statusCode == 404) {
      return 0; // aucune notification non lue
    }

    throw Exception('Erreur serveur ${response.statusCode}: ${response.body}');
  }
}
