import 'package:flutter/material.dart';

class AppImages {
  // Images de lieux sénégalais
  static const String dakarSkyline = 'assets/images/places/dakar_skyline.jpg';
  static const String placeIndependance = 'assets/images/places/place_independance.jpg';
  static const String marcheSandaga = 'assets/images/places/marche_sandaga.jpg';
  static const String aeroportSenghor = 'assets/images/places/aeroport_senghor.jpg';
  static const String universiteUcad = 'assets/images/places/universite_ucad.jpg';
  static const String hopitalPrincipal = 'assets/images/places/hopital_principal.jpg';
  static const String gareRoutiere = 'assets/images/places/gare_routiere.jpg';
  static const String plageYoff = 'assets/images/places/plage_yoff.jpg';
  static const String mosqueeDivinite = 'assets/images/places/mosquee_divinite.jpg';
  static const String centreAlmadies = 'assets/images/places/centre_almadies.jpg';

  // Images de documents sénégalais
  static const String carteIdentiteSenegal = 'assets/images/documents/carte_identite_senegal.jpg';
  static const String passeportSenegal = 'assets/images/documents/passeport_senegal.jpg';
  static const String permisConduireSenegal = 'assets/images/documents/permis_conduire_senegal.jpg';
  static const String carteVitaleSenegal = 'assets/images/documents/carte_vitale_senegal.jpg';
  static const String carteEtudiantUcad = 'assets/images/documents/carte_etudiant_ucad.jpg';
  static const String diplomeSenegal = 'assets/images/documents/diplome_senegal.jpg';

  // Images de personnes (profils)
  static const String hommeSenegal1 = 'assets/images/people/homme_senegal_1.jpg';
  static const String femmeSenegal1 = 'assets/images/people/femme_senegal_1.jpg';
  static const String hommeSenegal2 = 'assets/images/people/homme_senegal_2.jpg';
  static const String femmeSenegal2 = 'assets/images/people/femme_senegal_2.jpg';
  static const String enfantSenegal = 'assets/images/people/enfant_senegal.jpg';

  // Icônes personnalisées
  static const String logoSoclose = 'assets/images/icons/logo_soclose.png';
  static const String iconDocument = 'assets/images/icons/icon_document.png';
  static const String iconLocation = 'assets/images/icons/icon_location.png';
  static const String iconUser = 'assets/images/icons/icon_user.png';
  static const String iconAdmin = 'assets/images/icons/icon_admin.png';
  static const String iconRamasseur = 'assets/images/icons/icon_ramasseur.png';

  // Images par défaut
  static const String defaultProfile = 'assets/images/people/default_profile.jpg';
  static const String defaultDocument = 'assets/images/documents/default_document.jpg';
  static const String defaultPlace = 'assets/images/places/default_place.jpg';

  // Méthodes utilitaires
  static String getDocumentImage(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'carte_identite':
        return carteIdentiteSenegal;
      case 'passeport':
        return passeportSenegal;
      case 'permis_conduire':
        return permisConduireSenegal;
      case 'carte_vitale':
        return carteVitaleSenegal;
      case 'carte_etudiant':
        return carteEtudiantUcad;
      case 'diplome':
        return diplomeSenegal;
      default:
        return defaultDocument;
    }
  }

  static String getPlaceImage(String placeName) {
    switch (placeName.toLowerCase()) {
      case 'dakar':
        return dakarSkyline;
      case 'place de l\'indépendance':
        return placeIndependance;
      case 'marché sandaga':
        return marcheSandaga;
      case 'aéroport léopold sédar senghor':
        return aeroportSenghor;
      case 'université cheikh anta diop':
        return universiteUcad;
      case 'hôpital principal':
        return hopitalPrincipal;
      case 'gare routière':
        return gareRoutiere;
      case 'plage de yoff':
        return plageYoff;
      case 'mosquée de la divinité':
        return mosqueeDivinite;
      case 'centre commercial almadies':
        return centreAlmadies;
      default:
        return defaultPlace;
    }
  }

  static String getRandomProfileImage() {
    final profiles = [
      hommeSenegal1,
      femmeSenegal1,
      hommeSenegal2,
      femmeSenegal2,
    ];
    return profiles[DateTime.now().millisecondsSinceEpoch % profiles.length];
  }

  static Widget buildImageWidget(String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
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
}
