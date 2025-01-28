import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/result_controller.dart';
import 'services/api_result_services.dart'; // Importer ResultApiService pour AuthController
import 'services/api_service.dart'; // Importer EnseigneApiService pour ResultController
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
    final ResultApiService resultApiService = ResultApiService('');
    final EnseigneApiService apiService = EnseigneApiService();

    return MultiProvider(
      providers: [
        // Fournir ResultApiService à AuthController
        ChangeNotifierProvider(create: (context) => AuthController(resultApiService)),
        // Fournir EnseigneApiService à ResultController
        ChangeNotifierProvider(create: (context) => ResultController(apiService)),
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
              dateDebut: args?['dateDebut'],
              dateFin: args?['dateFin'],
              enseignes: List<String>.from(args?['enseignes'] ?? []),
            );
          },
        },
      ),
    );
  }
}
