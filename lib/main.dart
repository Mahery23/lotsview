import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/result_controller.dart';
import 'services/api_service.dart'; // Importer ApiService pour la gestion des résultats
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
    final ApiService apiService = ApiService('http://192.168.230.13:93/api');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ResultController(apiService)),
        ChangeNotifierProvider(create: (context) => AuthController(apiService)),
      ],
      child: MaterialApp(
        title: 'Application Résultats',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/recherche': (context) => const RecherchePage(),
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

