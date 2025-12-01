import 'package:flutter/material.dart';
// Vos imports :
import 'package:frontend/config/colorParams.dart';
import 'package:frontend/screen/lists/propertyList.dart'; // Contient PropertyListScreen
import 'package:frontend/screen/widget/categorie.dart'; // Contient Categorie
import 'package:frontend/services/api_service.dart'; // Contient ApiService

// --- Modèle pour structurer les données de catégorie ---
class CategoryItem {
  final String titre;
  final IconData icon;
  final String apiPath; // Ex: 'type=appartement' ou 'all'

  CategoryItem({
    required this.titre,
    required this.icon,
    required this.apiPath,
  });
}
// ----------------------------------------------------

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({super.key});

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  final ApiService apiService = ApiService();

  // État 1 : Stocke le chemin API de la catégorie sélectionnée (initialement 'all')
  String _selectedCategoryPath = 'all';

  // État 2 : La clé qui force le rebuild de PropertyListScreen
  // La clé change quand la catégorie change, ce qui force le FutureBuilder à refaire le fetch.
  Key _listKey = const ValueKey('all');

  // Tableau des catégories
  final List<CategoryItem> _categories = [
    CategoryItem(titre: 'Tous', icon: Icons.all_inclusive, apiPath: 'all'),
    CategoryItem(
      titre: 'Appartement',
      icon: Icons.apartment,
      apiPath: 'APPARTEMENT',
    ),
    CategoryItem(titre: 'Maison', icon: Icons.house, apiPath: 'MAISON'),
    CategoryItem(titre: 'Villa', icon: Icons.villa, apiPath: 'VILLA'),
    CategoryItem(titre: 'Terrains', icon: Icons.terrain, apiPath: 'TERRAIN'),
    CategoryItem(titre: 'Bureaux', icon: Icons.business, apiPath: 'BUREAU'),
    CategoryItem(titre: 'Magasins', icon: Icons.shop, apiPath: 'MAGASIN'),
  ];

  // Fonction appelée lorsqu'on clique sur une catégorie
  void _selectCategory(String apiPath) {
    if (_selectedCategoryPath == apiPath) return;

    // Met à jour l'état et force le rafraîchissement (rebuild)
    setState(() {
      _selectedCategoryPath = apiPath;
      // **LA CLÉ : Mettre à jour la clé**
      _listKey = ValueKey(apiPath);
    });
  }

  // Fonction dynamique passée au PropertyListScreen
  Future<List<dynamic>> _fetchPropertiesForCategory() {
    if (_selectedCategoryPath == 'all') {
      return apiService.getProperties();
    } else {
      return apiService.getFilteredProperties(type: _selectedCategoryPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ImmoTogo',
          style: TextStyle(
            color: AppConfig.primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const Icon(Icons.home_work, color: AppConfig.primaryColor),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Column(
        children: [
          // Section de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Gestion des catégories en scroll horizontal
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category.apiPath == _selectedCategoryPath;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Categorie(
                    titre: category.titre,
                    icon: category.icon,
                    isSelected: isSelected,
                    onTap: () {
                      _selectCategory(category.apiPath);
                    },
                  ),
                );
              },
            ),
          ),

          // Liste des logements en vedettes (Liste dynamique)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PropertyListScreen(
                // **LA CLÉ : Nous passons la clé pour forcer le rebuild**
                key: _listKey,
                fetchFunction: _fetchPropertiesForCategory,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
