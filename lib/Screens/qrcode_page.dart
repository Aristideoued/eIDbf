import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String qrData =
        "BULLETIN N°3 CASIER JUDICIAIRE\n"
        "Nom: OUEDRAOGO Aristide\n"
        "Nationalité: Burkinabè\n"
        "Numéro: BUL1L0000382730G24\n"
        "Généré le: 16/07/2024";

    return Scaffold(
      appBar: AppBar(title: const Text("QR Code"), centerTitle: true),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "QR Code Officiel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              QrImageView(data: qrData, version: QrVersions.auto, size: 220),

              const SizedBox(height: 20),

              const Text(
                "Scannez ce code pour vérifier mon identité",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
