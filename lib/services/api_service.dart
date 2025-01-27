import 'dart:convert';  // Pour utiliser jsonDecode
import 'package:http/http.dart' as http;  // Pour effectuer les requêtes HTTP
import 'package:lotview/models/enseigne.dart';  // Importation du modèle Enseigne

class ApiService {
  // URL de l'API et Bearer Token
  final String apiUrl = 'http://192.168.230.13:93/api/Preview/enseigneList';
  final String bearerToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IklUUFJPRCIsInN1YiI6IklUUFJPRCIsImp0aSI6IjE3NTdhMmY4LTZkYmMtNGNiOS05ODg3LTEyNDBjOWY1NGVkOCIsIm5iZiI6MTczNzk2MDQxOCwiZXhwIjoxNzM3OTgyMDE4LCJpYXQiOjE3Mzc5NjA0MTh9.Las_FXk5yK5KaosBxfmKY80nqJy0lavpokDNM6uEL_Q';

  // Méthode pour récupérer les enseignes depuis l'API
  Future<List<Enseigne>> fetchEnseignes() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Vérifier si la requête a réussi (status 200)
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        // Vérifier la structure de la réponse
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          final data = decodedResponse['data'];

          // Vérifier si 'data' est une liste de chaînes de caractères
          if (data is List) {
            return data.map((item) => Enseigne(name: item.toString())).toList();
          } else {
            throw Exception('La clé "data" ne contient pas une liste de chaînes');
          }
        } else {
          throw Exception('Réponse malformée : clé "data" manquante');
        }
      } else {
        throw Exception('Échec de la requête : ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      throw Exception('Erreur lors de la récupération des enseignes : $e');
    }
  }
}
