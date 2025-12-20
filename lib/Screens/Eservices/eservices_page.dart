import 'package:e_id_bf/Screens/Eservices/phone_numbers_page.dart';
import 'package:e_id_bf/Screens/Eservices/rsu_verification_page.dart';
import 'package:e_id_bf/Screens/Identity/verification_page.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:flutter/material.dart';

class EservicesPage extends StatefulWidget {
  const EservicesPage({super.key});

  @override
  State<EservicesPage> createState() => _EservicesPageState();
}

class _EservicesPageState extends State<EservicesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allServices = [
    {"icon": Icons.verified_user, "title": "Vérification d’identité"},
    {"icon": Icons.people_alt, "title": "Registre Social Unique"},
    {"icon": Icons.phone_android, "title": "Téléphonies mobiles"},
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
}
