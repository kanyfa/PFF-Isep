import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/historique.dart';
import '../utils/logger.dart';

class HistoriqueService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter une action à l'historique
  Future<void> ajouterAction({
    required String userId,
    required TypeAction action,
    required String description,
    Map<String, dynamic>? details,
  }) async {
    try {
      final historique = Historique(
        id: '', // Sera généré par Firestore
        userId: userId,
        action: action,
        description: description,
        dateAction: DateTime.now(),
        details: details,
      );

      await _firestore.collection('historique').add(historique.toMap());
      notifyListeners();
    } catch (e) {
      AppLogger.log('Erreur lors de l\'ajout de l\'action à l\'historique: $e');
    }
  }

  // Récupérer l'historique d'un utilisateur
  Future<List<Historique>> getHistoriqueUtilisateur(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('historique')
          .where('userId', isEqualTo: userId)
          .limit(50)
          .get();

      final historique = querySnapshot.docs
          .map((doc) => Historique.fromMap(doc.data(), doc.id))
          .toList();
      
      // Tri manuel par date d'action
      historique.sort((a, b) => b.dateAction.compareTo(a.dateAction));
      
      return historique;
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }

  // Récupérer l'historique des annonces d'un utilisateur
  Future<List<Historique>> getHistoriqueAnnonces(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('historique')
          .where('userId', isEqualTo: userId)
          .limit(100)
          .get();

      final historique = querySnapshot.docs
          .map((doc) => Historique.fromMap(doc.data(), doc.id))
          .where((h) => h.action == TypeAction.creationAnnonce || 
                        h.action == TypeAction.modificationAnnonce || 
                        h.action == TypeAction.suppressionAnnonce)
          .toList();
      
      // Tri manuel par date d'action
      historique.sort((a, b) => b.dateAction.compareTo(a.dateAction));
      
      return historique;
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération de l\'historique des annonces: $e');
      return [];
    }
  }

  // Récupérer les statistiques d'historique pour un utilisateur
  Future<Map<String, int>> getStatistiquesUtilisateur(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('historique')
          .where('userId', isEqualTo: userId)
          .get();

      final actions = querySnapshot.docs
          .map((doc) => doc.data()['action'] as String)
          .toList();

      return {
        'total': actions.length,
        'creationAnnonce': actions.where((a) => a == 'creationAnnonce').length,
        'modificationAnnonce': actions.where((a) => a == 'modificationAnnonce').length,
        'suppressionAnnonce': actions.where((a) => a == 'suppressionAnnonce').length,
        'recherche': actions.where((a) => a == 'recherche').length,
        'contact': actions.where((a) => a == 'contact').length,
      };
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération des statistiques utilisateur: $e');
      return {};
    }
  }

  // Récupérer toutes les actions (pour les admins)
  Future<List<Historique>> getAllHistorique() async {
    try {
      final querySnapshot = await _firestore
          .collection('historique')
          .orderBy('dateAction', descending: true)
          .limit(100)
          .get();

      return querySnapshot.docs
          .map((doc) => Historique.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération de tout l\'historique: $e');
      return [];
    }
  }

  // Récupérer les statistiques d'utilisation
  Future<Map<String, dynamic>> getStatistiques() async {
    try {
      final annoncesSnapshot = await _firestore.collection('annonces').get();
      final usersSnapshot = await _firestore.collection('users').get();
      final historiqueSnapshot = await _firestore.collection('historique').get();

      // Compter les annonces par statut
      final annoncesPerdues = annoncesSnapshot.docs
          .where((doc) => doc.data()['statut'] == 'perdu')
          .length;
      final annoncesTrouvees = annoncesSnapshot.docs
          .where((doc) => doc.data()['statut'] == 'trouve')
          .length;

      // Compter les utilisateurs actifs (connectés dans les 30 derniers jours)
      final trenteJoursAgo = DateTime.now().subtract(const Duration(days: 30));
      final utilisateursActifs = historiqueSnapshot.docs
          .where((doc) {
            final date = DateTime.parse(doc.data()['dateAction']);
            return date.isAfter(trenteJoursAgo) && 
                   doc.data()['action'] == 'connexion';
          })
          .map((doc) => doc.data()['userId'])
          .toSet()
          .length;

      return {
        'totalAnnonces': annoncesSnapshot.docs.length,
        'annoncesPerdues': annoncesPerdues,
        'annoncesTrouvees': annoncesTrouvees,
        'totalUtilisateurs': usersSnapshot.docs.length,
        'utilisateursActifs': utilisateursActifs,
        'totalActions': historiqueSnapshot.docs.length,
      };
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération des statistiques: $e');
      return {};
    }
  }
}






