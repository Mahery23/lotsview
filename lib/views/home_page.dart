import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatelessWidget {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _logout(BuildContext context) async {
    // Supprimer le token
    await _secureStorage.delete(key: "bearer_token");

    // Rediriger vers la page de connexion
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context); // Appel de la fonction de déconnexion
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Bienvenue sur la page d'accueil !",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
