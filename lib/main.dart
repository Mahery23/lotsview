import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './controllers/auth_controller.dart';
import './controllers/result_controller.dart';
import 'services/api_result_services.dart';
import './views/login_screen.dart';
import './views/result__display_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiService = ApiService('http://192.168.230.13:93/api');
  final authController = AuthController(apiService);

  // Charger le token avant de lancer l'application
  await authController.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider(create: (_) => ResultController(apiService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return MaterialApp(
      title: 'Test API',
      initialRoute: authController.token != null ? '/results' : '/login', // Rediriger selon le token
      routes: {
        '/login': (_) => LoginScreen(),
        '/results': (_) => ResultDisplayScreen(),
      },
    );
  }
}

