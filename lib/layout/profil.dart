import 'package:e_id_bf/Screens/Register.dart';
import 'package:e_id_bf/Screens/login.dart';
import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:e_id_bf/services/personne_service.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  /// 1️⃣ Récupérer IU depuis prefs
  /// 2️⃣ Charger le profil depuis le backend
  Future<Map<String, dynamic>> _loadProfil() async {
    final iu = await PersonneService.getSavedIu();

    // ignore: unnecessary_null_comparison
    if (iu == null || iu.isEmpty) {
      throw Exception("Identifiant unique introuvable");
    }

    final profil = await PersonneService.getByIu(iu);

    if (profil == null) {
      throw Exception("Profil utilisateur introuvable");
    }

    return profil; // ✅ non-null garanti
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon profil")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadProfil(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur de chargement du profil",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Aucune donnée trouvée"));
          }

          final data = snapshot.data!;
          final photoUrl =
              '${ApiConfig.baseUrl}/api/v1/personnes/photo/${data['iu']}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// PHOTO
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: Image.network(
                      photoUrl ?? "",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/avatar.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// INFOS PERSONNELLES
                _infoTile("Nom", data['nom']),
                _infoTile("Prénom", data['prenom']),
                _infoTile("Date de naissance", data['dateNaissance']),
                _infoTile("Lieu de naissance", data['lieuNaissance']),
                _infoTile("Sexe", data['sexe']),
                _infoTile("Identifiant unique", data['iu']),

                const SizedBox(height: 30),

                /// MODIFIER
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Modifier mes informations"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterPage(iu: data['iu']),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// DECONNEXION
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Déconnexion",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180, // ⬅️ plus large = plus d’espace
            child: Text(
              "$label :",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 20), // ⬅️ espace supplémentaire
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: MainLayout.mainColor, // ⬅️ valeur en bleu
              ),
            ),
          ),
        ],
      ),
    );
  }
}
