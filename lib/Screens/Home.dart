import 'package:e_id_bf/Screens/Eservices/eservices_page.dart';
import 'package:e_id_bf/Screens/Identity/casier_page.dart';
import 'package:e_id_bf/Screens/Identity/certificat_page.dart';
import 'package:e_id_bf/Screens/Identity/cnib_page.dart';
import 'package:e_id_bf/Screens/Identity/passport_page.dart';
import 'package:e_id_bf/Screens/Identity/permis_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mainColor = Color(0xFF0B3C8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text("eIDbf"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            _sectionTitle("IDENTITÉ"),
            _identityGrid(context),

            _singleButton(
              context,
              icon: Icons.miscellaneous_services,
              title: "E-SERVICES",
              page: const EservicesPage(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 42, color: mainColor),
          ),
          const SizedBox(height: 10),
          const Text("123456789123", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          const Text(
            "OUEDRAOGO Aristide",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.qr_code),
            label: const Text("Générer QR Code"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: mainColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ================= IDENTITY GRID (COMPACT) =================
  Widget _identityGrid(BuildContext context) {
    final items = [
      (Icons.credit_card, "MA CNIB", const CNIBPage()),
      (Icons.flight, "MON PASSEPORT", const PassportPage()),
      (Icons.description, "CERTIFICAT DE NATIONALITÉ", const CertificatPage()),
      (Icons.gavel, "CASIER JUDICIAIRE", const CasierPage()),
      (Icons.directions_car, "PERMIS DE CONDUIRE", const PermisPage()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.8, // 🔥 TRÈS COMPACT
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _menuButton(
            context,
            icon: item.$1,
            title: item.$2,
            page: item.$3,
          );
        },
      ),
    );
  }

  // ================= MENU BUTTON (ULTRA COMPACT) =================
  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Material(
      color: mainColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: Colors.white),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SINGLE BUTTON =================
  Widget _singleButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 46,
        child: _menuButton(context, icon: icon, title: title, page: page),
      ),
    );
  }
}
