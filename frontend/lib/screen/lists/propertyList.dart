// reusable_list_screen.dart (ou similaire)

import 'package:flutter/material.dart';
import 'package:frontend/screen/detailPage.dart';
// import 'package:frontend/screen/property_detail_page.dart';
import 'package:frontend/screen/widget/appartCard.dart';
// import 'package:frontend/services/api_service.dart'; // Pour l'instance d'ApiService

// Définition du type de la fonction de récupération pour plus de clarté
typedef FetchDataFunction = Future<List<dynamic>> Function();

class PropertyListScreen extends StatefulWidget {
  // Le paramètre clé : la fonction à exécuter pour charger les données
  final FetchDataFunction fetchFunction;

  const PropertyListScreen({Key? key, required this.fetchFunction})
    : super(key: key);

  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<dynamic> properties = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      if (!isLoading) {
        setState(() => isLoading = true);
      }

      // *** UTILISATION DU PARAMÈTRE DE FONCTION ***
      final data = await widget.fetchFunction();
      // *******************************************

      if (mounted) {
        setState(() {
          properties = data;
          isLoading = false;
          error = null;
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
      // Utilisation de Scaffold car c'est maintenant un écran complet
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Erreur : $error", textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    onPressed: fetchProperties,
                    child: Text("Réessayer"),
                  ),
                ],
              ),
            )
          : properties.isEmpty
          ? Center(child: Text("Aucun bien disponible"))
          : RefreshIndicator(
              onRefresh: fetchProperties,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  final int propertyId = property['id'] as int;

                  // Note: La clé 'isFavorite' et 'id' doivent être garanties par l'API
                  final Map<String, dynamic> homeData = {
                    'id': propertyId,
                    'isFavorite': property['isFavorite'] ?? false,
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
                  };

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
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
