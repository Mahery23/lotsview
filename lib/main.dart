import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/result_controller.dart';
import 'services/api_result_services.dart'; // Importer ApiService pour la gestion des résultats
import 'views/login_page.dart';         // Page de connexion
import 'views/recherche_view.dart';    // Vue de recherche
import 'views/result_display_screen.dart';  // Affichage des résultats

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService resultApiService = ApiService('http://192.168.230.13:93/api/Preview/previews'); // Service pour les résultats

    return MultiProvider(
      providers: [
        // Fournir ApiService (résultats) à ResultController
        ChangeNotifierProvider(create: (context) => ResultController(resultApiService)),
        // Fournir ApiService (résultats) à AuthController (si nécessaire)
        ChangeNotifierProvider(create: (context) => AuthController(resultApiService)),
      ],
      child: MaterialApp(
        title: 'Application Résultats',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login', // Définir la page d'entrée
        routes: {
          '/login': (context) => const LoginPage(), // Page de connexion
          '/recherche': (context) => const RecherchePage(), // Vue de recherche
          '/result': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

            return ResultDisplayScreen(
              dateDebut: args['dateDebut'],
              dateFin: args['dateFin'],
              enseignes: List<String>.from(args['enseignes'] ?? []),
            );
          },
        },
      ),
    );
  }
}
