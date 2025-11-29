import 'package:http/http.dart' as http;
// import 'dart:io';

Future<void> testConnection() async {
  print('🧪 === TEST DE CONNEXION ===');
  
  // Liste des URLs à tester
  final urls = [
    'http://localhost:3000',
    'http://10.0.2.2:3000',
    'http://127.0.0.1:3000',
  ];
  
  for (var url in urls) {
    print('\n📡 Test de: $url');
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 3),
      );
      print('✅ Succès! Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      return; // Si ça marche, on s'arrête
    } catch (e) {
      print('❌ Échec: $e');
    }
  }
  
  print('\n⚠️ Aucune URL ne fonctionne!');
}