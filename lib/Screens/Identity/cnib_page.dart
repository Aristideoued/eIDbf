import 'package:flutter/material.dart';

class CNIBPage extends StatelessWidget {
  const CNIBPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ma CNIB")),
      body: const Center(
        child: Text("Page CNIB", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
