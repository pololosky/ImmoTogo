import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
// import 'package:frontend/screen/auth.dart';
import 'package:frontend/screen/profileWrapperScreen.dart';
// import 'package:frontend/screen/lists/favLists.dart';
// import 'package:frontend/screen/users_screen.dart';
import 'screen/acceuil.dart';
import 'screen/favoris.dart';
//import 'screen/parametre.dart';
import 'screen/recherche.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AcceuilPage(),
    const RecherchePage(),
    FavorisPage(),
    const ProfileWrapperScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppConfig.primaryColor,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        // c'est sa qui empeche les icon selectionner de bouger
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Acceuil'),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),

          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Navigation.dart (Le fichier que vous avez fourni)

// import 'package:flutter/material.dart';
// import 'package:frontend/config/colorParams.dart';
// import 'package:frontend/screen/profileWrapper.dart';
// // import 'package:frontend/screen/auth.dart'; // Plus besoin d'AuthScreen directement ici
// import 'screen/acceuil.dart';
// import 'screen/favoris.dart';
// import 'screen/recherche.dart';
// import '../models/user.dart'; // NOUVEL IMPORT (pour la simulation)

// // **********************************************
// // ATTENTION: SIMULATION D'ÉTAT GLOBALE SANS GESTIONNAIRE D'ÉTAT
// // **********************************************
// // En réalité, ces données devraient venir d'un provider/bloc.
// final User _mockUser = User(
//   id: 7,
//   email: 'follivios@gmail.com',
//   name: 'kaleb',
//   phone: '0123456789',
//   createdAt: DateTime.now(),
//   updatedAt: DateTime.now(),
// );
// // Initialisez isLoggedIn à false par défaut dans une vraie application.
// bool _isUserLoggedIn = true;
// // **********************************************

// class Navigation extends StatefulWidget {
//   const Navigation({super.key});

//   @override
//   State<Navigation> createState() => _NavigationState();
// }

// class _NavigationState extends State<Navigation> {
//   int _selectedIndex = 0;

//   // 1. Utilisez une liste de widgets dynamique si l'état change
//   late final List<Widget> _widgetOptions = <Widget>[
//     AcceuilPage(),
//     const RecherchePage(),
//     FavorisPage(),
//     // Utilisez le Wrapper pour gérer le switch Auth/Profile
//     ProfileWrapperScreen(
//       isLoggedIn: _isUserLoggedIn, // État de connexion
//       currentUser: _mockUser, // Données utilisateur
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _widgetOptions.elementAt(
//         _selectedIndex,
//       ), // Simplifié Container(child: ...)
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: AppConfig.primaryColor,
//         unselectedItemColor: Colors.grey[600],
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Acceuil'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
