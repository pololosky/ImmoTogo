import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/// Service pour gérer les appels API
class ApiService {
  // URL de base de l'API
  // Pour émulateur Android: http://10.0.2.2:3000/api
  // Pour émulateur iOS: http://localhost:3000/api
  // Pour device physique: http://VOTRE_IP:3000/api
  static const String baseUrl = 'http://192.168.1.77:3000/api';

  /// Headers par défaut pour les requêtes JSON
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  // ============ AUTHENTIFICATION ============

  /// Inscription d'un nouvel utilisateur
  /// 
  /// Paramètres:
  /// - [email]: Email de l'utilisateur (obligatoire)
  /// - [password]: Mot de passe (obligatoire)
  /// - [name]: Nom de l'utilisateur (optionnel)
  /// - [phone]: Numéro de téléphone (optionnel)
  /// 
  /// Retourne l'utilisateur créé
  Future<User> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      print('📝 Inscription en cours pour: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: _headers,
            body: json.encode({
              'email': email,
              'password': password,
              'name': name,
              'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Inscription réussie');
        return User.fromJson(data['user']);
      } else if (response.statusCode == 409) {
        // Email déjà utilisé
        throw Exception('Cet email est déjà utilisé');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      print('Erreur inscription: $e');
      rethrow;
    }
  }

  /// Connexion d'un utilisateur existant
  /// 
  /// Paramètres:
  /// - [email]: Email de l'utilisateur
  /// - [password]: Mot de passe
  /// 
  /// Retourne l'utilisateur connecté
  Future<User> login(String email, String password) async {
    try {
      print('🔐 Connexion en cours pour: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: _headers,
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Connexion réussie');
        return User.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de la connexion');
      }
    } catch (e) {
      print('❌ Erreur connexion: $e');
      rethrow;
    }
  }

  

  // ============ UTILISATEURS ============

  /// Récupère tous les utilisateurs
  Future<List<User>> getUsers() async {
    try {
      print('📡 Récupération des utilisateurs...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/users'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ ${data.length} utilisateurs récupérés');
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des utilisateurs');
      }
    } catch (e) {
      print('❌ Erreur: $e');
      rethrow;
    }
  }

  /// Récupère un utilisateur par son ID
  Future<User> getUserById(int id) async {
    try {
      print('📡 Récupération de l\'utilisateur #$id...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/users/$id'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Utilisateur récupéré');
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else {
        throw Exception('Erreur lors de la récupération de l\'utilisateur');
      }
    } catch (e) {
      print('❌ Erreur: $e');
      rethrow;
    }
  }

  /// Met à jour les informations d'un utilisateur
  Future<User> updateUser({
    required int id,
    String? name,
    String? phone,
  }) async {
    try {
      print('📝 Mise à jour de l\'utilisateur #$id...');

      final response = await http
          .put(
            Uri.parse('$baseUrl/users/$id'),
            headers: _headers,
            body: json.encode({
              'name': name,
              'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Utilisateur mis à jour');
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      print('❌ Erreur: $e');
      rethrow;
    }
  }

  // ============ PROPRIÉTÉS (BIENS) ============

  /// Récupère la liste de tous les biens immobiliers
  Future<List<dynamic>> getProperties() async {
    try {
      print('📡 Récupération des propriétés...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/properties'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code properties: ${response.statusCode}');

      if (response.statusCode == 200) {
        // On décode le JSON
        final List<dynamic> data = json.decode(response.body);
        print('✅ ${data.length} propriétés récupérées');
        return data;
      } else {
        throw Exception('Erreur ${response.statusCode}: Impossible de récupérer les biens');
      }
    } catch (e) {
      print('❌ Erreur propriétés: $e');
      rethrow; // On renvoie l'erreur pour que l'UI puisse l'afficher
    }
  }
  
  // recupere les maison
  Future<List<dynamic>> getHousesProperties() async {
    try {
      print('📡 Récupération des propriétés...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/houses'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code properties: ${response.statusCode}');

      if (response.statusCode == 200) {
        // On décode le JSON
        final List<dynamic> data = json.decode(response.body);
        print('✅ ${data.length} propriétés récupérées');
        return data;
      } else {
        throw Exception('Erreur ${response.statusCode}: Impossible de récupérer les biens');
      }
    } catch (e) {
      print('❌ Erreur propriétés: $e');
      rethrow; // On renvoie l'erreur pour que l'UI puisse l'afficher
    }
  }

  // recuperer les biens favories
  Future<List<dynamic>> getFavoritesProperties() async {
    try {
      print('📡 Récupération des propriétés...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/favorites_properties'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code properties: ${response.statusCode}');

      if (response.statusCode == 200) {
        // On décode le JSON
        final List<dynamic> data = json.decode(response.body);
        print('✅ ${data.length} propriétés récupérées');
        return data;
      } else {
        throw Exception('Erreur ${response.statusCode}: Impossible de récupérer les biens');
      }
    } catch (e) {
      print('❌ Erreur propriétés: $e');
      rethrow; // On renvoie l'erreur pour que l'UI puisse l'afficher
    }
  }
  
  /// Met à jour le statut favori d'un bien
  /// Bascule l'état favori d'une propriété par son ID
  /// Retourne le nouvel état
  Future<bool> toggleFavoriteStatus(int propertyId) async {
    try {
      print('📝 Bascule du statut favori pour le bien #$propertyId...');
      
      // La route PUT que nous venons de créer
      final response = await http
          .put(
            Uri.parse('$baseUrl/properties/$propertyId/favorite'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status code toggle favorite: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newStatus = data['isFavorite'] as bool;
        print('✅ Statut favori mis à jour : $newStatus');
        return newStatus;
      } else if (response.statusCode == 404) {
        throw Exception('Bien non trouvé.');
      } else {
        throw Exception('Erreur ${response.statusCode} lors de la mise à jour du favori.');
      }
    } catch (e) {
      print('❌ Erreur toggle favorite: $e');
      rethrow;
    }
  }


}


