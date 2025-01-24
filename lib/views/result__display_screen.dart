import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/result_controller.dart';
import '../models/result_model.dart';



class ResultDisplayScreen extends StatelessWidget {
  const ResultDisplayScreen({super.key});

  // Méthode pour obtenir la couleur associée à chaque enseigne
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

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final resultController = Provider.of<ResultController>(context);

    // Rediriger l'utilisateur vers l'écran de connexion si le token est null
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
          "17/01/2025",
          "23/01/2025",
          "REDER,TDP,TDP LAD,TRAD,VLM,RVI,FRL,FRL LAD,FRL CHQ,ALIM,LFG,RED LAD", // Enseignes spécifiées
        ),
        builder: (context, snapshot) {
          // Afficher l'erreur si la récupération des résultats échoue
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          
          // Si aucun résultat n'est trouvé
          if (snapshot.connectionState == ConnectionState.done && resultController.results.isEmpty) {
            return const Center(child: Text("Aucun résultat trouvé"));
          }
          
          // Affichage des résultats
          return ListView.builder(
            itemCount: resultController.results.length,
            itemBuilder: (context, index) {
              final result = resultController.results[index];
              return _buildResultCard(result); // Utiliser la méthode _buildResultCard pour chaque résultat
            },
          );
        },
      ),
    );
  }

Widget _buildResultCard(ResultModel result) {
  return Card(
    color: getColorForEnseigne(result.title), // Appliquer directement la couleur depuis la méthode
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