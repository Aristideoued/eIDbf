import 'package:e_id_bf/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🔹 QR CODE ÉMETTEUR
class QrCodePage extends StatelessWidget {
  final String token;

  const QrCodePage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    // 🔹 Génération du lien complet avec token
    final String qrLink =
        '${ApiConfig.baseUrl}/api/v1/qrcodes/verify?token=$token';

    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Officiel")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: qrLink, // QR = lien complet
              version: QrVersions.auto,
              size: 220,
            ),
            const SizedBox(height: 20),
            const Text(
              "Scannez ce code pour vérifier l'identité",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            /* const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scanner un QR Code"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerPage()),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}

/// 🔹 PAGE SCANNER
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner QR Code")),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (loading) return;

              final String? link = capture.barcodes.first.rawValue;
              if (link == null) return;

              setState(() => loading = true);

              final uri = Uri.tryParse(link);
              if (uri != null) {
                if (!await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Impossible d'ouvrir le lien"),
                    ),
                  );
                }
              }

              setState(() => loading = false);
            },
          ),

          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}



/*class QrCodePage extends StatelessWidget {
  final String token;

  const QrCodePage({super.key, required this.token});

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
*/