import 'package:flutter/material.dart';
import 'package:frontend/screen/detailPage.dart';
import 'package:frontend/screen/widget/appartCard.dart';
// Assure-toi d'importer ton service correctement
import 'package:frontend/services/api_service.dart';

class FavoriteProperties extends StatefulWidget {
  @override
  _FavoritePropertiesState createState() => _FavoritePropertiesState();
}

class _FavoritePropertiesState extends State<FavoriteProperties> {
  // Instance du service
  final ApiService apiService = ApiService();

  List<dynamic> properties = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  // Cette fonction est maintenant beaucoup plus propre
  Future<void> fetchProperties() async {
    try {
      // On remet isLoading à true si on rappelle la fonction (ex: pull-to-refresh)
      // Si c'est le premier chargement, c'est déjà true via la déclaration
      if (!isLoading) {
        setState(() => isLoading = true);
      }

      // Appel au service
      final data = await apiService.getFavoritesProperties();

      if (mounted) {
        setState(() {
          properties = data;
          isLoading = false;
          error = null; // Reset de l'erreur si succès
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  // Affiche un message d'erreur un peu plus propre
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Une erreur est survenue.\nVérifiez votre connexion serveur.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "Détail: $error",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchProperties,
                    child: Text("Réessayer"),
                  ),
                ],
              ),
            )
          : properties.isEmpty
          ? Center(child: Text("Aucun bien disponible"))
          // RefreshIndicator permet le pull-to-refresh ce qui veut dire que
          // l'utilisateur peut tirer vers le bas pour rafraîchir la liste
          : RefreshIndicator(
              onRefresh: fetchProperties,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  final int propertyId = property['id'] as int;

                  // Adapter les données au format attendu par HomeCards
                  // Note: Idéalement, on créerait un modèle Property.dart
                  // pour faire ce mapping, mais ça fonctionne très bien ici aussi.
                  final Map<String, dynamic> homeData = {
                    // C'EST L'AJOUT CRUCIAL :
                    'id':
                        property['id']
                            as int, // Assurez-vous que l'ID est bien un entier
                    'image':
                        (property['images'] != null &&
                            (property['images'] as List).isNotEmpty)
                        ? property['images'][0]
                        : 'assets/villa01.jpg',
                    'title': property['title'] ?? 'Sans titre',
                    'adresse': '${property['address']}',
                    'chambre': property['rooms'] ?? 0,
                    'toilette': 1,
                    'surface': property['surface'] ?? 0,
                    'prix': property['price'] ?? 0,
                    'favoris': property['isFavorite'] ?? true,
                  };

                  // pour afficher les details
                  return GestureDetector(
                    onTap: () {
                      // NAVIGUER VERS LA PAGE DE DÉTAILS
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // On passe l'ID de la propriété à la page de destination
                          builder: (context) =>
                              PropertyDetailPage(propertyId: propertyId),
                        ),
                      );
                    },
                    child: HomeCards(homeData),
                  );
                },
              ),
            ),
    );
  }
}
