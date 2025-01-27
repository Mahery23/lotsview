import 'dart:convert';  // Pour jsonDecode
import 'package:http/http.dart' as http;  // Pour effectuer les requêtes HTTP
import '../models/enseigne.dart';  // Modèle Enseigne

class ApiService {
  final String baseUrl = 'http://192.168.230.13:93/api';

  Future<List<Enseigne>> fetchEnseignes(String token) async {
    final url = Uri.parse('$baseUrl/Preview/enseigneList');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
        final data = decodedResponse['data'];
        if (data is List) {
          return data.map((item) => Enseigne(name: item.toString())).toList();
        } else {
          throw Exception('La clé "data" ne contient pas une liste.');
        }
      } else {
        throw Exception('Réponse malformée : clé "data" manquante.');
      }
    } else {
      throw Exception('Erreur API : ${response.statusCode}');
    }
  }
}
