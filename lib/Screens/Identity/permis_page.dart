import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/services/document_service.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';

class PermisPage extends StatefulWidget {
  const PermisPage({super.key});

  @override
  State<PermisPage> createState() => _PermisPageState();
}

class _PermisPageState extends State<PermisPage> {
  Map<String, dynamic>? permisData;
  String? errorMessage;
  bool isLoading = true;
  String? _photoUrl; // URL ou bytes pour Image.network

  Future<Map<String, dynamic>> _loadPermis() async {
    return DocumentService.getDocument(
      typeLibelle: 'Permis de conduire',
      iu: await PersonneService.getSavedIu(),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '--/--/----';
    final d = DateTime.tryParse(date);
    if (d == null) return '--/--/----';
    return "${d.day.toString().padLeft(2, '0')}/"
        "${d.month.toString().padLeft(2, '0')}/"
        "${d.year}";
  }

  @override
  void initState() {
    super.initState();

    _loadPermis()
        .then((data) {
          setState(() {
            print(data.toString());
            permisData = data;
            isLoading = false;
            errorMessage = null;
            _photoUrl =
                '${ApiConfig.baseUrl}${ApiConfig.documentPhoto(data["id"].toString())}';
          });
        })
        .catchError((e) {
          setState(() {
            isLoading = false;
            permisData = null;
            errorMessage = "Aucun document trouvé";
          });
          // ignore: avoid_print
          print('ERREUR CNIB => $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Permis de conduire")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /* ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Retour"),
              ),*/
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Mon permis")),
      body: Center(
        child: Container(
          width: 390,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Stack(
            children: [
              /// 1️⃣ IMAGE DE FOND
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/bgpermis.jpg", fit: BoxFit.cover),
                ),
              ),

              /// 2️⃣ TITRE EN HAUT
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Burkina Faso    PERMIS DE CONDUIRE",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                      shadows: const [
                        Shadow(color: Colors.white, blurRadius: 2),
                      ],
                    ),
                  ),
                ),
              ),

              /// 3️⃣ LOGO + DEVISE À DROITE
              Positioned(
                top: 30,
                right: 15,
                child: Column(
                  children: [
                    Image.asset("assets/logo.png", width: 45, height: 45),

                    const SizedBox(height: 2),

                    const Text(
                      "La Patrie ou la Mort,\nNous Vaincrons",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8), // margin bottom
                  ],
                ),
              ),

              /// 4️⃣ PHOTO
              Positioned(
                left: 15,
                top: 50,
                child: Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
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

              /// 5️⃣ NUMÉRO CNIB (AU-DESSUS DU NOM)
              Positioned(
                left: 100,
                top: 45,
                child: Text(
                  "N° ${permisData?['numero']?['reference']}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              /// 6️⃣ NOM
              Positioned(
                left: 100,
                top: 70,
                child: Text(
                  "Nom : ${permisData?['personne']?['nom']}",
                  style: TextStyle(fontSize: 15),
                ),
              ),

              /// 7️⃣ PRÉNOMS
              Positioned(
                left: 100,
                top: 90,
                child: Text(
                  "Prénoms : ${permisData?['personne']?['prenom']}",
                  style: TextStyle(fontSize: 15),
                ),
              ),

              /// 8️⃣ DATE & LIEU DE NAISSANCE
              Positioned(
                left: 100,
                top: 120,
                child: Text(
                  "Né(e) le : ${formatDate(permisData?['personne']?['dateNaissance'])} à ${permisData?['personne']?['lieuNaissance']}",
                  style: TextStyle(fontSize: 15),
                ),
              ),

              /// 9️⃣ SEXE
              /* Positioned(
                left: 100,
                top: 120,
                child: const Text("Sexe : M", style: TextStyle(fontSize: 11)),
              ),*/

              /// 🔟 TAILLE
              /* Positioned(
                right: 15,
                top: 120,
                child: const Text(
                  "Taille : 176 cm",
                  style: TextStyle(fontSize: 11),
                ),
              ),*/

              /// 1️⃣1️⃣ DATES DE VALIDITÉ
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  "Délivrée : ${permisData?['dateDelivrance']}\nExpire : ${permisData?['dateExpiration']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
