import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/services/document_service.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';

class PassportPage extends StatefulWidget {
  const PassportPage({super.key});

  @override
  State<PassportPage> createState() => _PassportPageState();
}

class _PassportPageState extends State<PassportPage> {
  Map<String, dynamic>? passportData;
  String? errorMessage;
  bool isLoading = true;
  String? _photoUrl; // URL ou bytes pour Image.network

  Future<Map<String, dynamic>> _loadPassport() async {
    return DocumentService.getDocument(
      typeLibelle: 'Passport',
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

  String formatSexe(String? sexe) {
    if (sexe == null) return '';
    if (sexe.toLowerCase() == 'masculin') return 'M';
    if (sexe.toLowerCase() == 'feminin') return 'F';
    return '';
  }

  @override
  void initState() {
    super.initState();

    _loadPassport()
        .then((data) {
          setState(() {
            print(data.toString());
            passportData = data;
            isLoading = false;
            errorMessage = null;
            _photoUrl =
                '${ApiConfig.baseUrl}${ApiConfig.documentPhoto(data["id"].toString())}';
          });
        })
        .catchError((e) {
          setState(() {
            isLoading = false;
            passportData = null;
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
        appBar: AppBar(title: const Text("Passeport")),
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
      appBar: AppBar(title: const Text("Mon Passeport"), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth * 0.98,
              height: constraints.maxHeight * 0.75, // 🔥 MAX HAUTEUR
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade700),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  _backgroundImage(),
                  _passportTitle(),
                  _passportFooter(),
                  _countryTitle(),
                  _photo(),
                  _passportTexts(),
                  _mrz(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= IMAGE DE FOND =================
  Widget _backgroundImage() {
    return Positioned.fill(
      child: Image.asset('assets/bgpass.jpg', fit: BoxFit.cover),
    );
  }

  // ================= TITRE PASSPORT =================
  Widget _passportTitle() {
    return const Positioned(
      left: 14,
      top: 10,
      child: Text(
        "PASSPORT",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _passportFooter() {
    return Positioned(
      left: 14,
      top: 40,
      bottom: 12, // 👈 espace depuis le bas
      child: Text(
        passportData?['numero']?['reference'],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.black,
        ),
      ),
    );
  }

  // ================= BURKINA FASO =================
  Widget _countryTitle() {
    return const Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          "                          BURKINA FASO",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // ================= PHOTO =================
  Widget _photo() {
    return Positioned(
      left: 14,
      top: 60,
      width: 120,
      height: 150,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.4),
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
    );
  }

  // ================= TEXTES =================
  Widget _passportTexts() {
    return Positioned(
      left: 150,
      top: 60,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            _LabelValue(
              "Nom / Surname",
              (passportData?['personne']?['nom']).toUpperCase(),
            ),
            _LabelValue(
              "Prénoms / Given names",
              (passportData?['personne']?['prenom']).toUpperCase(),
            ),
          ),
          const SizedBox(height: 14),

          _row(
            _LabelValue(
              "Nationalité / Nationality",
              (passportData?['personne']?['nationalite']).toUpperCase(),
            ),
            _LabelValue(
              "Sexe / Sex",
              formatSexe(passportData?['personne']?['sexe']),
            ),
          ),
          const SizedBox(height: 14),

          _row(
            _LabelValue(
              "Date de naissance / Date of birth",
              formatDate(passportData?['personne']['dateNaissance']),
            ),
            _LabelValue(
              "Lieu de naissance / Place of birth",
              (passportData?['personne']['lieuNaissance']).toUpperCase(),
            ),
          ),
          const SizedBox(height: 18),

          _row(
            _ImportantDate(
              "Date de délivrance / Date of issue",
              formatDate(passportData?['dateDelivrance']),
            ),
            _ImportantDate(
              "Date d’expiration / Date of expiry",
              formatDate(passportData?['dateExpiration']),
            ),
          ),
          const SizedBox(height: 20),

          _LabelValue(
            "Autorité de délivrance / Issuing authority",
            (passportData?["autorite"]?["libelle"]).toUpperCase(),
          ),
        ],
      ),
    );
  }

  // ================= MRZ =================
  Widget _mrz() {
    return Positioned(
      left: 14,
      right: 14,
      bottom: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1.6, color: Colors.black),
          SizedBox(height: 6),
          Text(
            "P<BFA${(passportData?['personne']?['nom'] as String?)?.toUpperCase()}<<${(passportData?['personne']?['prenom'] as String?)?.toUpperCase()}<<<<<<<<<<<<<<<<<<<<",
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
              letterSpacing: 1.5,
              color: Colors.black,
            ),
          ),
          Text(
            "${passportData?['numero']?['reference']}<BFA9512313M2507156<<<<<<<<<<<<<<06",
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
              letterSpacing: 1.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ROW HELPER =================
  Widget _row(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}

// ================= LABEL + VALUE =================
class _LabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValue(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ================= DATE IMPORTANTE =================
class _ImportantDate extends StatelessWidget {
  final String label;
  final String value;

  const _ImportantDate(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white.withOpacity(0.92),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
