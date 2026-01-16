import 'dart:ffi';

class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://192.168.11.141:8080';
  //  10.0.2.2 = localhost depuis un émulateur Android
  // pour iOS simulator : http://localhost:8080
  //579415601907
  // Credentials de base
  static const String username = 'ouedraogoaris@gmail.com';
  static const String password = '2885351';

  // Endpoints
  static const String signin = '/api/v1/auth/signin';
  static const String login = '/api/v1/personnes/login';
  static const String createqr = '/api/v1/qrcodes/creer';
  static String scanqrcode(String token) => '/api/v1/qrcodes/verify/$token';

  static String updatePersonne(String iu) => '/api/v1/personnes/update/iu/$iu';

  static String personneByIu(String iu) => '/api/v1/personnes/iu/$iu';

  static String getDocument(String typeLibelle, String iu) =>
      '/api/v1/documents/search?typeLibelle=$typeLibelle&iu=$iu';

  static String getNotifByPersonneId(String id) =>
      '/api/v1/notifications/personne/$id';

  static String readNotif(String id) => '/api/v1/notifications/read/$id';
  static String unReadNotif(String personId) =>
      '/api/v1/notifications/unread-count/$personId';

  static String verifyByIu(String iu) => '/api/v1/personnes/verify/$iu';

  static String documentPhoto(String docId) => '/api/v1/documents/photo/$docId';
}
