import 'package:flutter/material.dart';  // Importation de la bibliothèque Flutter pour l'interface utilisateur
import 'views/recherche_view.dart';    // Importation de la vue de recherche (RecherchePage)

void main() {
  // La fonction `main` est le point d'entrée de l'application Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  // Constructeur de MyApp avec la clé de widget (pour gérer l'arbre des widgets)

  @override
  Widget build(BuildContext context) {
    // La méthode `build` retourne un widget MaterialApp, qui est la base de l'application Flutter

    return MaterialApp(
      title: 'Application de suivi des lots',
      home: RecherchePage(),  // RecherchePage est défini comme la page d'acceuil
    );
  }
}
