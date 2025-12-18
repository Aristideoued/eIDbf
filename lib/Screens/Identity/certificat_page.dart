import 'package:flutter/material.dart';

class CertificatPage extends StatelessWidget {
  const CertificatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Certificat de Nationalité"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.2),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 25),
                _title(),
                const SizedBox(height: 20),
                _referenceNumber(),
                const SizedBox(height: 25),
                _bodyText(),
                const SizedBox(height: 30),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= EN-TÊTE =================
  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "COUR D’APPEL",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("de : OUAGADOUGOU"),
              SizedBox(height: 8),
              Text(
                "Tribunal de Grande Instance",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("de : OUAHIGOUYA"),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text("BURKINA FASO", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("La Patrie ou la Mort, Nous Vaincrons"),
          ],
        ),
      ],
    );
  }

  // ================= TITRE =================
  Widget _title() {
    return Column(
      children: [
        const Center(
          child: Text(
            "CERTIFICAT DE NATIONALITÉ BURKINABÈ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Image.asset(
            "assets/flag_bf.png",
            height: 45,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  // ================= NUMÉRO =================
  Widget _referenceNumber() {
    return Center(
      child: Text(
        "N° 2700 / 2015",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // ================= CORPS DU TEXTE =================
  Widget _bodyText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "LE PRÉSIDENT DU TRIBUNAL DE GRANDE INSTANCE DE OUAHIGOUYA\n"
          "CERTIFIE AU VU DES PIÈCES SUIVANTES :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),

        _Paragraph(
          "1° Extrait d’acte de naissance numéro 191 du 15 novembre 2001, délivré "
          "par l’Officier de l’état civil de Sabcé, attestant que OUEDRAOGO Aristide, "
          "fils de OUEDRAOGO Bernard et de OUEDRAOGO Joséphine, est né à Boussouma/Sabcé "
          "le trente-un décembre mille neuf cent quatre-vingt-quinze (31/12/1995).",
        ),

        SizedBox(height: 12),

        _Paragraph(
          "2° Extrait d’acte de naissance numéro 956 du 22 décembre 1983, délivré "
          "par l’Officier de l’état civil de Tikaré, attestant que OUEDRAOGO Bernard, "
          "père de OUEDRAOGO Aristide, est né à Horé en mille neuf cent cinquante-six (1956).",
        ),

        SizedBox(height: 16),

        _Paragraph(
          "QUE OUEDRAOGO Aristide, fils de OUEDRAOGO Bernard et de OUEDRAOGO Joséphine, "
          "né à Boussouma/Sabcé le trente-un décembre mille neuf cent quatre-vingt-quinze "
          "(31/12/1995), possède la nationalité Burkinabè en vertu de l’article 144 "
          "du CODE DES PERSONNES ET DE LA FAMILLE comme étant né au Burkina Faso d’un père qui y est lui-même né.",
        ),
      ],
    );
  }

  // ================= PIED DE PAGE =================
  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Text("Fait et délivré au Palais de Justice"),
        SizedBox(height: 4),
        Text(
          "Ouahigouya, le 07 juillet 2015",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        Text("Le Président du Tribunal"),
        SizedBox(height: 40),

        Text("Gildas ZOURE", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ================= PARAGRAPHE =================
class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black),
    );
  }
}
