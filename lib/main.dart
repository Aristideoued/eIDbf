import 'package:e_id_bf/Screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DigitalIdentityApp());
}

class DigitalIdentityApp extends StatelessWidget {
  const DigitalIdentityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eIDbf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
