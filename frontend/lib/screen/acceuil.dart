import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
import 'package:frontend/screen/favoris.dart';
import 'package:frontend/screen/widget/appartCard.dart';
import 'package:frontend/screen/widget/categorie.dart';

class AcceuilPage extends StatelessWidget {
  AcceuilPage({super.key});
  final List homesList = [
    {
      'title': 'Grand Royal Hotel',
      'adresse': 'Wembley, London',
      'chambre': 4,
      'toilette': 3,
      'surface': 250,
      'image': 'assets/villa01.jpg',
      'prix': 75000000,
    },
    {
      'title': 'Queen Hotel',
      'adresse': 'Wembley, London',
      'chambre': 4,
      'toilette': 3,
      'surface': 250,
      'image': 'assets/villa01.jpg',
      'prix': 56000000,
    },
    {
      'title': 'King Hotel',
      'adresse': 'Wembley, London',
      'chambre': 4,
      'toilette': 3,
      'surface': 250,
      'image': 'assets/villa01.jpg',
      'prix': 45000000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ImmoTogo',
          style: TextStyle(color: AppConfig.primaryColor),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),

      body: Column(
        children: [
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
                  onPressed: () {
                    // Action pour le bouton de filtre
                  },
                ),
              ],
            ),
          ),
          // Gestion des categories en scroll horizontall
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Categorie(
                  titre: 'Tous',
                  icon: Icons.all_inclusive,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavorisPage()),
                    );
                  },
                ),
                Categorie(
                  titre: 'Appartement',
                  icon: Icons.apartment,
                  onTap: () {},
                ),
                Categorie(titre: 'Maison', icon: Icons.house, onTap: () {}),
                Categorie(titre: 'Villa', icon: Icons.villa, onTap: () {}),
                Categorie(titre: 'Terrains', icon: Icons.terrain, onTap: () {}),
                Categorie(titre: 'Bureaux', icon: Icons.business, onTap: () {}),
                Categorie(titre: 'Magasins', icon:Icons.shop, onTap: () {}),
              ],
            ),
          ),
          // Liste des logements en vedettes
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: homesList.map((home) {
                        return HomeCards(home);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
