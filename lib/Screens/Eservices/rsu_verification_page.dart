import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RsuVerificationPage extends StatefulWidget {
  const RsuVerificationPage({super.key});

  @override
  State<RsuVerificationPage> createState() => _RsuVerificationPageState();
}

class _RsuVerificationPageState extends State<RsuVerificationPage> {
  bool isLoading = true;
  Map<String, dynamic>? rsuData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyRsu();
  }

  Future<void> _verifyRsu() async {
    try {
      // 🔹 Sécurisation SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final uniqueId = prefs.getString('identifiant_unique') ?? '123456789012';

      debugPrint("RSU ID: $uniqueId");

      // 🔹 Simulation API
      await Future.delayed(const Duration(seconds: 5));

      if (uniqueId == '123456789012') {
        rsuData = {
          "nom": "OUEDRAOGO",
          "prenom": "Aristide",
          "dateInscription": "12/03/2022",
          "statut": "Chef de ménage",
          "codeMenage": "MN-458921",
        };
      } else {
        errorMessage = "Vous n'êtes pas dans le Registre Social Unique";
      }
    } catch (e, stack) {
      debugPrint("RSU VERIFICATION ERROR: $e");
      debugPrint(stack.toString());
      errorMessage = "Erreur lors de la vérification";
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registre Social Unique")),
      body: Center(
        child: isLoading
            ? _buildLoader()
            : rsuData != null
            ? _buildRsuInfo()
            : _buildError(),
      ),
    );
  }

  // 🔄 Loader
  Widget _buildLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text(
          "Vérification en cours...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ✅ Affichage infos RSU
  Widget _buildRsuInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow("Nom", rsuData!['nom']),
              _infoRow("Prénom", rsuData!['prenom']),
              _infoRow("Date d'inscription", rsuData!['dateInscription']),
              _infoRow("Statut", rsuData!['statut']),
              _infoRow("Code ménage", rsuData!['codeMenage']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }

  // Cas non trouvé
  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        errorMessage ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
