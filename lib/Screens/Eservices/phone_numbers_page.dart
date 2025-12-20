import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumbersPage extends StatefulWidget {
  const PhoneNumbersPage({super.key});

  @override
  State<PhoneNumbersPage> createState() => _PhoneNumbersPageState();
}

class _PhoneNumbersPageState extends State<PhoneNumbersPage> {
  bool isLoading = true;
  Map<String, List<Map<String, dynamic>>>? numbersByNetwork;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumbers();
  }

  Future<void> _loadPhoneNumbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uniqueId = prefs.getString('identifiant_unique') ?? '123456789012';

      // 🔹 Simulation appel API
      await Future.delayed(const Duration(seconds: 4));

      // 🔹 Simulation réponse backend
      if (uniqueId == '123456789012') {
        numbersByNetwork = {
          "Orange": [
            {"number": "07 12 34 56 78", "active": true},
            {"number": "07 98 76 54 32", "active": false},
          ],
          "Moov": [
            {"number": "01 23 45 67 89", "active": true},
          ],
          "Telecel": [
            {"number": "05 11 22 33 44", "active": true},
            {"number": "05 55 66 77 88", "active": false},
          ],
        };
      } else {
        errorMessage = "Aucun numéro associé à cet identifiant";
      }
    } catch (e, stack) {
      debugPrint("PHONE LIST ERROR: $e");
      debugPrint(stack.toString());
      errorMessage = "Erreur lors du chargement des numéros";
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
      appBar: AppBar(title: const Text("Numéros associés")),
      body: isLoading
          ? _buildLoader()
          : numbersByNetwork != null
          ? _buildPhoneList()
          : _buildError(),
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

  // 📱 Liste des numéros groupés
  Widget _buildPhoneList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: numbersByNetwork!.entries.map((entry) {
        return _buildNetworkSection(entry.key, entry.value);
      }).toList(),
    );
  }

  // 🏷️ Section par réseau
  Widget _buildNetworkSection(
    String network,
    List<Map<String, dynamic>> numbers,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              network,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...numbers.map(_buildPhoneItem).toList(),
          ],
        ),
      ),
    );
  }

  // ☎️ Ligne numéro
  Widget _buildPhoneItem(Map<String, dynamic> phone) {
    final bool isActive = phone['active'];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.phone, color: isActive ? Colors.green : Colors.grey),
      title: Text(phone['number'], style: const TextStyle(fontSize: 16)),
      subtitle: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isActive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? "Actif" : "Inactif",
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      trailing: isActive
          ? IconButton(
              icon: const Icon(Icons.block, color: Colors.red),
              tooltip: "Demander désactivation",
              onPressed: () => _confirmDeactivation(phone['number']),
            )
          : null,
    );
  }

  // 🚫 Confirmation désactivation
  void _confirmDeactivation(String number) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Demande de désactivation"),
        content: Text(
          "Voulez-vous demander la désactivation du numéro $number ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Demande envoyée avec succès")),
              );
            },
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  // ❌ Erreur
  Widget _buildError() {
    return Center(
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
