// // profile_wrapper_screen.dart

// import 'package:flutter/material.dart';
// import 'package:frontend/screen/profile.dart';
// import 'auth.dart';
// import '../models/user.dart'; // Assurez-vous d'importer votre modèle User

// class ProfileWrapperScreen extends StatelessWidget {
//   // Simulez l'état de connexion (doit venir d'un gestionnaire d'état réel)
//   final bool isLoggedIn;
//   final User? currentUser; // L'utilisateur connecté ou null

//   const ProfileWrapperScreen({Key? key, required this.isLoggedIn, this.currentUser}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Affiche l'écran de profil si connecté, sinon l'écran d'authentification
//     if (isLoggedIn && currentUser != null) {
//       // NOTE: Si l'utilisateur est connecté, le ProfileScreen ne doit PAS avoir l'AppBar 
//       // car il est déjà dans le Scaffold de la Navigation.
//       return ProfileScreen(user: currentUser!);
//     } else {
//       // Si déconnecté, affiche l'écran de connexion/inscription.
//       // Il est crucial que cet AuthScreen soit dans l'arbre d'widgets
//       // pour pouvoir naviguer après la connexion.
//       return AuthScreen();
//     }
//   }
// }