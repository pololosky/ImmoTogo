import 'package:flutter/material.dart';

class Categorie extends StatelessWidget {
  final String titre;
  final IconData icon;
  final VoidCallback onTap;
  const Categorie({super.key, required this.titre, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
         onTap: onTap,
         child: Chip(
           avatar: Icon(icon, size: 20,),
           label: Text(titre),
           ),
      ),

    );
  }
}