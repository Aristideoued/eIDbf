import 'package:url_launcher/url_launcher.dart';

class UssdLauncher {
  /// 📞 Lance un code USSD (ex: *123#)
  static Future<bool> launchUssd(String ussdCode) async {
    final Uri uri = Uri.parse('tel:$ussdCode');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }
}
