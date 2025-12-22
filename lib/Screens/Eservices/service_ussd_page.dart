import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceUssd extends StatelessWidget {
  const ServiceUssd({super.key});

  // 🔹 Code USSD réel
  static const String ussdCode = '*123#';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service USSD"), centerTitle: true),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.dialpad),
          label: const Text("Service USSD"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          onPressed: () => _launchUssd(context),
        ),
      ),
    );
  }

  /// 📞 Lance le code USSD + simule le retour réseau
  Future<void> _launchUssd(BuildContext context) async {
    final Uri ussd = Uri.parse('tel:$ussdCode');

    if (await canLaunchUrl(ussd)) {
      await launchUrl(ussd);
    }

    // ⏳ Simulation du retour réseau
    Future.delayed(const Duration(seconds: 1), () {
      _showUssdMenu(context);
    });
  }

  /// 📲 Menu USSD simulé (comme opérateur)
  void _showUssdMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Choisir l’option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("1. Consulter mon identifiant unique"),
            SizedBox(height: 4),
            Text("2. Partager mes infos"),
            SizedBox(height: 4),
            Text("3. Partager mon justificatif"),
            SizedBox(height: 4),
            Text("4. Consulter mes justificatifs"),
          ],
        ),
        actions: [
          _ussdButton(context, "1"),
          _ussdButton(context, "2"),
          _ussdButton(context, "3"),
          _ussdButton(context, "4"),
        ],
      ),
    );
  }

  /// 🔘 Bouton option USSD
  Widget _ussdButton(BuildContext context, String value) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        _handleUssdResponse(context, value);
      },
      child: Text(value),
    );
  }

  /// 📡 Réponse réseau simulée
  void _handleUssdResponse(BuildContext context, String choice) {
    String response;

    switch (choice) {
      case "1":
        response = "Votre identifiant unique est : 01-23-45-6789";
        break;
      case "2":
        response = "Partage des informations effectué avec succès.";
        break;
      case "3":
        response = "Justificatif partagé avec succès.";
        break;
      case "4":
        response = "Vous avez 3 justificatifs disponibles.";
        break;
      default:
        response = "Option invalide.";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Réponse réseau"),
        content: Text(response),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
