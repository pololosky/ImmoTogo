import 'package:flutter/material.dart';
import 'package:frontend/screen/widget/appartCard.dart';

class ParametrePage extends StatelessWidget {
  ParametrePage({super.key});
  final List homesList = [
    {
      'title': 'Grand Royal Hotel',
      'adresse': 'Wembley, London',
      'chambre':4,
      'toilette':3,
      'surface':250,
      'image': 'assets/villa01.jpg',
      'prix': 75000000,
    },
    {
      'title': 'Queen Hotel',
      'adresse': 'Wembley, London',
      'chambre':4,
      'toilette':3,
      'surface':250,
      'image': 'assets/villa01.jpg',
      'prix': 56000000,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
            children: homesList.map((home) {
              return HomeCards(home);
            }).toList(),
          ),
            ],
          ),
        )
      ),
    );
  }
}