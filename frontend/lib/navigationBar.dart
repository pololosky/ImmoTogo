import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
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
    const FavorisPage(),
   // const ParametrePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppConfig.primaryColor,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        // c'est sa qui empeche les icon selectionner de bouger
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Parametre',
          ),


        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}