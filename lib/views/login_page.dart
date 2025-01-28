import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fournir une URL de base pour l'API
  final ApiService _apiService = ApiService('http://192.168.230.13:93/api'); // Remplace cette URL par celle de ton API

  // Initialisation de LoginController avec l'instance d'ApiService
  late final LoginController _loginController;

  bool _isLoading = false;

  // Le constructeur pour initialiser LoginController avec ApiService
  LoginPageState() {
    _loginController = LoginController(_apiService);
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _loginController.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return; // Vérifie si le widget est toujours monté

    setState(() {
      _isLoading = false;
    });

    if (result == "success") {
      Navigator.pushReplacementNamed(context, '/recherche');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'SAIM Ltd',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 100),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Suivi des lots',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Identifiant',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        onPressed: _login,
                        child: Text(
                          'S\'identifier',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
