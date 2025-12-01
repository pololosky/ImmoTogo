import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
// Importer ApiService (Assurez-vous que le chemin est correct)
import 'package:frontend/services/api_service.dart';
import 'package:intl/intl.dart';

class HomeCards extends StatefulWidget {
  final Map homeData;

  // L'ID du bien est essentiel pour l'appel API
  // J'ai ajouté l'ID dans la map dans ton HomePage, assurons-nous qu'il y est.
  // Pour le moment, nous allons l'extraire de homeData pour la simplicité.
  HomeCards(this.homeData);

  @override
  _HomeCardsState createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  // Le statut favori sera géré localement dans ce widget
  late bool _isFavorite;
  final ApiService _apiService = ApiService(); // Instance du service

  @override
  void initState() {
    super.initState();
    // Correction : Assurez-vous que c'est un booléen et traitez le cas null/manquant
    _isFavorite = (widget.homeData['isFavorite'] is bool)
        ? widget.homeData['isFavorite']
        : false; // Par défaut à false si la donnée n'est pas trouvée ou n'est pas un booléen.
  }

  // Fonction pour basculer le statut favori
  Future<void> _toggleFavorite() async {
    final propertyId = widget.homeData['id'] as int;

    // Option 1: Optimistic UI Update (mise à jour instantanée avant l'API)
    // Nous basculons l'état local immédiatement pour une meilleure réactivité
    setState(() {
      _isFavorite = !_isFavorite;
      print('État local basculé à : $_isFavorite'); // 💡 AJOUTEZ CECI
    });

    try {
      // Appel à l'API via le service
      final newStatus = await _apiService.toggleFavoriteStatus(propertyId);

      // Si la réponse de l'API est différente de notre bascule optimiste
      // (par exemple, si l'API a refusé ou si une erreur est survenue mais a été catchée),
      // nous nous assurons que l'état local est synchronisé avec l'API.
      if (mounted && newStatus != _isFavorite) {
        setState(() {
          _isFavorite = newStatus;
        });
      }
    } catch (e) {
      // Si l'appel échoue, on annule l'update optimiste (rollback)
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite; // Revenir à l'état précédent
        });
        // Optionnel : Afficher un message d'erreur à l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: Impossible de mettre à jour le favori."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: widget.homeData['image'].startsWith('http')
                    ? NetworkImage(widget.homeData['image']) as ImageProvider
                    : AssetImage(widget.homeData['image']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: -15,
                  child: MaterialButton(
                    // L'action est ici : appel à la fonction _toggleFavorite
                    onPressed: _toggleFavorite,
                    color: Colors.white,
                    shape: CircleBorder(),
                    // dans la méthode build
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      // 💡 C'est cette ligne qui fait la bascule
                      color: _isFavorite ? Colors.red : Colors.grey[600],
                    ),
                  ),
                ),
                // ... (Le reste du Stack)
                Positioned(
                  top: 15,
                  left: 20,
                  child: Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "A vendre",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ... (Le reste du Column pour les détails)
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.homeData['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_library,
                              size: 12,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.homeData['adresse'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        // Ligne des détails (chambres, toilettes, surface)
                        Row(
                          children: [
                            // 01
                            Row(
                              children: [
                                Icon(
                                  Icons.bed_outlined,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.homeData['chambre'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            //02
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.bathroom_outlined,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.homeData['toilette'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            //03
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.space_dashboard_sharp,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.homeData['surface'].toString() + " m²",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    formatPrice(widget.homeData['prix']),
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
