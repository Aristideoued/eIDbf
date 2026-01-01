import 'package:e_id_bf/Screens/login.dart';
import 'package:e_id_bf/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    print('🚀 Début initializeAuth');
    await AuthService.initializeAuth();
    print('✅ Token récupéré');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
