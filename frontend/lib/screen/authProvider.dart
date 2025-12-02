import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import '../models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Pour la persistance

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  // État dérivé : Vrai si _currentUser n'est pas nul
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Tente de charger l'utilisateur stocké au démarrage (si vous utilisez SharedPreferences)
    // _loadUserFromStorage();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --- LOGIC AUTHENTIFICATION ---

  Future<User> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _apiService.login(email, password);
      _currentUser = user;
      _apiService.setToken(user.token as String);
      // _saveUserToStorage(user); // Sauvegarde du token pour persistance
      notifyListeners(); // Notifie tous les auditeurs (Navigation, Wrapper)
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<User> signUp(
      {required String email,
      required String password,
      String? name,
      String? phone}) async {
    _setLoading(true);
    try {
      final user = await _apiService.signUp(
          email: email, password: password, name: name, phone: phone);
      _currentUser = user;
      _apiService.setToken(user.token as String);
      // _saveUserToStorage(user); // Sauvegarde du token
      notifyListeners();
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.logout();
      _currentUser = null;
      _apiService.setToken('');
      // _removeUserFromStorage(); // Efface la persistance
      notifyListeners(); // Force la reconstruction (affichage de AuthScreen)
    } catch (e) {
      // Si l'API de déconnexion échoue, on déconnecte quand même localement
      print('Échec de l\'appel API de déconnexion, déconnexion locale forcée: $e');
      _currentUser = null;
      _apiService.setToken('');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // --- LOGIC PERSISTANCE (Optionnel) ---

  // Future<void> _saveUserToStorage(User user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_token', user.token);
  //   // Sauvegarder d'autres infos si nécessaire
  // }
  
  // Future<void> _loadUserFromStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('user_token');
  //   if (token != null) {
  //     // Tenter de rafraîchir ou valider le token auprès du serveur
  //     // Pour l'exemple, nous allons juste simuler un utilisateur avec le token
  //     _currentUser = User(id: 'restored-id', email: 'restored@example.com', token: token);
  //     _apiService.setToken(token);
  //     notifyListeners();
  //   }
  // }
  
  // Future<void> _removeUserFromStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('user_token');
  // }
}