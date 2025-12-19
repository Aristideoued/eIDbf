import 'package:e_id_bf/Screens/Eservices/eservices_page.dart';
import 'package:e_id_bf/Screens/Identity/casier_page.dart';
import 'package:e_id_bf/Screens/Identity/certificat_page.dart';
import 'package:e_id_bf/Screens/Identity/cnib_page.dart';
import 'package:e_id_bf/Screens/Identity/passport_page.dart';
import 'package:e_id_bf/Screens/Identity/permis_page.dart';
import 'package:e_id_bf/Screens/qrcode_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mainColor = Color(0xFF0B3C8A);
  static const Color bgColor = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text("eIDbf"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🔥 FOND DÉCORATIF BAS
          /* Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),*/

          // 🔝 CONTENU PRINCIPAL
          Column(
            children: [
              _header(),

              const SizedBox(height: 40),

              Expanded(child: _identityGrid(context)),
            ],
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: const BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        children: [
          // 🔥 IMAGE À LA PLACE DE L’AVATAR
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/user.jpeg", fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "123456789123",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 2),

          const Text(
            "OUEDRAOGO Aristide",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),
          Builder(
            builder: (context) => ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrCodePage()),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text("Générer QR Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: mainColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= GRID =================
  Widget _identityGrid(BuildContext context) {
    final items = [
      (Icons.credit_card, "MA CNIB", const CNIBPage()),
      (Icons.flight, "MON PASSEPORT", const PassportPage()),
      (Icons.description, "CERTIFICAT DE NATIONALITÉ", const CertificatPage()),
      (Icons.gavel, "CASIER JUDICIAIRE", const CasierPage()),
      (Icons.directions_car, "PERMIS DE CONDUIRE", const PermisPage()),
      (Icons.miscellaneous_services, "E-SERVICES", const EservicesPage()),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.1,
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
    );
  }

  // ================= MENU BUTTON =================
  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Material(
      color: mainColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.8,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
