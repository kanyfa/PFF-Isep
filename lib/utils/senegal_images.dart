import 'package:flutter/material.dart';

class SenegalImages {
  // URLs d'images réelles du Sénégal
  static const Map<String, String> places = {
    'Dakar': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'Place de l\'Indépendance': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=600&fit=crop',
    'Marché Sandaga': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'Aéroport Léopold Sédar Senghor': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=600&fit=crop',
    'Université Cheikh Anta Diop': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'Hôpital Principal': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=600&fit=crop',
    'Gare routière de Dakar': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'Plage de Yoff': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=600&fit=crop',
    'Mosquée de la Divinité': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'Centre commercial Almadies': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=600&fit=crop',
  };

  static const Map<String, String> documents = {
    'carte_identite': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'passeport': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'permis_conduire': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'carte_vitale': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'carte_etudiant': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'diplome': 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
  };

  static const List<String> profiles = [
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=300&h=300&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=300&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&h=300&fit=crop&crop=face',
  ];

  // Méthodes utilitaires
  static String getPlaceImage(String placeName) {
    return places[placeName] ?? places['Dakar']!;
  }

  static String getDocumentImage(String documentType) {
    return documents[documentType.toLowerCase()] ?? documents['carte_identite']!;
  }

  static String getRandomProfileImage() {
    return profiles[DateTime.now().millisecondsSinceEpoch % profiles.length];
  }

  static Widget buildNetworkImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  // Widget pour les images de profil
  static Widget buildProfileImage(String? imageUrl, {
    double size = 50,
    String? fallbackText,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: buildNetworkImage(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
      ),
      child: Center(
        child: Text(
          fallbackText ?? 'U',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget pour les images de documents
  static Widget buildDocumentImage(String documentType, {
    double width = 200,
    double height = 150,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: buildNetworkImage(
        getDocumentImage(documentType),
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  // Widget pour les images de lieux
  static Widget buildPlaceImage(String placeName, {
    double width = 300,
    double height = 200,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: buildNetworkImage(
        getPlaceImage(placeName),
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}


