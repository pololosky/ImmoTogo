import express from 'express';
import cors from 'cors';
import { prisma } from '../lib/prisma';
import bcrypt from 'bcrypt';

const app = express();
const PORT = parseInt(process.env.PORT || '3000', 10);

// Middlewares
app.use(cors());
app.use(express.json());

// ============ ROUTES DE TEST ============

// Route racine pour tester que l'API fonctionne
app.get('/', (req, res) => {
  res.json({ 
    message: 'API ImmoApp - Serveur actif ✅',
    version: '1.0.0'
  });
});


// Route pour récupérer tous les users
app.get('/api/users', async (req, res) => {
  try {
    const users = await prisma.user.findMany({
      include: {
        properties: true, // Inclure les posts si nécessaire
      },
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des utilisateurs' });
  }
});

// ============ ROUTES D'AUTHENTIFICATION ============

/**
 * Inscription d'un nouvel utilisateur
 * POST /api/auth/signup
 * Body: { email, password, name?, phone? }
 */
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password, name, phone } = req.body;

    // Validation des champs obligatoires
    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Email et mot de passe sont obligatoires' 
      });
    }

    // Vérifier si l'email existe déjà
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return res.status(409).json({ 
        error: 'Cet email est déjà utilisé' 
      });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Créer l'utilisateur
    // Note: On stocke le mot de passe hashé dans un champ séparé
    // Il faudra ajouter ce champ au schéma Prisma
    const user = await prisma.user.create({
      data: {
        email,
        name,
        phone,
        password: hashedPassword,
      },
    });

    console.log(`✅ Nouvel utilisateur créé: ${user.email}`);

    // Retourner l'utilisateur (sans le mot de passe)
    res.status(201).json({
      message: 'Utilisateur créé avec succès',
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    console.error('❌ Erreur lors de l\'inscription:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la création du compte' 
    });
  }
});

/**
 * Connexion d'un utilisateur
 * POST /api/auth/login
 * Body: { email, password }
 */
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validation des champs
    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Email et mot de passe sont obligatoires' 
      });
    }

    // Rechercher l'utilisateur
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return res.status(404).json({ 
        error: 'Utilisateur non trouvé' 
      });
    }

    // Vérifier le mot de passe
    // Note: Ceci nécessite le champ password dans le modèle User
    // Pour l'instant, on accepte tout mot de passe (à des fins de test)
    // const isPasswordValid = await bcrypt.compare(password, user.password);
    const isPasswordValid = true; // À REMPLACER par la ligne ci-dessus

    if (!isPasswordValid) {
      return res.status(401).json({ 
        error: 'Mot de passe incorrect' 
      });
    }

    console.log(`✅ Connexion réussie: ${user.email}`);

    // Retourner l'utilisateur (sans le mot de passe)
    res.json({
      message: 'Connexion réussie',
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    console.error('❌ Erreur lors de la connexion:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la connexion' 
    });
  }
});

// ============ ROUTES UTILISATEURS ============

/**
 * Récupère tous les utilisateurs
 * GET /api/users
 */
app.get('/api/users', async (req, res) => {
  try {
    const users = await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        createdAt: true,
        updatedAt: true,
        // Ne pas retourner le mot de passe
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    res.json(users);
  } catch (error) {
    console.error('❌ Erreur lors de la récupération des utilisateurs:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la récupération des utilisateurs' 
    });
  }
});

/**
 * Récupère un utilisateur par son ID
 * GET /api/users/:id
 */
app.get('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const user = await prisma.user.findUnique({
      where: { id: parseInt(id) },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({ 
        error: 'Utilisateur non trouvé' 
      });
    }

    res.json(user);
  } catch (error) {
    console.error('❌ Erreur lors de la récupération de l\'utilisateur:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la récupération de l\'utilisateur' 
    });
  }
});

/**
 * Met à jour un utilisateur
 * PUT /api/users/:id
 * Body: { name?, phone? }
 */
app.put('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone } = req.body;

    // Vérifier que l'utilisateur existe
    const existingUser = await prisma.user.findUnique({
      where: { id: parseInt(id) },
    });

    if (!existingUser) {
      return res.status(404).json({ 
        error: 'Utilisateur non trouvé' 
      });
    }

    // Mettre à jour l'utilisateur
    const updatedUser = await prisma.user.update({
      where: { id: parseInt(id) },
      data: {
        name,
        phone,
      },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    console.log(`✅ Utilisateur #${id} mis à jour`);

    res.json(updatedUser);
  } catch (error) {
    console.error('❌ Erreur lors de la mise à jour:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la mise à jour de l\'utilisateur' 
    });
  }
});

/**
 * Supprime un utilisateur
 * DELETE /api/users/:id
 */
