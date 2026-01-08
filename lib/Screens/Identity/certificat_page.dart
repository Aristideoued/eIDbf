import 'package:e_id_bf/services/document_service.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';

class CertificatPage extends StatefulWidget {
  const CertificatPage({super.key});
  @override
  State<CertificatPage> createState() => _CertificatPageState();
}

class _CertificatPageState extends State<CertificatPage> {
  Map<String, dynamic>? certificatData;
  String? errorMessage;
  bool isLoading = true;
  // URL ou bytes pour Image.network

  Future<Map<String, dynamic>> _loadCertificat() async {
    return DocumentService.getDocument(
      typeLibelle: 'Certificat de nationalité',
      iu: await PersonneService.getSavedIu(),
    );
  }

  String formatDate(String? date) {
    if (date == null) return '--- --- ----';

    final cleaned = date.trim();
    if (cleaned.isEmpty) return '--- --- ----';

    DateTime? d;

    try {
      // Cas ISO standard
      d = DateTime.parse(cleaned);
    } catch (_) {
      return '--- --- ----';
    }

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final day = d.day.toString().padLeft(2, '0');
    final month = months[d.month - 1];
    final year = d.year.toString();

    return "$day $month $year";
  }

  @override
  void initState() {
    super.initState();

    _loadCertificat()
        .then((data) {
          setState(() {
            print(data.toString());
            certificatData = data;
            isLoading = false;
            errorMessage = null;
          });
        })
        .catchError((e) {
          setState(() {
            isLoading = false;
            certificatData = null;
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
        appBar: AppBar(title: const Text("Certificat de Nationalité")),
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
            children: [
              Text(
                "COUR D’APPEL",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("de : ${certificatData?['lieuEtablissement']}"),
              SizedBox(height: 8),
              Text(
                "Tribunal de Grande Instance",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("de : ${certificatData?['lieuEtablissement']}"),
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
        "N° ${certificatData?['numero']?['reference']}",
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
    final contenu = certificatData?['contenu'] as String? ?? '';
    final lieu = (certificatData?['lieuEtablissement'] as String? ?? '')
        .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LE PRÉSIDENT DU TRIBUNAL DE GRANDE INSTANCE DE $lieu\n"
          "CERTIFIE AU VU DES PIÈCES SUIVANTES :",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contenu
              .split(';')
              .where((p) => p.trim().isNotEmpty)
              .map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _Paragraph('${p.trim()};'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ================= PIED DE PAGE =================
  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Fait et délivré au Palais de Justice"),
        SizedBox(height: 4),
        Text(
          "${certificatData?['lieuEtablissement']}, le ${formatDate(certificatData?['dateDelivrance'])}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        Text("Le Président du Tribunal"),
        SizedBox(height: 40),

        /* Text("Gildas ZOURE", style: TextStyle(fontWeight: FontWeight.bold)),*/
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
