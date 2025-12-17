import 'package:flutter/material.dart';

class PermisPage extends StatelessWidget {
  const PermisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon permis")),
      body: const Center(
        child: Text("Page PERMIS", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
