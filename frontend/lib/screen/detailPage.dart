import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class PropertyDetailPage extends StatefulWidget {
  final int propertyId;

  const PropertyDetailPage({Key? key, required this.propertyId})
    : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? property;
  bool _isLoading = true;
  String? _error;

  // 1. Logique du Favori
  late bool _isFavorite = false; // Initialisation par défaut

  // Récupération sécurisée de l'image
  List<dynamic>? get images => property?['images'];
  String? get imageUrl => (images != null && images!.isNotEmpty)
      ? images![0] // On prend la première image de la liste
      : null;

  final String fallbackImage =
      'assets/maison01.jpg'; // Chemin d'accès à l'image d'asset

  @override
  void initState() {
    super.initState();
    _fetchPropertyDetails();
  }

  // Fonction pour charger les détails du bien via l'API
  Future<void> _fetchPropertyDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Map<String, dynamic> details = await _apiService.getPropertyDetails(
        widget.propertyId,
      );

      if (mounted) {
        setState(() {
          property = details;
          _isLoading = false;
          // Initialisation de _isFavorite à partir des données de l'API
          _isFavorite = property!['isFavorite'] ?? false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // 2. Fonction pour basculer le favori
  Future<void> _toggleFavorite() async {
    // Si property est null (erreur de chargement), on ne fait rien
    if (property == null) return;

    // Optimistic UI update
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      // Assurez-vous que cette fonction existe et prend l'ID
      final newStatus = await _apiService.toggleFavoriteStatus(
        widget.propertyId,
      );

      if (mounted && newStatus != _isFavorite) {
        setState(() {
          _isFavorite = newStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        // Rollback en cas d'erreur
        setState(() {
          _isFavorite = !_isFavorite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: Impossible de mettre à jour le favori."),
          ),
        );
      }
    }
  }

  // 3. Widget pour afficher l'image (réseau ou asset)
  Widget _buildPropertyImage(String finalImageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: finalImageUrl.startsWith('http')
          ? Image.network(
              finalImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            )
          : Image.asset(
              finalImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Text('Erreur Asset: $finalImageUrl')),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String finalImageUrl = imageUrl ?? fallbackImage;
    // --- Fonction de formatage (Optionnel, mais recommandé) ---
    String formatPrice(dynamic price) {
      if (price == null) {
        return 'N/A';
      }

      // Convertit en type numérique (gestion des Decimal de Prisma qui arrivent souvent en String)
      final numPrice = num.tryParse(price.toString());

      if (numPrice == null) {
        return 'N/A';
      }

      // Utilise la locale française qui utilise l'espace (ou un point/virgule selon la région)
      final formatter = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: 'FCFA',
        decimalDigits: 0, // Pas de décimales pour les prix immobiliers
      );

      // Applique le formatage (ex: 75 000 000 FCFA)
      return formatter.format(numPrice);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Bouton de contact vendeur
          MaterialButton(
            onPressed: () {
              // Action pour l'icône de personne (profil/contact du vendeur)
            },
            color: Colors.white,
            shape: CircleBorder(),
            child: Icon(Icons.person, color: AppConfig.primaryColor),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Erreur de chargement: $_error'))
          : property == null
          ? Center(child: Text('Aucun détail trouvé.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Bloc Image et Favori (Stack)
                  Container(
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // L'image elle-même
                        _buildPropertyImage(finalImageUrl),

                        // Bouton Favori
                        Positioned(
                          top: 5,
                          right: 0,
                          child: MaterialButton(
                            onPressed: _toggleFavorite,
                            color: Colors.white,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.favorite,
                              size: 24,
                              color: _isFavorite
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Affichage des données
                  Text(
                    property!['title'] ?? 'Titre Inconnu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix:',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppConfig.primaryColor,
                        ),
                      ),
                      Text(
                        // 💡 Appel à la fonction de formatage
                        formatPrice(property!['price']),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adresse: ',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      Text(
                        '${property!['address'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // chambres
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.bed,
                                  size: 28,
                                  color: AppConfig.primaryColor,
                                ),
                              ],
                            ),
                            // SizedBox(height: 2),
                            Text(
                              '${property!['rooms'] ?? 0}',
                              style: TextStyle(fontSize: 14),
                            ),
                            // SizedBox(height: 2),
                            Text(
                              'Chambres',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bains
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.bathroom_rounded,
                                  size: 28,
                                  color: AppConfig.primaryColor,
                                ),
                              ],
                            ),
                            Text(
                              '${property!['bathrooms'] ?? 0}',
                              style: TextStyle(fontSize: 14),
                            ),
                            // SizedBox(height: 2),
                            Text(
                              'Bains',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // surface
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.space_dashboard_rounded,
                                  size: 28,
                                  color: AppConfig.primaryColor,
                                ),
                              ],
                            ),
                            // SizedBox(height: 2),
                            Text(
                              '${property!['surface'] ?? 0} m²',
                              style: TextStyle(fontSize: 14),
                            ),
                            // SizedBox(height: 2),
                            Text(
                              'Surface',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // annee
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 28,
                                  color: AppConfig.primaryColor,
                                ),
                              ],
                            ),
                            Text(
                              '${property!['constructionYear'] ?? 0}',
                              style: TextStyle(fontSize: 14),
                            ),
                            // SizedBox(height: 2),
                            Text(
                              'Année',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    property!['description'] ??
                        'Pas de description disponible.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 40),
                  Column(
                    children: [
                      Text(
                        'Le vendeur',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                property!['seller']!['name'] ??
                                    'Vendeur Inconnu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              color: AppConfig.primaryColor,
                              shape: CircleBorder(),
                              child: Icon(
                                Icons.phone_callback_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConfig.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Action pour contacter le vendeur
                          },
                          child: Text(
                            'Plannifier une visite',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
