import 'dart:typed_data';

import 'package:e_id_bf/Screens/Eservices/eservices_page.dart';
import 'package:e_id_bf/Screens/Identity/casier_page.dart';
import 'package:e_id_bf/Screens/Identity/certificat_page.dart';
import 'package:e_id_bf/Screens/Identity/cnib_page.dart';
import 'package:e_id_bf/Screens/Identity/passport_page.dart';
import 'package:e_id_bf/Screens/Identity/permis_page.dart';
import 'package:e_id_bf/Screens/qrcode_page.dart';
import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/layout/main_layout_controller.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const Color mainColor = Color(0xFF0B3C8A);
  static const Color bgColor = Color(0xFFF5F6FA);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _iu = '';
  String _fullName = '';
  String? _photoUrl; // URL ou bytes pour Image.network
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      // 1️⃣ Récupérer l'IU depuis les SharedPreferences
      final iu = await PersonneService.getSavedIu();
      if (iu.isEmpty) return;

      setState(() {
        _iu = iu;
      });

      // 2️⃣ Récupérer les infos de la personne depuis le backend
      final personne = await PersonneService.getByIu(
        iu,
      ); // tu dois créer cette fonction
      if (personne != null) {
        setState(() {
          _fullName = '${personne['nom']} ${personne['prenom']}';
          // Construire l'URL pour l'image
          _photoUrl =
              '${ApiConfig.baseUrl}/api/v1/personnes/photo/${personne['iu']}';
        });

        /* final photoBytes = await PersonneService.fetchPhoto();
        if (photoBytes != null) {
          setState(() => _photoBytes = photoBytes);
        }*/
      }
    } catch (e) {
      print('Erreur récupération infos utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePage.bgColor,
      appBar: AppBar(
        backgroundColor: HomePage.mainColor,
        elevation: 0,
        title: const Text("eIDbf"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
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
        color: HomePage.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        children: [
          // 🔥 PHOTO DE PROFIL (backend ou placeholder)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _photoUrl != null
                  ? Image.network(
                      _photoUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 100),
                    )
                  : Image.asset("assets/user.jpeg", fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _iu.isNotEmpty ? _iu : 'Chargement...',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 2),

          Text(
            _fullName.isNotEmpty ? _fullName : 'Nom complet',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
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
              foregroundColor: HomePage.mainColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ================= GRID =================
  Widget _identityGrid(BuildContext context) {
    final items = [
      (Icons.credit_card, "MA CNIB", const CNIBPage(), false),
      (Icons.flight, "MON PASSEPORT", const PassportPage(), false),
      (
        Icons.description,
        "CERTIFICAT DE NATIONALITÉ",
        const CertificatPage(),
        false,
      ),
      (Icons.gavel, "CASIER JUDICIAIRE", const CasierPage(), false),
      (Icons.directions_car, "PERMIS DE CONDUIRE", const PermisPage(), false),
      (
        Icons.miscellaneous_services,
        "E-SERVICES",
        const EservicesPage(),
        false,
      ),
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
          isSubPage: item.$4,
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
    required bool isSubPage,
  }) {
    return Material(
      color: HomePage.mainColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (isSubPage) {
            mainLayoutController.openSubPage?.call(page, title: title);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          }
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
