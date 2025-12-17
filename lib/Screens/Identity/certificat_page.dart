import 'package:flutter/material.dart';

class CertificatPage extends StatelessWidget {
  const CertificatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon certificat")),
      body: const Center(
        child: Text("Page CERTIFICAT", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
