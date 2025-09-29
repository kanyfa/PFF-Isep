import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/annonce.dart';
import '../models/historique.dart';
import 'historique_service.dart';
import 'notification_service.dart';
import '../utils/logger.dart';

class AnnonceService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> createAnnonce(Annonce annonce, File? photoFile) async {
    try {
      String? photoUrl;
      
      if (photoFile != null) {
        try {
          final ref = _storage.ref().child('annonces/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(photoFile);
          photoUrl = await ref.getDownloadURL();
        } catch (storageError) {
          AppLogger.log('Erreur lors de l\'upload de l\'image: $storageError');
          // Continuer sans l'image si l'upload échoue
          photoUrl = null;
        }
      }

      final annonceWithPhoto = Annonce(
        id: annonce.id,
        userId: annonce.userId,
        titre: annonce.titre,
        description: annonce.description,
        typeDocument: annonce.typeDocument,
        statut: annonce.statut,
        datePerte: annonce.datePerte,
        lieuPerte: annonce.lieuPerte,
        nomInscrit: annonce.nomInscrit,
        numeroTelephone: annonce.numeroTelephone,
        photoUrl: photoUrl,
        dateCreation: annonce.dateCreation,
        position: annonce.position,
      );

      final docRef = await _firestore.collection('annonces').add(annonceWithPhoto.toMap());
      
      // Ajouter l'action à l'historique
      try {
        final historiqueService = HistoriqueService();
        await historiqueService.ajouterAction(
          userId: annonce.userId,
          action: TypeAction.creationAnnonce,
          description: 'Annonce créée: ${annonce.titre}',
          details: {'annonceId': docRef.id, 'typeDocument': annonce.typeDocument.name},
        );
      } catch (e) {
        AppLogger.log('Erreur lors de l\'ajout de l\'action à l\'historique: $e');
      }

      // Envoyer des notifications aux administrateurs et ramasseurs
      try {
        final notificationService = NotificationService();
        await notificationService.notifyNewAnnonce(docRef.id, annonce.titre);
      } catch (e) {
        AppLogger.log('Erreur lors de l\'envoi des notifications: $e');
      }
      
      notifyListeners();
      return docRef.id;
    } catch (e) {
      AppLogger.log('Erreur lors de la création de l\'annonce: $e');
      rethrow;
    }
  }

  Future<void> deleteAnnonce(String annonceId) async {
    try {
      // Récupérer l'annonce avant de la supprimer pour l'historique
      final annonceDoc = await _firestore.collection('annonces').doc(annonceId).get();
      if (annonceDoc.exists) {
        final annonce = Annonce.fromMap(annonceDoc.data()!, annonceId);
        
        // Ajouter l'action à l'historique
        try {
          final historiqueService = HistoriqueService();
          await historiqueService.ajouterAction(
            userId: annonce.userId,
            action: TypeAction.suppressionAnnonce,
            description: 'Annonce supprimée: ${annonce.titre}',
            details: {'annonceId': annonceId, 'typeDocument': annonce.typeDocument.name},
          );
        } catch (e) {
          AppLogger.log('Erreur lors de l\'ajout de l\'action à l\'historique: $e');
        }
      }
      
      await _firestore.collection('annonces').doc(annonceId).delete();
      notifyListeners();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'annonce: $e');
    }
  }

  Future<List<Annonce>> getAnnoncesByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('annonces')
          .where('userId', isEqualTo: userId)
          .get();

      final annonces = querySnapshot.docs
          .map((doc) => Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Tri manuel par date de création
      annonces.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
      
      return annonces;
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération des annonces utilisateur: $e');
      return [];
    }
  }

  Future<Annonce?> getAnnonceById(String id) async {
    try {
      final doc = await _firestore.collection('annonces').doc(id).get();
      if (doc.exists) {
        return Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      AppLogger.log('Erreur lors de la récupération de l\'annonce: $e');
      return null;
    }
  }

  Future<List<Annonce>> searchAnnonces({
    String? query,
    TypeDocument? typeDocument,
    StatutAnnonce? statut,
  }) async {
    try {
      Query queryRef = _firestore.collection('annonces');

      if (query != null && query.isNotEmpty) {
        queryRef = queryRef.where('titre', isGreaterThanOrEqualTo: query)
            .where('titre', isLessThan: query + '\uf8ff');
      }

      if (typeDocument != null) {
        queryRef = queryRef.where('typeDocument', isEqualTo: typeDocument.name);
      }

      if (statut != null) {
        queryRef = queryRef.where('statut', isEqualTo: statut.name);
      }

      final querySnapshot = await queryRef.orderBy('dateCreation', descending: true).get();

      return querySnapshot.docs
          .map((doc) => Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      AppLogger.log('Erreur lors de la recherche d\'annonces: $e');
      return [];
    }
  }

  Future<void> updateAnnonce(Annonce annonce) async {
    try {
      await _firestore
          .collection('annonces')
          .doc(annonce.id)
          .update(annonce.toMap());
      notifyListeners();
    } catch (e) {
      AppLogger.log('Erreur lors de la mise à jour de l\'annonce: $e');
      rethrow;
    }
  }

  // Récupérer les annonces d'un utilisateur
  Future<List<Annonce>> getUserAnnonces(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('annonces')
          .where('userId', isEqualTo: userId)
          .orderBy('dateCreation', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      AppLogger.log('Erreur lors du chargement des annonces de l\'utilisateur: $e');
      return [];
    }
  }

  // Récupérer les documents trouvés près de l'utilisateur
  Future<List<Annonce>> getFoundDocumentsNearby() async {
    try {
      final querySnapshot = await _firestore
          .collection('annonces')
          .where('statut', isEqualTo: StatutAnnonce.trouve.name)
          .orderBy('dateCreation', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      AppLogger.log('Erreur lors du chargement des documents trouvés: $e');
      return [];
    }
  }

  // Récupérer toutes les annonces (pour l'administration)
  Future<List<Annonce>> getAllAnnonces() async {
    try {
      final querySnapshot = await _firestore
          .collection('annonces')
          .orderBy('dateCreation', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Annonce.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      AppLogger.log('Erreur lors du chargement de toutes les annonces: $e');
      return [];
    }
  }

}
