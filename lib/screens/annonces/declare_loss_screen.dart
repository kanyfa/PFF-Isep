import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/auth_service.dart';
import '../../services/annonce_service.dart';
import '../../utils/theme.dart';
import '../../models/annonce.dart';

class DeclareLossScreen extends StatefulWidget {
  const DeclareLossScreen({super.key});

  @override
  State<DeclareLossScreen> createState() => _DeclareLossScreenState();
}

class _DeclareLossScreenState extends State<DeclareLossScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _identifiantController = TextEditingController();
  final _lieuController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TypeDocument _selectedType = TypeDocument.carteIdentite;
  DateTime? _datePerte;
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titreController.dispose();
    _identifiantController.dispose();
    _lieuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Vérifier les permissions
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        final file = File(image.path);
        
        // Vérifier que le fichier existe
        if (await file.exists()) {
          setState(() {
            _selectedImage = file;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Photo sélectionnée avec succès'),
                backgroundColor: AppTheme.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        } else {
          throw Exception('Le fichier image n\'existe pas');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        helpText: 'Sélectionner la date de perte',
        cancelText: 'Annuler',
        confirmText: 'Confirmer',
      );
      
      if (pickedDate != null) {
        setState(() {
          _datePerte = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            DateTime.now().hour,
            DateTime.now().minute,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de la date: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _publishAnnonce() async {
    if (!_formKey.currentState!.validate()) return;
    if (_datePerte == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner la date de perte'),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final annonceService = context.read<AnnonceService>();
      
      if (authService.currentUser == null) {
        throw Exception('Utilisateur non connecté');
      }

      final annonce = Annonce(
        id: '',
        userId: authService.currentUser!.id,
        titre: _titreController.text.trim(),
        description: _descriptionController.text.trim(),
        typeDocument: _selectedType,
        statut: StatutAnnonce.perdu,
        datePerte: _datePerte!,
        lieuPerte: _lieuController.text.trim(),
        nomInscrit: _titreController.text.trim(),
        numeroTelephone: '+221${_identifiantController.text.trim()}',
        dateCreation: DateTime.now(),
        position: null,
      );

      // Pour les ramasseurs, ne pas envoyer d'image
      final user = authService.currentUser;
      final imageToSend = (user != null && user.isRamasseur) ? null : _selectedImage;
      
      // Vérifier l'image avant l'envoi
      if (imageToSend != null && !await imageToSend.exists()) {
        throw Exception('Le fichier image n\'existe plus');
      }
      
      final annonceId = await annonceService.createAnnonce(annonce, imageToSend);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Annonce publiée avec succès !'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        // Rediriger vers les détails de l'annonce
        context.go('/annonce/$annonceId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la publication: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Signaler un document',
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Sauvegarder comme brouillon
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Brouillon sauvegardé'),
                  backgroundColor: AppTheme.infoBlue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text(
              'Brouillon',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type de document
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type de document',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: TypeDocument.values.map((type) {
                        final isSelected = _selectedType == type;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedType = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppTheme.primaryBlue.withOpacity(0.1)
                                  : AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                    ? AppTheme.primaryBlue 
                                    : AppTheme.outline,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getDocumentIcon(type),
                                  color: isSelected 
                                      ? AppTheme.primaryBlue 
                                      : AppTheme.mediumGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                    Text(
                                  _getDocumentLabel(type),
                                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                                    color: isSelected 
                                        ? AppTheme.primaryBlue 
                                        : AppTheme.darkGrey,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Informations du document
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations du document',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

              // Titre
                    TextFormField(
                controller: _titreController,
                      decoration: AppTheme.textFieldDecoration.copyWith(
                        labelText: 'Titre de l\'annonce *',
                        hintText: 'Ex: Carte d\'identité perdue',
                        prefixIcon: const Icon(
                          Icons.title_rounded,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un titre';
                  }
                  return null;
                },
              ),
                    const SizedBox(height: 20),
                    
                    // Numéro du document avec indicateur du pays
                    Row(
                      children: [
                        // Indicateur du pays
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.outline),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '🇸🇳',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+221',
                                style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Champ numéro
                        Expanded(
                          child: TextFormField(
                            controller: _identifiantController,
                            keyboardType: TextInputType.phone,
                            decoration: AppTheme.textFieldDecoration.copyWith(
                              labelText: 'Numéro de téléphone (optionnel)',
                              hintText: '77 123 45 67',
                              prefixIcon: const Icon(
                                Icons.phone_rounded,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null; // Champ optionnel
                              }
                              // Nettoyer le numéro (enlever les espaces et caractères spéciaux)
                              final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');
                              if (cleanNumber.length < 9) {
                                return 'Numéro trop court (minimum 9 chiffres)';
                              }
                              if (cleanNumber.length > 10) {
                                return 'Numéro trop long (maximum 10 chiffres)';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

              // Description
                    TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                      decoration: AppTheme.textFieldDecoration.copyWith(
                        labelText: 'Description (optionnel)',
                        hintText: 'Décrivez votre document...',
                        prefixIcon: const Icon(
                          Icons.description_rounded,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Lieu et date de perte
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lieu et date de perte',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

              // Lieu de perte
                    TextFormField(
                      controller: _lieuController,
                      decoration: AppTheme.textFieldDecoration.copyWith(
                        labelText: 'Lieu de perte *',
                        hintText: 'Ex: Marché Sandaga, Dakar',
                        prefixIcon: const Icon(
                          Icons.location_on_rounded,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le lieu de perte';
                  }
                  return null;
                },
              ),
                    const SizedBox(height: 8),
                    Text(
                      'Saisissez le lieu exact où vous avez perdu votre document',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Date et heure de perte
                    GestureDetector(
                      onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.outline),
                  ),
                  child: Row(
                    children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppTheme.primaryBlue,
                            ),
                      const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _datePerte != null
                                    ? '${_datePerte!.day}/${_datePerte!.month}/${_datePerte!.year} à ${_datePerte!.hour}:${_datePerte!.minute.toString().padLeft(2, '0')}'
                                    : 'Sélectionner la date et l\'heure',
                                style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  color: _datePerte != null 
                                      ? AppTheme.darkGrey 
                                      : AppTheme.mediumGrey,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
                    const SizedBox(height: 8),
                    Text(
                      'Indiquez quand vous avez remarqué la perte du document',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Photos du document (seulement pour les utilisateurs, pas les ramasseurs)
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  final user = authService.currentUser;
                  if (user != null && user.isRamasseur) {
                    return const SizedBox.shrink(); // Ne pas afficher pour les ramasseurs
                  }
                  
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photos du document (optionnel)',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (_selectedImage != null)
                          Container(
                            height: 150, // Réduit de 200 à 150
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.outline),
                            ),
                            child: Stack(
                              children: [
                                FutureBuilder<bool>(
                                  future: _selectedImage!.exists(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        color: AppTheme.lightGrey,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    
                                    if (snapshot.data == true) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: AppTheme.lightGrey,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.error_outline,
                                                  color: AppTheme.errorRed,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        color: AppTheme.lightGrey,
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: AppTheme.errorRed,
                                                size: 50,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Image non trouvée',
                                                style: TextStyle(color: AppTheme.errorRed),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.errorRed,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppTheme.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.outline,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 48,
                                    color: AppTheme.mediumGrey,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ajouter une photo',
                                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.mediumGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),

              // Bouton de publication
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _publishAnnonce,
                  style: AppTheme.primaryButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      _isLoading ? AppTheme.mediumGrey : AppTheme.primaryBlue,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.publish_rounded,
                              color: AppTheme.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Publier l\'annonce',
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Avertissement
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.infoBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.infoBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'En publiant, vous acceptez que vos informations de contact soient visibles aux personnes qui trouvent votre document.',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.infoBlue,
                        ),
                      ),
                    ),
                  ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(TypeDocument type) {
    switch (type) {
      case TypeDocument.carteIdentite:
        return Icons.badge_rounded;
      case TypeDocument.passeport:
        return Icons.card_membership_rounded;
      case TypeDocument.permisConduire:
        return Icons.drive_eta_rounded;
      case TypeDocument.carteVitale:
        return Icons.health_and_safety_rounded;
      case TypeDocument.carteEtudiant:
        return Icons.school_rounded;
      case TypeDocument.autre:
        return Icons.description_rounded;
    }
  }

  String _getDocumentLabel(TypeDocument type) {
    switch (type) {
      case TypeDocument.carteIdentite:
        return 'Carte d\'identité';
      case TypeDocument.passeport:
        return 'Passeport';
      case TypeDocument.permisConduire:
        return 'Permis de conduire';
      case TypeDocument.carteVitale:
        return 'Carte Vitale';
      case TypeDocument.carteEtudiant:
        return 'Carte étudiant';
      case TypeDocument.autre:
        return 'Autre';
    }
  }
}