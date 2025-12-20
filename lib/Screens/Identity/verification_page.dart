import 'package:e_id_bf/layout/main_layout.dart';
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

  Map<String, String>? _result;

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
          onChanged: _searchById,
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
            width: 90,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: _result!["photo"] == null
                  ? DecorationImage(
                      // image: NetworkImage(_result!["photo"]!),
                      image: AssetImage("assets/user.jpeg"),

                      fit: BoxFit.cover,
                    )
                  : null,
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
                _row("Nom", _result!["nom"]!),
                _row("Prénom", _result!["prenom"]!),
                _row("Sexe", _result!["sexe"]!),
                _row("Date de naissance", _result!["dateNaissance"]!),
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
