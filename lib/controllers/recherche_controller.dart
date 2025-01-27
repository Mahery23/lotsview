// Importation des modèles nécessaires pour l'enseigne et le service API
import 'package:lotview/models/enseigne.dart';
import 'package:lotview/services/api_service.dart';

// Classe contrôleur pour la recherche des enseignes
class RechercheController {
  final ApiService apiService = ApiService(); // Instance du service API pour récupérer les données des enseignes

  // Méthode asynchrone pour récupérer les enseignes depuis l'API via le service
  Future<List<Enseigne>> fetchEnseignes() async {
    // Appel de la méthode fetchEnseignes du service API et retour des résultats
    return await apiService.fetchEnseignes();
  }
}
