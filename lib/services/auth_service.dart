import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> authenticate(String username, String password) async {
    final url = Uri.parse('http://192.168.230.13:93/api/AuthManagement/Login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Stocker le token
      await _secureStorage.write(key: "bearer_token", value: token);

      return token;
    }
    return null;
  }
}
