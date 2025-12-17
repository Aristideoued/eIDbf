import 'package:flutter/material.dart';

class CasierPage extends StatelessWidget {
  const CasierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon casier")),
      body: const Center(
        child: Text("Page CASIER", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
