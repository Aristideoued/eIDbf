import 'dart:convert';

import 'package:e_id_bf/config/app_config.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum VerificationMode { none, id, qrcode }

class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key});

  @override
  State<IdentityVerificationPage> createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  VerificationMode _mode = VerificationMode.none;

  final TextEditingController _idController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();
  String? _photoUrl; // URL ou bytes pour Image.network

  Map<String, dynamic>? _result;

  // ================= RECHERCHE PAR ID =================
  void _searchById(String value) {
    if (value.length == 12) {
      // 🔴 À remplacer par ton API
      setState(() {
        _result = {
          "nom": "OUEDRAOGO",
          "prenom": "Aristide",
          "sexe": "Masculin",
          "dateNaissance": "12/04/1995",
        };
      });
    } else {
      setState(() => _result = null);
    }
  }

  Future<void> _fetchUserData(String iu) async {
    try {
      // setState(() => _isLoading = true);

      final personne = await PersonneService.verifyByIu(iu);

      if (personne != null) {
        print("Date du user======>${personne.toString()}");

        setState(() {
          _result = personne;
          _photoUrl =
              '${ApiConfig.baseUrl}/api/v1/personnes/photo/${personne['iu']}';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune personne trouvée pour IU $iu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erreur serveur ou réseau')));
    }
  }

  // ================= RESULT QR =================
  void _onQrScanned(String qrValue) {
    // 🔴 À remplacer par backend (qrValue)
    setState(() {
      _mode = VerificationMode.none;
      _scannerController.stop();
      _result = {
        "nom": "TRAORE",
        "prenom": "Awa",
        "sexe": "Féminin",
        "dateNaissance": "03/08/1998",
      };
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),

      // ================= HEADER =================
      appBar: AppBar(
        title: const Text("Vérification d’identité"),
        centerTitle: true,
        backgroundColor: MainLayout.mainColor,
        elevation: 0,
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _choiceButtons(),
                const SizedBox(height: 24),

                if (_mode == VerificationMode.id) _idInput(),

                if (_result != null) ...[
                  const SizedBox(height: 24),
                  _resultCard(),
                  _documentsSection(),
                ],

                const SizedBox(height: 120),
              ],
            ),
          ),

          if (_mode == VerificationMode.qrcode) _qrScannerOverlay(),
        ],
      ),

      // ================= FOOTER =================
      bottomNavigationBar: Container(height: 90, color: MainLayout.mainColor),
    );
  }

  // ================= CHOIX =================
  Widget _choiceButtons() {
    return Row(
      children: [
        Expanded(
          child: _choiceCard(
            icon: Icons.perm_identity_rounded,
            title: "Identifiant\nunique",
            active: _mode == VerificationMode.id,
            onTap: () {
              setState(() {
                _mode = VerificationMode.id;
                _result = null;
                _idController.clear();
              });
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _choiceCard(
            icon: Icons.qr_code_scanner,
            title: "Scanner\nQR Code",
            active: _mode == VerificationMode.qrcode,
            onTap: () {
              setState(() {
                _mode = VerificationMode.qrcode;
                _result = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _choiceCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: active
              ? MainLayout.mainColor
              : MainLayout.mainColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: active ? Colors.white : MainLayout.mainColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : MainLayout.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT ID =================
  Widget _idInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Identifiant unique (12 chiffres)",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          maxLength: 12,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          onChanged: _fetchUserData,
          decoration: InputDecoration(
            counterText: "",
            hintText: "Ex: 123456789012",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  // ================= QR CAMERA =================
  Widget _qrScannerOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            if (barcode.rawValue != null) {
              _onQrScanned(barcode.rawValue!);
            }
          },
        ),
      ),
    );
  }

  Widget _documentCard(Map<String, dynamic> doc) {
    return Container(
      width: double.infinity, // ✅ pleine largeur
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= PHOTO =================
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${ApiConfig.baseUrl}${ApiConfig.documentPhoto(doc["id"].toString())}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Si l'image ne peut pas être chargée, on met l'image locale
                  return Image.asset("assets/flag_bf.png", fit: BoxFit.cover);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================= INFOS =================
          _docRow("Type", doc["libelle"]),
          _docRow("NIP", doc["nip"]),
          _docRow("Référence", doc["reference"]),
          _docRow("Délivré le", doc["dateDelivrance"]),
          _docRow("Expire le", doc["dateExpiration"]),
          _docRow("Autorité", doc["autorite"]),
          _docRow("Lieu d'établissement", doc["lieuEtablissement"]),
          _docRow("Contenu", doc["contenu"]),
        ],
      ),
    );
  }

  Widget _docRow1(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== LABEL =====
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 13, // 🔹 libellé
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 4),

          // ===== VALEUR =====
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 17, // 🔥 valeur plus grande
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _docRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    // ===== SI c'est le champ "Contenu", on split en paragraphes =====
    if (label.toLowerCase() == "contenu") {
      List<String> paragraphs = value.toString().split(';');

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== LABEL =====
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),

            // ===== PARAGRAPHES =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paragraphs
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        p.trim(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    }

    // ===== AUTRES CHAMPS =====
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentImage(String? contenu) {
    if (contenu == null || contenu.isEmpty) {
      return Image.asset("assets/document_placeholder.jpg", fit: BoxFit.cover);
    }

    // 🔹 Si c’est une URL
    if (contenu.startsWith("http")) {
      return Image.network(
        contenu,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset("assets/document_placeholder.jpg", fit: BoxFit.cover),
      );
    }

    // 🔹 Si c’est du Base64
    try {
      final bytes = base64Decode(contenu);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (_) {
      return Image.asset("assets/document_placeholder.jpg", fit: BoxFit.cover);
    }
  }

  Widget _documentsSection() {
    final List docs = _result?["documentsValides"] ?? [];

    if (docs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          "Aucun document valide",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Documents d'identité",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ListView.builder(
          itemCount: docs.length,
          shrinkWrap: true, // ✅ important
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _documentCard(docs[index]);
          },
        ),
      ],
    );
  }

  // ================= RESULT =================
  // ================= RESULT =================
  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= PHOTO =================
          Container(
            width: 150,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: _photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_photoUrl!),

                      //image: AssetImage("assets/user.jpeg"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage("assets/avatar.jpg"),
                      fit: BoxFit.cover,
                    ),
            ),
            /*child: _result!["photo"] == null
                ? const Icon(Icons.person, size: 48, color: Colors.grey)
                : null,*/
          ),

          const SizedBox(width: 16),

          // ================= INFOS =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row("Identifiant Unique", _result!["iu"]!),
                _row("Nom", _result!["nom"]!),
                _row("Prénom", _result!["prenom"]!),
                _row("Sexe", _result!["sexe"]!),
                _row("Date de naissance", _result!["dateNaissance"]!),
                _row("Lieu de naissance", _result!["lieuNaissance"]!),
                _row("Nationalité", _result!["nationalite"]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
