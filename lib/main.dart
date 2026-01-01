import 'package:e_id_bf/Screens/LoaderPage.dart';
import 'package:e_id_bf/Screens/login.dart';
import 'package:e_id_bf/services/auth_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // await AuthService.initializeAuth();
  //WidgetsFlutterBinding.ensureInitialized();
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
      home: LoaderPage(),
    );
  }
}
