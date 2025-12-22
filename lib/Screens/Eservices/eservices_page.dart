import 'package:e_id_bf/Screens/Eservices/phone_numbers_page.dart';
import 'package:e_id_bf/Screens/Eservices/rsu_verification_page.dart';
import 'package:e_id_bf/Screens/Eservices/service_ussd_page.dart';
import 'package:e_id_bf/Screens/Identity/verification_page.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EservicesPage extends StatefulWidget {
  const EservicesPage({super.key});

  @override
  State<EservicesPage> createState() => _EservicesPageState();
}

class _EservicesPageState extends State<EservicesPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _ussdController = TextEditingController();

  final List<Map<String, dynamic>> _allServices = [
    {"icon": Icons.verified_user, "title": "Vérification d’identité"},
    {"icon": Icons.people_alt, "title": "Registre Social Unique"},
    {"icon": Icons.phone_android, "title": "Téléphonies mobiles"},
    {"icon": Icons.signal_cellular_alt, "title": "Services USSD"},
    {"icon": Icons.more_horiz, "title": "Autres services"},
  ];

  List<Map<String, dynamic>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = _allServices;
  }

  void _onSearch(String value) {
    setState(() {
      _filteredServices = _allServices
          .where(
            (service) =>
                service["title"].toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: const Text("E-Services"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MainLayout.mainColor,
      ),

      // ================= CONTENU =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Services disponibles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // 🔍 CHAMP DE RECHERCHE
            _searchField(),

            const SizedBox(height: 20),

            // 🧩 GRID DES SERVICES
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _filteredServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final service = _filteredServices[index];
                return _serviceCard(
                  icon: service["icon"],
                  title: service["title"],
                  onTap: () {
                    if (service["title"] == "Vérification d’identité") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IdentityVerificationPage(),
                        ),
                      );
                    } else if (service["title"] == "Registre Social Unique") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RsuVerificationPage(),
                        ),
                      );
                    } else if (service["title"] == "Téléphonies mobiles") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PhoneNumbersPage(),
                        ),
                      );
                    } else if (service["title"] == "Services USSD") {
                      _launchUssd(context);
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServiceUssd()),
                      );*/
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 100), // espace bottom
          ],
        ),
      ),

      // ================= BAS DE L'ÉCRAN =================
      bottomNavigationBar: Container(height: 90, color: MainLayout.mainColor),
    );
  }

  // ================= SEARCH FIELD =================
  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: "Rechercher un service...",
          prefixIcon: Icon(Icons.search, color: MainLayout.mainColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ================= CARD SERVICE =================
  Widget _serviceCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: MainLayout.mainColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: MainLayout.mainColor),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const String ussdCode = '*123#';

  /*@override
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
  }*/

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
  /* void _showUssdMenu(BuildContext context) {
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
  }*/

  void _showUssdMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Choisir l’option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Consulter mon identifiant unique"),
            const SizedBox(height: 4),
            const Text("2. Partager mes infos"),
            const SizedBox(height: 4),
            const Text("3. Partager mon justificatif"),
            const SizedBox(height: 4),
            const Text("4. Consulter mes justificatifs"),
            const SizedBox(height: 12),

            /// 🔢 Champ de saisie USSD
            TextField(
              controller: _ussdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Entrer votre choix",
              ),
            ),
          ],
        ),

        /// ⬅️ Annuler | OK ➡️
        actions: [
          TextButton(
            onPressed: () {
              _ussdController.clear();
              Navigator.pop(context);
            },
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              final choice = _ussdController.text.trim();
              _ussdController.clear();
              Navigator.pop(context);
              _handleUssdResponse(context, choice);
            },
            child: const Text("OK"),
          ),
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
  /*void _handleUssdResponse(BuildContext context, String choice) {
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
  }*/

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
        response = "Option invalide. Veuillez réessayer.";
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
