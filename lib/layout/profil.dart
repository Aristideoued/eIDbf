import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon profil")),
      body: const Center(
        child: Text("Page profil", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
