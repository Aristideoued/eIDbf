import 'package:flutter/material.dart';

class CNIBPage extends StatelessWidget {
  const CNIBPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ma CNIB")),
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
                  child: Image.asset("assets/bg.jpg", fit: BoxFit.cover),
                ),
              ),

              /// 2️⃣ TITRE EN HAUT
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "CARTE NATIONALE D’IDENTITÉ BURKINABÈ",
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
                        fontSize: 8,
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
                  child: Image.asset("assets/photo.jpeg", fit: BoxFit.cover),
                ),
              ),

              /// 5️⃣ NUMÉRO CNIB (AU-DESSUS DU NOM)
              Positioned(
                left: 100,
                top: 45,
                child: const Text(
                  "N° 10030700102006180",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),

              /// 6️⃣ NOM
              Positioned(
                left: 100,
                top: 60,
                child: const Text(
                  "Nom : OUEDRAOGO",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),

              /// 7️⃣ PRÉNOMS
              Positioned(
                left: 100,
                top: 80,
                child: const Text(
                  "Prénoms : ARISTIDE",
                  style: TextStyle(fontSize: 12),
                ),
              ),

              /// 8️⃣ DATE & LIEU DE NAISSANCE
              Positioned(
                left: 100,
                top: 100,
                child: const Text(
                  "Né(e) le : 31/12/1995 à BOUSSOUMA",
                  style: TextStyle(fontSize: 11),
                ),
              ),

              /// 9️⃣ SEXE
              Positioned(
                left: 100,
                top: 120,
                child: const Text("Sexe : M", style: TextStyle(fontSize: 11)),
              ),

              /// 🔟 TAILLE
              Positioned(
                right: 15,
                top: 120,
                child: const Text(
                  "Taille : 176 cm",
                  style: TextStyle(fontSize: 11),
                ),
              ),

              /// 1️⃣1️⃣ DATES DE VALIDITÉ
              Positioned(
                left: 15,
                bottom: 15,
                child: const Text(
                  "Délivrée : 08/04/2024\nExpire : 07/04/2034",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
