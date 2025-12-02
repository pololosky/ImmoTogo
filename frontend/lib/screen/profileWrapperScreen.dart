import 'package:flutter/material.dart';
import 'package:frontend/screen/authProvider.dart';
import 'package:frontend/screen/profile.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

/// Ce widget détermine si l'utilisateur est connecté ou non et affiche l'écran approprié.
class ProfileWrapperScreen extends StatelessWidget {
  const ProfileWrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Écouter l'état de l'authentification (isLoggedIn)
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoggedIn) {
      // Utilisateur connecté : Afficher la page de profil
      // Note: Le ProfileScreen gère déjà l'affichage de l'utilisateur via le Provider.
      return const ProfileScreen();
    } else {
      // Utilisateur déconnecté : Afficher la page de connexion/inscription
      return const AuthScreen();
    }
  }
}