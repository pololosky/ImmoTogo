import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';

class Categorie extends StatelessWidget {
  final String titre;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const Categorie({
    super.key,
    required this.titre,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // Utilise AppConfig.primaryColor si sélectionné
          color: isSelected ? AppConfig.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppConfig.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              titre,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
