import 'package:flutter/material.dart';

class DemandePage extends StatelessWidget {
  const DemandePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes demandes")),
      body: const Center(
        child: Text("Page demandes", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
