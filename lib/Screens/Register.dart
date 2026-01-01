/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // Variables pour afficher les données récupérées du backend
  String _firstName = "";
  String _lastName = "";
  String _birthDate = "";
  String _birthPlace = "";
  String _gender = "";

  // Variables pour la validation des mots de passe
  bool _isPasswordMatched = true;

  // Simuler la récupération des données depuis un backend
  void _fetchUserData(String username) async {
    // Simuler un appel à ton backend pour récupérer les infos de l'utilisateur
    await Future.delayed(Duration(seconds: 2)); // Simuler un délai d'appel API

    setState(() {
      _firstName = "John"; // Récupéré depuis le backend
      _lastName = "Doe"; // Récupéré depuis le backend
      _birthDate = "01/01/1990"; // Récupéré depuis le backend
      _birthPlace = "Paris"; // Récupéré depuis le backend
      _gender = "Homme"; // Récupéré depuis le backend
    });
  }

  // Fonction de validation des mots de passe
  void _validatePasswords() {
    setState(() {
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Compte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ Identifiant unique
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
                  labelText: 'Identifiant unique (12 chiffres)',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    // Si l'identifiant unique est saisi, on récupère les données du backend
                    _fetchUserData(value);
                  }
                },
              ),
              SizedBox(height: 20),

              // Champ Nom (grisé)
              TextField(
                controller: TextEditingController(text: _firstName),
                enabled:
                    false, // Désactiver le champ pour qu'il soit en lecture seule
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du label en noir
                    fontWeight: FontWeight.bold, // Mettre le label en gras
                    fontSize: 16, // Taille du label
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white, // Texte des champs grisés en blanc
                    fontSize: 16, // Taille du texte dans les champs grisés
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Champ Prénom (grisé)
              TextField(
                controller: TextEditingController(text: _lastName),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Date de naissance (grisé)
              TextField(
                controller: TextEditingController(text: _birthDate),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Date de naissance',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Lieu de naissance (grisé)
              TextField(
                controller: TextEditingController(text: _birthPlace),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Lieu de naissance',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Genre (grisé)
              TextField(
                controller: TextEditingController(text: _gender),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.transgender),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Champ Confirmation mot de passe
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  errorText: _isPasswordMatched
                      ? null
                      : 'Les mots de passe ne correspondent pas',
                ),
                onChanged: (value) {
                  _validatePasswords();
                },
              ),
              SizedBox(height: 20),

              // Centrer le bouton de création de compte
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_isPasswordMatched) {
                      // Créer le compte (logique de soumission)
                      print('Compte créé avec succès !');
                    }
                  },
                  child: Text('Créer un Compte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:e_id_bf/Screens/login.dart';
import 'package:e_id_bf/main.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // Variables pour afficher les données récupérées du backend
  String _firstName = "";
  String _lastName = "";
  String _birthDate = "";
  String _birthPlace = "";
  String _gender = "";

  // Variables pour la validation des mots de passe
  bool _isPasswordMatched = true;

  bool _isLoading = false;

  // Simuler la récupération des données depuis un backend
  void _fetchUserData(String iu) async {
    try {
      // 🔄 Optionnel : afficher un loader
      setState(() {
        _isLoading = true;
      });

      // Appel au service
      final personne = await PersonneService.getByIu(iu);

      print("Data============" + personne.toString());

      if (personne != null) {
        setState(() {
          _firstName = personne['nom'] ?? '';
          _lastName = personne['prenom'] ?? '';
          _birthDate = personne['dateNaissance'] ?? '';
          _birthPlace = personne['lieuNaissance'] ?? '';
          _gender = personne['sexe'] ?? '';
        });
      } else {
        // Personne non trouvée
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune personne trouvée pour IU $iu')),
        );
      }
    } catch (e) {
      print('Erreur récupération personne : $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur serveur ou réseau')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction de validation des mots de passe
  void _validatePasswords() {
    setState(() {
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  // Fonction pour créer le compte et afficher un message de succès
  Future<void> _createAccount() async {
    if (_isPasswordMatched) {
      // Affichage du message "Compte créé avec succès"

      try {
        /* 
        
        required String nom,
    required String prenom,
    required String lieuNaissance,
    required String genre,
    required String dateNaissance,*/

        final response = await PersonneService.registerPersonne(
          nom: _firstName,
          prenom: _lastName,
          lieuNaissance: _birthPlace,
          sexe: _gender,
          dateNaissance: _birthDate,
          iu: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        print("Response register====== " + response.toString());

        /*if (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Compte créé avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          print("Response dans login " + response.toString());

          // ✅ Connexion OK
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // ❌ Mauvais identifiants
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Echec de creation de compte')),
          );
        }*/
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }

      // Redirection vers la page de login après un délai de 2 secondes
      /* Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });*/
    } else {
      // Affichage d'un message d'erreur si les mots de passe ne correspondent pas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Compte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ Identifiant unique
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
                  labelText: 'Identifiant unique (12 chiffres)',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && value.length == 12) {
                    // Si l'identifiant unique est saisi, on récupère les données du backend
                    _fetchUserData(value);
                  }
                },
              ),
              SizedBox(height: 20),

              // Champ Nom (grisé)
              TextField(
                controller: TextEditingController(text: _firstName),
                enabled:
                    true, // Désactiver le champ pour qu'il soit en lecture seule
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du label en noir
                    fontWeight: FontWeight.bold, // Mettre le label en gras
                    fontSize: 16, // Taille du label
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white, // Texte des champs grisés en blanc
                    fontSize: 16, // Taille du texte dans les champs grisés
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Champ Prénom (grisé)
              TextField(
                controller: TextEditingController(text: _lastName),
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Date de naissance (grisé)
              TextField(
                controller: TextEditingController(text: _birthDate),
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Date de naissance',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Lieu de naissance (grisé)
              TextField(
                controller: TextEditingController(text: _birthPlace),
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Lieu de naissance',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Genre (grisé)
              TextField(
                controller: TextEditingController(text: _gender),
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.transgender),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Champ Confirmation mot de passe
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  errorText: _isPasswordMatched
                      ? null
                      : 'Les mots de passe ne correspondent pas',
                ),
                onChanged: (value) {
                  _validatePasswords();
                },
              ),
              SizedBox(height: 20),

              // Centrer le bouton de création de compte
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _createAccount(); // Appeler la fonction pour créer le compte
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Créer un Compte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
