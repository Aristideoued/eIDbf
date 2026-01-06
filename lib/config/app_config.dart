import 'dart:ffi';

class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://192.168.11.114:8080';
  // 👉 10.0.2.2 = localhost depuis un émulateur Android
  // 👉 pour iOS simulator : http://localhost:8080

  // Credentials de base
  static const String username = 'ouedraogoaris@gmail.com';
  static const String password = '2885351';

  // Endpoints
  static const String signin = '/api/auth/signin';
  static const String login = '/api/v1/personnes/login';
  static String updatePersonne(String iu) => '/api/v1/personnes/update/iu/$iu';

  static String personneByIu(String iu) => '/api/v1/personnes/iu/$iu';

  static String getDocument(String typeLibelle, String iu) =>
      '/api/v1/documents/search?typeLibelle=$typeLibelle&iu=$iu';

  static String documentPhoto(String docId) => '/api/v1/documents/photo/$docId';
}
