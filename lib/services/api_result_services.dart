import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String?> authenticate(String username, String password) async {
    final url = Uri.parse('$baseUrl/AuthManagement/Login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      print("Erreur de connexion : ${response.body}");
      return null;
    }
  }

  Future<List<dynamic>?> fetchResults(String token, String dateFrom, String dateTo, String enseignes) async {
    final url = Uri.parse('$baseUrl/Preview/previews').replace(queryParameters: {
      "Datefrom": dateFrom,
      "Dateto": dateTo,
      "Enseignes": enseignes,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      print("Erreur API : ${response.body}");
      return null;
    }
  }
  
}
