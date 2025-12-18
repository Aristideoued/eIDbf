import 'package:flutter/material.dart';

class PassportPage extends StatelessWidget {
  const PassportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text("Aperçu Passeport"), centerTitle: true),
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
          fontSize: 22,
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
          "                    BURKINA FASO",
          style: TextStyle(
            fontSize: 22,
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
        child: Image.asset('assets/photo.jpeg', fit: BoxFit.cover),
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
            const _LabelValue("Nom / Surname", "OUEDRAOGO"),
            const _LabelValue("Prénoms / Given names", "ARISTIDE"),
          ),
          const SizedBox(height: 14),

          _row(
            const _LabelValue("Nationalité / Nationality", "BURKINABE"),
            const _LabelValue("Sexe / Sex", "M"),
          ),
          const SizedBox(height: 14),

          _row(
            const _LabelValue(
              "Date de naissance / Date of birth",
              "31 DEC 1995",
            ),
            const _LabelValue(
              "Lieu de naissance / Place of birth",
              "BOUSSOUMA BAM BFA",
            ),
          ),
          const SizedBox(height: 18),

          // 🔥 DATES IMPORTANTES
          _row(
            const _ImportantDate(
              "Date de délivrance / Date of issue",
              "16 JUL 2020",
            ),
            const _ImportantDate(
              "Date d’expiration / Date of expiry",
              "15 JUL 2025",
            ),
          ),
          const SizedBox(height: 20),

          const _LabelValue(
            "Autorité de délivrance / Issuing authority",
            "DIRECTION GENERALE DE LA POLICE NATIONALE",
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
        children: const [
          Divider(thickness: 1.6, color: Colors.black),
          SizedBox(height: 6),
          Text(
            "P<BFAOUEDRAOGO<<ARISTIDE<<<<<<<<<<<<<<<<<<<<",
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
              letterSpacing: 1.5,
              color: Colors.black,
            ),
          ),
          Text(
            "A3115573<BFA9512313M2507156<<<<<<<<<<<<<<06",
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
