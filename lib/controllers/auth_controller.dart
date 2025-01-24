import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService;
  String? _token;

  AuthController(this._apiService);

  String? get token => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final fetchedToken = await _apiService.authenticate(username, password);
    if (fetchedToken != null) {
      _token = fetchedToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', fetchedToken); // Sauvegarder le token
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Supprimer le token
    notifyListeners();
  }
}
/*import 'package:flutter/material.dart';
import '../services/api_services.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService;
  String? _token;

  AuthController(this._apiService);

  String? get token => _token;

  Future<bool> login(String username, String password) async {
    final fetchedToken = await _apiService.authenticate(username, password);
    if (fetchedToken != null) {
      _token = fetchedToken;
      notifyListeners(); // Informe les listeners qu'un changement a eu lieu (si nécessaire)
      return true; // Connexion réussie
    }
    return false; // Connexion échouée
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
*/