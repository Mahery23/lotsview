import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './controllers/auth_controller.dart';
import './services/api_service.dart';
import './views/login_page.dart';
import './views/recherche_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final authController = AuthController(apiService);

  await authController.loadToken();

  runApp(
    ChangeNotifierProvider<AuthController>.value(
      value: authController,
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
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Lots',
      initialRoute: authController.token != null ? '/recherche' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/recherche': (context) => const RecherchePage(),
      },
    );
  }
}