app.delete('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Vérifier que l'utilisateur existe
    const existingUser = await prisma.user.findUnique({
      where: { id: parseInt(id) },
    });

    if (!existingUser) {
      return res.status(404).json({ 
        error: 'Utilisateur non trouvé' 
      });
    }

    // Supprimer l'utilisateur
    await prisma.user.delete({
      where: { id: parseInt(id) },
    });

    console.log(`✅ Utilisateur #${id} supprimé`);

    res.json({ 
      message: 'Utilisateur supprimé avec succès' 
    });
  } catch (error) {
    console.error('❌ Erreur lors de la suppression:', error);
    res.status(500).json({ 
      error: 'Erreur lors de la suppression de l\'utilisateur' 
    });
  }
});

// ============ ROUTES BIENS IMMOBILIERS ============
/**
 * Récupère tous les biens immobiliers publiés (non vendus)
 * GET /api/properties
 */
app.get('/api/properties', async (req, res) => {
  try {
    const properties = await prisma.property.findMany({
      where: {
        published: true,
        isSold: false,
      },
      select: {
        id: true,
        title: true,
        description: true,
        price: true,
        surface: true,
        rooms: true,
        address: true,
        city: true,
        zipCode: true,
        type: true,
        images: true,
        isFavorite:true,
        createdAt: true,
        seller: {
          select: {
            name: true,
            phone: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    res.json(properties);
  } catch (error) {
    console.error('Erreur lors de la récupération des biens:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});
/**
 * Récupère un bien par ID
 * GET /api/properties/:id
 */
app.get('/api/properties/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const property = await prisma.property.findUnique({
      where: { id: parseInt(id) },
      include: {
        seller: {
          select: { name: true, phone: true },
        },
      },
    });

    if (!property) {
      return res.status(404).json({ error: 'Bien non trouvé' });
    }

    res.json(property);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// pour recuperer seulement les biens favoris
app.get('/api/favorites_properties', async (req, res) => {
  try {
    const properties = await prisma.property.findMany({
      where: {
        published: true,
        isSold: false,
        isFavorite: true,
      },
      select: {
        id: true,
        title: true,
        description: true,
        price: true,
        surface: true,
        rooms: true,
        address: true,
        city: true,
        zipCode: true,
        type: true,
        images: true,
        isFavorite:true,
        createdAt: true,
        seller: {
          select: {
            name: true,
            phone: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    res.json(properties);
  } catch (error) {
    console.error('Erreur lors de la récupération des biens:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// pour recuperer seulement les maisons
app.get('/api/houses', async (req, res) => {
  try {
    const properties = await prisma.property.findMany({
      where: {
        published: true,
        isSold: false,
        type: 'MAISON',
      },
      select: {
        id: true,
        title: true,
        description: true,
        price: true,
        surface: true,
        rooms: true,
        address: true,
        city: true,
        zipCode: true,
        type: true,
        images: true,
        isFavorite:true,
        createdAt: true,
        seller: {
          select: {
            name: true,
            phone: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    res.json(properties);
  } catch (error) {
    console.error('Erreur lors de la récupération des biens:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// pour basculer le statut "favori" d'un bien
app.put('/api/properties/:id/favorite', async (req, res) => {
  try {
    const { id } = req.params;

    // 1. Récupérer le bien existant pour connaître son état actuel
    const existingProperty = await prisma.property.findUnique({
      where: { id: parseInt(id) },
      select: { isFavorite: true }, // Seulement besoin de isFavorite
    });

    if (!existingProperty) {
      return res.status(404).json({ error: 'Bien non trouvé' });
    }

    // 2. Basculer l'état (true devient false, false devient true)
    const newFavoriteState = !existingProperty.isFavorite;

    // 3. Mettre à jour le bien
    const updatedProperty = await prisma.property.update({
      where: { id: parseInt(id) },
      data: {
        isFavorite: newFavoriteState,
      },
      select: {
        id: true,
        isFavorite: true,
      },
    });

    console.log(`✅ Bien #${id}: isFavorite basculé à ${newFavoriteState}`);

    res.json(updatedProperty);
  } catch (error) {
    console.error('❌ Erreur lors du basculement du favori:', error);
    res.status(500).json({ error: 'Erreur serveur lors de la mise à jour du favori' });
  }
});

// ============ DÉMARRAGE DU SERVEUR ============

// app.listen(PORT, () => {
//   console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
//   console.log(`📡 API disponible sur http://localhost:${PORT}/api`);
// });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Serveur démarré`);
  console.log(`Local:    http://localhost:${PORT}`);
  console.log(`Réseau:   http://192.168.1.77:${PORT}`);
  console.log(`API:      http://192.168.1.77:${PORT}/api`);
});