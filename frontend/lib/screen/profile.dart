import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';
import 'package:frontend/screen/authProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lecture de l'état via Provider
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Si l'utilisateur est inattenduement nul ici (devrait être géré par le wrapper),
    // on affiche un message d'erreur ou on redirige.
    if (user == null) {
      return Center(child: Text("Erreur: Profil non disponible."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20),
          // Icône de profil ou avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          // Nom de l'utilisateur
          Text(
            user.name ?? 'Utilisateur ImmoTogo',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          //
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                  backgroundColor: MaterialStateProperty.all(
                    AppConfig.primaryColor,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: AppConfig.primaryColor),
                    ),
                  ),
                ),
                child: Text(
                  "Modifier le profil",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Carte d'informations
          Text(
            'Inventaires',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // 1 case : mes maisons
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // Style optionnel pour étendre la largeur du bouton, s'il est dans un Column
                      padding: EdgeInsets.zero,
                      elevation:
                          0, // Important pour supprimer les marges internes du bouton
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. On donne la majorité de l'espace restant au ListTile
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.home_work,
                              color: Colors.blueGrey,
                            ),
                            title: Text('Mes Maisons'),
                            // Ajoutez le trailing ici, si possible, au lieu d'une Icon séparée
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // 2 case : support
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // Style optionnel pour étendre la largeur du bouton, s'il est dans un Column
                      padding: EdgeInsets.zero,
                      elevation:
                          0, // Important pour supprimer les marges internes du bouton
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. On donne la majorité de l'espace restant au ListTile
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.support,
                              color: Colors.blueGrey,
                              size: 20,
                            ),
                            title: Text('Supports'),
                            // Ajoutez le trailing ici, si possible, au lieu d'une Icon séparée
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vous pouvez ajouter d'autres informations ici (adresse, rôle, etc.)
                ],
              ),
            ),
          ),

          //
          const SizedBox(height: 40),
          Text(
            'Preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // Style optionnel pour étendre la largeur du bouton, s'il est dans un Column
                      padding: EdgeInsets.zero,
                      elevation:
                          0, // Important pour supprimer les marges internes du bouton
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. On donne la majorité de l'espace restant au ListTile
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.home_work,
                              color: Colors.blueGrey,
                            ),
                            title: Text('Mes Maisons'),
                            // Ajoutez le trailing ici, si possible, au lieu d'une Icon séparée
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // Style optionnel pour étendre la largeur du bouton, s'il est dans un Column
                      padding: EdgeInsets.zero,
                      elevation:
                          0, // Important pour supprimer les marges internes du bouton
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. On donne la majorité de l'espace restant au ListTile
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.home_work,
                              color: Colors.blueGrey,
                            ),
                            title: Text('Mes Maisons'),
                            // Ajoutez le trailing ici, si possible, au lieu d'une Icon séparée
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vous pouvez ajouter d'autres informations ici (adresse, rôle, etc.)
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Bouton de Déconnexion
          ElevatedButton.icon(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    // Appel à la fonction de déconnexion du Provider
                    await authProvider.logout();
                    // Le Provider notifiera les auditeurs, ce qui reconstruira le Wrapper pour afficher AuthScreen
                  },
            icon: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.logout),
            label: Text(
              authProvider.isLoading
                  ? 'Déconnexion en cours...'
                  : 'Déconnexion',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
