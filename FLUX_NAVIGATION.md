# Flux de Navigation de l'Application Soclose

## Flux Principal (Non connecté)

```
1. Splash Screen (/)
   ↓
2. Page À Propos (/about)
   ↓
3. Page de Connexion (/login)
   ↓
4. Page d'Accueil (/home) - après connexion
```

## Pages Accessibles Après Connexion

### Pages Principales
- **Page d'Accueil** (`/home`) - Tableau de bord principal
- **Profil** (`/profile`) - Gestion du profil utilisateur
- **Messages** (`/messages`) - Système de messagerie

### Pages d'Annonces
- **Déclarer une Perte** (`/declare-loss`) - Signaler un document perdu
- **Rechercher** (`/search`) - Rechercher des documents trouvés
- **Mes Annonces** (`/my-annonces`) - Gérer ses propres annonces
- **Documents Trouvés** (`/found-documents`) - Voir les documents trouvés
- **Historique** (`/annonce-history`) - Historique des annonces
- **Détails d'Annonce** (`/annonce/:id`) - Détails d'une annonce spécifique

### Pages de Notification
- **Notifications** (`/notifications`) - Centre de notifications

### Pages d'Administration (Admin uniquement)
- **Administration** (`/admin`) - Tableau de bord admin
- **Gestion Utilisateurs** (`/admin/users`) - Gérer les utilisateurs
- **Modération Annonces** (`/admin/annonces`) - Modérer les annonces

## Navigation dans la Page À Propos

La page à propos contient maintenant :

### 1. En-tête avec Logo
- Image réelle d'Unsplash représentant des documents
- Titre "SoClose" avec sous-titre

### 2. Section "Notre Mission"
- Description de l'application et de sa mission

### 3. Section "Notre Sénégal" (NOUVEAU)
- Images des principales villes du Sénégal :
  - Dakar (Capitale du Sénégal)
  - Saint-Louis (Ville historique)
  - Thiès (Ville industrielle)
  - Kaolack (Centre commercial)

### 4. Section "Documents Pris en Charge"
- Grille des types de documents supportés
- Icônes colorées pour chaque type

### 5. Section "Fonctionnalités Principales"
- Liste des fonctionnalités avec icônes
- Descriptions détaillées

### 6. Section "Impact de l'Application"
- Statistiques avec cartes colorées
- Métriques d'utilisation

### 7. Section "Comment ça Marche"
- Étapes numérotées du processus
- Guide utilisateur

### 8. Section "Support et Contact"
- Informations de contact
- Coordonnées de support

### 9. Bouton d'Action
- **"Aller à la connexion"** → Redirige vers `/login`

## Boutons de Navigation

### Dans la Page À Propos
- **Bouton Retour** (←) → Retour au Splash Screen (`/`)
- **"Aller à la connexion"** → Page de Connexion (`/login`)

### Dans le Splash Screen
- **"Commencer l'aventure"** → Page À Propos (`/about`)
- **Navigation automatique** (après 1 seconde) → Page À Propos (`/about`)

## Logique de Redirection

### Routes Publiques (Accessibles sans connexion)
- `/` - Splash Screen
- `/about` - Page À Propos
- `/login` - Page de Connexion
- `/register` - Page d'Inscription

### Routes Privées (Nécessitent une connexion)
- Toutes les autres routes redirigent vers `/login` si l'utilisateur n'est pas connecté

### Redirection Post-Connexion
- Si l'utilisateur est connecté et accède à `/login` ou `/register` → Redirection vers `/home`

## Images Utilisées

### Logo Principal
- URL: `https://images.unsplash.com/photo-1586281380349-632531db7ed4`
- Représente des documents administratifs

### Images des Villes Sénégalaises
- URL: `https://images.unsplash.com/photo-1578662996442-48f60103fc96`
- Images optimisées avec paramètres de taille et crop
- Fallback vers icônes en cas d'erreur de chargement

## Améliorations Apportées

1. **Flux de Découverte** : L'utilisateur découvre l'application avant de se connecter
2. **Images Réelles** : Interface plus attrayante avec des images authentiques
3. **Contexte Local** : Images représentant le Sénégal
4. **Navigation Intuitive** : Boutons clairs et flux logique
5. **Gestion d'Erreur** : Fallbacks robustes pour les images
