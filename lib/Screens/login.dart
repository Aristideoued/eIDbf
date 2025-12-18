import 'package:e_id_bf/Screens/Home.dart';
import 'package:e_id_bf/Screens/Register.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        247,
        248,
        249,
        1,
      ), // Background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/logo.png', height: 100, width: 100),
                SizedBox(height: 40),

                // Identifiant unique
                TextField(
                  controller: _usernameController,
                  keyboardType:
                      TextInputType.number, // Autoriser seulement les chiffres
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Limite à des chiffres
                    LengthLimitingTextInputFormatter(
                      12,
                    ), // Limite à 12 caractères
                  ],
                  decoration: InputDecoration(
                    labelText: 'Identifiant unique',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Mot de passe
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Bouton de connexion
                ElevatedButton(
                  onPressed: () {
                    // Action pour se connecter
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainLayout()),
                    );
                    /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Couleur de fond du bouton
                    foregroundColor:
                        Colors.white, // Couleur du texte (ici blanc)
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Se connecter'),
                ),
                SizedBox(height: 20),

                // Texte cliquable pour créer un compte
                GestureDetector(
                  onTap: () {
                    // Action pour aller à la page de création de compte
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
