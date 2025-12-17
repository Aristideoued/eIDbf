import 'package:flutter/material.dart';

class EservicesPage extends StatelessWidget {
  const EservicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Les services en ligne")),
      body: const Center(
        child: Text("Page ESERVICE", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
