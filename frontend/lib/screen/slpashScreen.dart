import 'package:flutter/material.dart';
import 'package:frontend/navigationBar.dart'; // la page principale
import 'dart:async'; // Nécessaire pour le Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Appelle la fonction de navigation après 3 secondes (3000 millisecondes)
    Timer(const Duration(milliseconds: 4000), () {
      // Navigue vers la page d'accueil et retire toutes les autres routes de la pile
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const Navigation(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mettez ici la couleur de fond qui correspond à votre application
      backgroundColor: Colors.blue, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // **1. Votre Icône/Logo**
            const Icon(
              Icons.home_work, // Exemple d'icône
              color: Colors.white,
              size: 100.0,
            ),
            const SizedBox(height: 20),
            // **2. Votre Texte**
            const Text(
              "ImmoTogo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            // **3. Indicateur de Chargement (Optionnel)**
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}