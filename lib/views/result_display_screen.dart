import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/result_controller.dart';
import '../models/result_model.dart';



class ResultDisplayScreen extends StatelessWidget {
  final DateTime dateDebut;
  final DateTime dateFin;
  final List<String> enseignes;

  const ResultDisplayScreen({
    super.key,
    required this.dateDebut,
    required this.dateFin,
    required this.enseignes,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final resultController = Provider.of<ResultController>(context);

    // Rediriger si l'utilisateur n'est pas connecté
    if (authController.token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultats"),
        actions: [
          TextButton(
            onPressed: () {
              authController.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              "Déconnexion",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: resultController.fetchResults(
          authController.token!,
          dateDebut.toString(),  // Convertir la DateTime en String
          dateFin.toString(),    // Convertir la DateTime en String
          enseignes.join(','),   // Convertir la liste d'enseignes en String séparé par des virgules
        ),
        builder: (context, snapshot) {
          // Gérer les erreurs
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          // Si aucun résultat
          if (snapshot.connectionState == ConnectionState.done && resultController.results.isEmpty) {
            return const Center(child: Text("Aucun résultat trouvé"));
          }

          // Affichage des résultats
          return ListView.builder(
            itemCount: resultController.results.length,
            itemBuilder: (context, index) {
              final result = resultController.results[index];
              return _buildResultCard(result); // Affichage du résultat avec la méthode _buildResultCard
            },
          );
        },
      ),
    );
  }

  // Carte pour afficher chaque résultat
  Widget _buildResultCard(ResultModel result) {
    return Card(
      color: getColorForEnseigne(result.title), // Utilisation de la méthode pour obtenir la couleur de l'enseigne
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Lots/ND en cours", result.lotsEnCours),
                _buildColumn("Lots/ND du jour", result.lotsDuJour),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Traités", result.traite.toString()),
                _buildColumn("Non Traités", result.nonTraite.toString()),
                _buildColumn("Rejet", result.rejet.toString()),
                _buildColumn("Export", result.export.toString()),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Total", result.total.toString()),
                _buildColumn("Reco", result.reco.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire une colonne avec un titre et une valeur
  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Fonction pour récupérer la couleur associée à l'enseigne
  Color getColorForEnseigne(String enseigne) {
    switch (enseigne.toUpperCase()) {
      case "REDER":
        return const Color(0xFF9C27B0);
      case "TDP":
        return const Color(0xFF536DFE);
      case "TDP LAD":
        return const Color(0xFFD50000);
      case "TRAD":
        return const Color(0xFFF9A825);
      case "VLM":
        return const Color(0xFF212121);
      case "RVI":
        return const Color(0xFF33691E);
      case "FRL":
        return const Color(0xFF00897B);
      case "FRL LAD":
        return const Color(0xFF006064);
      case "FRL CHQ":
        return const Color(0xFF1A237E);
      case "ALIM":
        return const Color(0xFF4A148C);
      case "LFG":
        return const Color(0xFF263238);
      case "RED LAD":
        return const Color(0xFF6D4C41);
      default:
        return Colors.grey; // Couleur par défaut
    }
  }



  
}



/*import 'package:flutter/material.dart';
import '../controllers/result_controller.dart';
import '../models/result_model.dart';

class ResultDisplayScreen extends StatelessWidget {
  final ResultController controller = ResultController();

  ResultDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ResultModel> results = controller.fetchMockResults();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retourne à l'écran précédent
          },
        ),
        title: const Text('Résultats'),
        actions: [
          TextButton(
            onPressed: () {
              // Action pour déconnexion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Déconnexion réussie')),
              );
              Navigator.pushReplacementNamed(context, '/login'); // Redirection vers la page de connexion
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(
                color: Color.fromARGB(255, 65, 63, 63),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: results.isEmpty
          ? const Center(child: Text("Aucun résultat à afficher"))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return _buildResultCard(results[index]);
              },
            ),
    );
  }

  Widget _buildResultCard(ResultModel result) {
    return Card(
      color: Color(result.color),
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Lots/ND en cours", result.lotsEnCours),
                _buildColumn("Lots/ND du jour", result.lotsDuJour),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Traités", result.traite.toString()),
                _buildColumn("Non Traités", result.nonTraite.toString()),
                _buildColumn("Rejet", result.rejet.toString()),
                _buildColumn("Export", result.export.toString()),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Total", result.total.toString()),
                _buildColumn("Reco", result.reco.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
*/