import 'package:e_id_bf/layout/main_layout.dart';
import 'package:flutter/material.dart';

class EservicesPage extends StatelessWidget {
  const EservicesPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "Services disponibles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.4, // augmente pour des cartes moins hautes
              children: [
                _serviceCard(
                  icon: Icons.verified_user,
                  title: "Vérification\nd’identité",
                  onTap: () {},
                ),
                _serviceCard(
                  icon: Icons.people_alt,
                  title: "Registre\nSocial Unique",
                  onTap: () {},
                ),
                _serviceCard(
                  icon: Icons.phone_android,
                  title: "Téléphonies\nmobiles",
                  onTap: () {},
                ),
                _serviceCard(
                  icon: Icons.more_horiz,
                  title: "Autres\nservices",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 100), // espace pour le bottomNavigationBar
          ],
        ),
      ),
      bottomNavigationBar: Container(height: 80, color: MainLayout.mainColor),
    );
  }

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
        padding: const EdgeInsets.all(12), // réduit ici de 16 à 12
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12), // cercle icône plus petit
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: MainLayout.mainColor,
              ), // icône légèrement plus petite
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13, // texte un peu plus petit
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
