import 'package:flutter/material.dart';
import '../services/api_result_services.dart';
import '../models/result_model.dart';

class ResultController with ChangeNotifier {
  final ApiService _apiService;
  List<ResultModel> results = [];

  ResultController(this._apiService);

  Future<void> fetchResults(String token, String dateFrom, String dateTo, String enseignes) async {
    try {
      // Appel à l'API pour récupérer les résultats
      final response = await _apiService.fetchResults(token, dateFrom, dateTo, enseignes);
        if (response != null) {
    results = response.map<ResultModel>((data) => ResultModel.fromJson(data)).toList();
    
    // Log des résultats pour voir si la couleur et le titre sont correctement assignés
    for (var result in results) {
      print("Enseigne: ${result.title}, Couleur: ${result.color}");
    }
    
    notifyListeners();
  }
      // Log la réponse de l'API pour vérifier si elle est valide
      print("Réponse de l'API: $response");
      
      if (response != null && response.isNotEmpty) {
        // Mappage des résultats dans la liste
        results = response.map<ResultModel>((data) => ResultModel.fromJson(data)).toList();
        
        // Log des résultats obtenus pour voir s'ils sont correctement mappés
        print("Résultats obtenus: $results");
        
        // Notifier les observateurs que les résultats ont été mis à jour
        notifyListeners();
      } else {
        // Log pour afficher si la réponse est vide ou nulle
        print("Aucune donnée reçue ou réponse vide.");
      }
    } catch (e) {
      // Log en cas d'erreur dans l'appel API
      print("Erreur lors de la récupération des résultats: $e");
    }

    
  }
}

