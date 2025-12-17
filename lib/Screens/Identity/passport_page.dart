import 'package:flutter/material.dart';

class PassportPage extends StatelessWidget {
  const PassportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon passport")),
      body: const Center(
        child: Text("Page PASSPORT", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
