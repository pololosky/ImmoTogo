import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
<<<<<<< HEAD
import 'package:frontend/screen/lists/propertyList.dart';
import 'package:frontend/services/api_service.dart';
=======
>>>>>>> 68bcf3db36ffe2cd69ecbc11e8fa18dc882b7d8a

class FavorisPage extends StatelessWidget {
  FavorisPage({super.key});
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: TextStyle(color: AppConfig.primaryColor, fontSize: 26,fontWeight: FontWeight.w700),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),

      body: Center(
        child: Container(
          child: PropertyListScreen(
            // On passe la fonction qui récupère TOUS les biens
            fetchFunction: apiService.getFavoritesProperties,
          ),
=======
       appBar: AppBar(
        title: const Text(
          'Favoris',
          style: TextStyle(color: AppConfig.primaryColor),
>>>>>>> 68bcf3db36ffe2cd69ecbc11e8fa18dc882b7d8a
        ),
      ),

    );
  }
}
// Flora est passée par ici