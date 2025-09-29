import 'package:flutter/material.dart';
import '../utils/theme.dart';

class DemoImages {
  // Widget pour créer une image de profil de démonstration
  static Widget buildProfileImage({
    required String name,
    double size = 50,
    Color? backgroundColor,
  }) {
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final bgColor = backgroundColor ?? AppTheme.primaryBlue;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget pour créer une image de document de démonstration
  static Widget buildDocumentImage({
    required String documentType,
    double width = 200,
    double height = 150,
  }) {
    final color = _getDocumentColor(documentType);
    final icon = _getDocumentIcon(documentType);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            _getDocumentLabel(documentType),
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget pour créer une image de lieu de démonstration
  static Widget buildPlaceImage({
    required String placeName,
    double width = 300,
    double height = 200,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withOpacity(0.8),
            AppTheme.secondaryBlue.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Stack(
        children: [
          // Icône de lieu en arrière-plan
          Positioned(
            top: 20,
            right: 20,
            child: Icon(
              Icons.location_on_rounded,
              size: 40,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Contenu principal
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sénégal',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour créer une image d'activité récente
  static Widget buildActivityImage({
    required IconData icon,
    required Color color,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    );
  }

  // Couleurs pour les types de documents
  static Color _getDocumentColor(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'carte_identite':
        return AppTheme.primaryBlue;
      case 'passeport':
        return AppTheme.successGreen;
      case 'permis_conduire':
        return AppTheme.warningOrange;
      case 'carte_vitale':
        return AppTheme.errorRed;
      case 'carte_etudiant':
        return AppTheme.infoBlue;
      case 'diplome':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.mediumGrey;
    }
  }

  // Icônes pour les types de documents
  static IconData _getDocumentIcon(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'carte_identite':
        return Icons.badge_rounded;
      case 'passeport':
        return Icons.card_membership_rounded;
      case 'permis_conduire':
        return Icons.drive_eta_rounded;
      case 'carte_vitale':
        return Icons.health_and_safety_rounded;
      case 'carte_etudiant':
        return Icons.school_rounded;
      case 'diplome':
        return Icons.school_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  // Labels pour les types de documents
  static String _getDocumentLabel(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'carte_identite':
        return 'Carte d\'identité';
      case 'passeport':
        return 'Passeport';
      case 'permis_conduire':
        return 'Permis de conduire';
      case 'carte_vitale':
        return 'Carte Vitale';
      case 'carte_etudiant':
        return 'Carte étudiant';
      case 'diplome':
        return 'Diplôme';
      default:
        return 'Document';
    }
  }

  // Images de profil par défaut avec noms sénégalais
  static Widget getRandomProfileImage({double size = 50}) {
    final names = ['A', 'F', 'M', 'I', 'K', 'S', 'D', 'N'];
    final colors = [
      AppTheme.primaryBlue,
      AppTheme.successGreen,
      AppTheme.warningOrange,
      AppTheme.errorRed,
      AppTheme.infoBlue,
    ];
    
    final name = names[DateTime.now().millisecondsSinceEpoch % names.length];
    final color = colors[DateTime.now().millisecondsSinceEpoch % colors.length];
    
    return buildProfileImage(
      name: name,
      size: size,
      backgroundColor: color,
    );
  }
}


