import 'package:flutter/material.dart';

class CasierPage extends StatelessWidget {
  const CasierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text("Casier Judiciaire"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 18),
                _armoirie(),
                const SizedBox(height: 18),
                _title(),
                const SizedBox(height: 22),
                _identitySection(),
                const SizedBox(height: 18),
                _bulletinNumber(),
                const SizedBox(height: 20),
                _condamnationSection(),
                const SizedBox(height: 26),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== HEADER =====================
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BURKINA-FASO",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "La Patrie ou la Mort, Nous Vaicrons",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "MINISTÈRE DE LA JUSTICE",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text("CASIER JUDICIAIRE CENTRAL", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _armoirie() {
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 70, // taille officielle, sobre
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ===================== TITLE =====================
  Widget _title() {
    return Column(
      children: const [
        Text(
          "BULLETIN N°3",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "DU CASIER JUDICIAIRE",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ===================== IDENTITY =====================
  Widget _identitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _InfoLine("Le nommé", "OUEDRAOGO Aristide"),
        SizedBox(height: 6),
        _InfoLine("Fils de", "PORGO Ousmane"),
        _InfoLine("Et de", "OUEDRAOGO Mamounata"),
        SizedBox(height: 10),
        _InfoLine("Né le", "08 décembre 1999 à Ouagadougou"),
        _InfoLine("Domicile", "Ouagadougou"),
        _InfoLine("Nationalité", "Burkinabè"),
        _InfoLine("État civil", "Célibataire"),
        _InfoLine("Profession", "Élève"),
      ],
    );
  }

  // ===================== BULLETIN NUMBER =====================
  Widget _bulletinNumber() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: const Text(
        "N° : BUL1L0000382730G24",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // ===================== CONDAMNATIONS =====================
  Widget _condamnationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CONDAMNATIONS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.2),
          ),
          child: const Center(
            child: Text(
              "NÉANT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Tableau vide comme sur le document
        Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(3),
            3: FlexColumnWidth(3),
            4: FlexColumnWidth(3),
          },
          children: const [
            TableRow(
              children: [
                _TableHeader("Dates\ndes\ncondamnations"),
                _TableHeader("Cours\nou\ntribunaux"),
                _TableHeader("Natures\ndes\ncrimes / délits"),
                _TableHeader("Date ou période\nde commission"),
                _TableHeader("Nature et durée\ndes peines"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ===================== FOOTER =====================
  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Divider(thickness: 1),
        Text(
          "EAN n° 2366 du 10/10/2006 de Ouagadougou",
          style: TextStyle(fontSize: 11),
        ),
        SizedBox(height: 4),
        Text(
          "https://ecasier-judiciaire.gov.bf",
          style: TextStyle(fontSize: 11),
        ),
        SizedBox(height: 4),
        Text(
          "Généré le : 16/07/2024 09:01   |   Expire le : 14/08/2024",
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}

// ===================== SMALL WIDGETS =====================
class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(
            text: "$label : ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
