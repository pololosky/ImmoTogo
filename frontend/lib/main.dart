import 'package:flutter/material.dart';
import 'package:frontend/screen/authProvider.dart';
// import 'package:frontend/navigationBar.dart';
import 'package:frontend/screen/slpashScreen.dart';
import 'package:provider/provider.dart';
// import 'package:frontend/screen/acceuil.dart';
// import 'navigationBar.dart';


void main() {
  runApp(
    // Utilisez MultiProvider si vous avez plusieurs Providers
    MultiProvider(
      providers: [
        // C'est ici que vous définissez le AuthProvider.
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // Ajoutez d'autres providers ici si nécessaire
        // ChangeNotifierProvider(create: (context) => OtherProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home:  const SplashScreen(),
    );
  }
}