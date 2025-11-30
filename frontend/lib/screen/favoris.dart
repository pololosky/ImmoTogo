import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Favoris',
          style: TextStyle(color: AppConfig.primaryColor),
        ),
      ),

    );
  }
}
// Flora est passée par ici