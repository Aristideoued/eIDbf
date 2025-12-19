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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Services disponibles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  _serviceCard(
                    context,
                    icon: Icons.verified_user,
                    title: "Vérification\nd’identité",
                    color: Colors.green,
                    onTap: () {
                      // TODO : Navigation
                    },
                  ),

                  _serviceCard(
                    context,
                    icon: Icons.people_alt,
                    title: "Registre\nSocial Unique",
                    color: Colors.blue,
                    onTap: () {
                      // TODO : Navigation
                    },
                  ),

                  _serviceCard(
                    context,
                    icon: Icons.phone_android,
                    title: "Téléphonies\nmobiles",
                    color: Colors.orange,
                    onTap: () {
                      // TODO : Navigation
                    },
                  ),

                  _serviceCard(
                    context,
                    icon: Icons.more_horiz,
                    title: "Autres\nservices",
                    color: Colors.grey,
                    onTap: () {
                      // TODO
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD SERVICE =================
  Widget _serviceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
