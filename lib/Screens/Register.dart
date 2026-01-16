import 'package:e_id_bf/Screens/Home.dart';
import 'package:e_id_bf/Screens/login.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:e_id_bf/services/personne_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  final String? iu; // ⬅️ paramètre optionnel

  const RegisterPage({super.key, this.iu});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final _iuController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _lieuNaissanceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Genre (Select)
  String? _genre;

  bool _isPasswordMatched = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.iu != null && widget.iu!.isNotEmpty) {
      debugPrint("IU fourni : ${widget.iu}");
      _iuController.text = widget.iu!;

      _fetchUserData(widget.iu!);
      // 👉 pré-remplir un champ
      // 👉 adapter le comportement de l’écran
    } else {
      debugPrint("Aucun IU fourni");
    }
  }

  @override
  void dispose() {
    _iuController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _lieuNaissanceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 🔄 Récupération personne par IU
  Future<void> _fetchUserData(String iu) async {
    try {
      setState(() => _isLoading = true);

      final personne = await PersonneService.getByIu(iu);

      if (personne != null) {
        setState(() {
          _nomController.text = personne['nom'] ?? _nomController.text;
          _prenomController.text = personne['prenom'] ?? _prenomController.text;
          _dateNaissanceController.text =
              personne['dateNaissance'] ?? _dateNaissanceController.text;

          // ✅ NE PAS écraser si vide
          final lieuBackend = personne['lieuNaissance'];
          if (lieuBackend != null && lieuBackend.toString().trim().isNotEmpty) {
            _lieuNaissanceController.text = lieuBackend;
          }

          final sexeBackend = personne['sexe'];
          if (sexeBackend == 'Masculin' || sexeBackend == 'Feminin') {
            _genre = sexeBackend;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aucune personne trouvée pour cet identifiant: $iu'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erreur serveur ou réseau')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _validatePasswords() {
    setState(() {
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  /// ✅ Création du compte
  Future<void> _createAccount() async {
    if (!_isPasswordMatched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await PersonneService.registerPersonne(
        iu: _iuController.text.trim(),
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        dateNaissance: _dateNaissanceController.text.trim(),
        lieuNaissance: _lieuNaissanceController.text.trim(),
        sexe: _genre ?? '',
        password: _passwordController.text.trim(),
      );

      // print("Response dans register======= " + response.toString());

      if (response.containsKey('id') && response['id'] != null) {
        final bool isEdit = widget.iu != null && widget.iu!.isNotEmpty;

        // ✅ Succès : afficher un message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Compte modifié avec succès !'
                  : 'Compte crée avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // ⏳ Petite pause pour que l'utilisateur voie le message
        await Future.delayed(const Duration(seconds: 2));

        // 🔄 Naviguer vers la page de login
        if (isEdit) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        final bool isEdit = widget.iu != null && widget.iu!.isNotEmpty;

        //  Échec : afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Echec de modification du compte'
                  : 'Échec de la création du compte.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.iu != null && widget.iu!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier mon compte' : 'Créer un Compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// IU
              TextField(
                controller: _iuController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: const InputDecoration(
                  labelText: 'Identifiant unique (12 chiffres)',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.length == 12) {
                    _fetchUserData(value);
                  }
                },
              ),
              const SizedBox(height: 20),

              _readonlyField('Nom', _nomController),
              _readonlyField('Prénom', _prenomController),
              _readonlyField('Date de naissance', _dateNaissanceController),

              /// Lieu naissance (éditable)
              TextField(
                controller: _lieuNaissanceController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de naissance',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// 🔽 GENRE SELECT
              DropdownButtonFormField<String>(
                value: _genre,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.transgender),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Masculin', child: Text('Masculin')),
                  DropdownMenuItem(value: 'Feminin', child: Text('Féminin')),
                ],
                onChanged: (value) {
                  setState(() => _genre = value);
                },
              ),
              const SizedBox(height: 20),

              /// Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: _isPasswordMatched
                      ? null
                      : 'Mots de passe différents',
                ),
                onChanged: (_) => _validatePasswords(),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? 'Modifier mon compte' : 'Créer un Compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Champ readonly helper
  Widget _readonlyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[300],
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
