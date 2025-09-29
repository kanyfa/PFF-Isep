import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'À propos de l\'application',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // En-tête fixe
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.darkGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=400&h=400&fit=crop&q=80',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.description_rounded,
                          size: 40,
                          color: AppTheme.primaryBlue,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'SenPapier',
                  style: AppTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Retrouvez vos documents perdus',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Contenu fixe
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

            // Description de l'application
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notre Mission',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SenPapier est une application mobile innovante conçue pour aider les citoyens sénégalais à retrouver leurs documents administratifs perdus. Nous connectons les personnes qui ont perdu leurs documents avec celles qui les ont trouvés, créant ainsi une communauté solidaire.',
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumGrey,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Images du Sénégal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notre Sénégal',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Découvrez les lieux emblématiques du Sénégal où notre communauté est active',
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Grille d'images du Sénégal
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildSenegalImage(
                        'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&h=400&fit=crop&q=80',
                        'Dakar',
                        'Capitale du Sénégal',
                      ),
                      _buildSenegalImage(
                        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=400&fit=crop&q=80',
                        'Saint-Louis',
                        'Ville historique',
                      ),
                      _buildSenegalImage(
                        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=600&h=400&fit=crop&q=80',
                        'Thiès',
                        'Ville industrielle',
                      ),
                      _buildSenegalImage(
                        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=600&h=400&fit=crop&q=80',
                        'Kaolack',
                        'Centre commercial',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Types de documents
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents pris en charge',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Grille des types de documents
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      _buildDocumentTypeWithImage(
                        'Carte d\'identité',
                        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=400&fit=crop&q=80',
                        AppTheme.primaryBlue,
                      ),
                      _buildDocumentTypeWithImage(
                        'Passeport',
                        'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&h=400&fit=crop&q=80',
                        AppTheme.successGreen,
                      ),
                      _buildDocumentTypeWithImage(
                        'Carte grise',
                        'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=600&h=400&fit=crop&q=80',
                        AppTheme.warningOrange,
                      ),
                      _buildDocumentTypeWithImage(
                        'Diplôme',
                        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=600&h=400&fit=crop&q=80',
                        AppTheme.infoBlue,
                      ),
                      _buildDocumentTypeWithImage(
                        'Permis de conduire',
                        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=400&fit=crop&q=80',
                        AppTheme.infoBlue,
                      ),
                      _buildDocumentTypeWithImage(
                        'Autres documents',
                        'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&h=400&fit=crop&q=80',
                        AppTheme.mediumGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fonctionnalités
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fonctionnalités principales',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildFeature(
                    Icons.add_circle_outline_rounded,
                    'Déclaration rapide',
                    'Signalez la perte de votre document en quelques minutes',
                    AppTheme.primaryBlue,
                  ),
                  
                  _buildFeature(
                    Icons.search_rounded,
                    'Recherche intelligente',
                    'Trouvez des documents correspondant à vos critères',
                    AppTheme.successGreen,
                  ),
                  
                  _buildFeature(
                    Icons.notifications_rounded,
                    'Notifications instantanées',
                    'Soyez alerté dès qu\'un document correspondant est trouvé',
                    AppTheme.warningOrange,
                  ),
                  
                  _buildFeature(
                    Icons.people_rounded,
                    'Communauté solidaire',
                    'Rejoignez une communauté active et bienveillante',
                    AppTheme.infoBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistiques
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Impact de l\'application',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '500+',
                          'Documents retrouvés',
                          Icons.check_circle_rounded,
                          AppTheme.successGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '1000+',
                          'Utilisateurs actifs',
                          Icons.people_rounded,
                          AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '50+',
                          'Villes couvertes',
                          Icons.location_city_rounded,
                          AppTheme.warningOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '95%',
                          'Taux de satisfaction',
                          Icons.star_rounded,
                          AppTheme.infoBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Comment ça marche
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comment ça marche ?',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildStep(
                    '1',
                    'Signalez la perte',
                    'Décrivez votre document perdu avec des détails précis',
                    Icons.add_alert_rounded,
                  ),
                  
                  _buildStep(
                    '2',
                    'Recherche automatique',
                    'Notre système recherche les correspondances dans la base',
                    Icons.search_rounded,
                  ),
                  
                  _buildStep(
                    '3',
                    'Notification instantanée',
                    'Vous êtes alerté si un document correspondant est trouvé',
                    Icons.notifications_rounded,
                  ),
                  
                  _buildStep(
                    '4',
                    'Récupération',
                    'Contactez la personne qui a trouvé votre document',
                    Icons.handshake_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact et support
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support et contact',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildContactInfo(
                    Icons.email_rounded,
                    'Email',
                    'support@senpapier.sn',
                    AppTheme.primaryBlue,
                  ),
                  
                  _buildContactInfo(
                    Icons.phone_rounded,
                    'Téléphone',
                    '+221 33 323 32 45',
                    AppTheme.successGreen,
                  ),
                  
                  _buildContactInfo(
                    Icons.web_rounded,
                    'Site web',
                    'www.senpapier.sn',
                    AppTheme.warningOrange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Aller à la connexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

            const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeWithImage(String title, String imageUrl, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: color.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_rounded,
                        color: color,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Text(
                  title,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenegalImage(String imageUrl, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppTheme.lightGrey,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.lightGrey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city_rounded,
                        color: AppTheme.primaryBlue,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}