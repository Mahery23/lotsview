import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<String> login({required String username, required String password}) async {
    if (username.isEmpty || password.isEmpty) {
      return "Veuillez remplir tous les champs";
    }

    try {
      final token = await _authService.authenticate(username, password);

      if (token != null) {
        return "success";
      } else {
        return "Identifiant ou mot de passe incorrect";
      }
    } catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }
}
