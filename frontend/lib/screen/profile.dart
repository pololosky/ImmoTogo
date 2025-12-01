// profile_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart'; // Importez votre modèle User
import 'auth.dart'; // Importez la page d'authentification

class ProfileScreen extends StatelessWidget {
  final User user; // L'utilisateur actuellement connecté

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  // Fonction de déconnexion (à implémenter via votre service d'API/état)
  Future<void> _handleLogout(BuildContext context) async {
    // 1. Appeler l'API/Service pour effacer le token
    // await ApiService().logout();

    // 2. Mettre à jour l'état global (simulé par pushReplacement vers AuthScreen ici)
    // NOTE : En production, cette logique devrait notifier votre gestionnaire d'état.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthScreen()),
      (Route<dynamic> route) => false, // Supprime toutes les routes précédentes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Contenu du profil, inchangé)
              Text(
                'Bienvenue, ${user.name ?? 'Utilisateur'}!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
              if (user.phone != null)
                Text(
                  'Téléphone: ${user.phone}',
                  style: TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () =>
                    _handleLogout(context), // Appel de la déconnexion
                icon: Icon(Icons.logout),
                label: Text('Déconnexion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
