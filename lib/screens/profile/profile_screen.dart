import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authService = context.read<AuthService>();
    if (authService.currentUser != null) {
      final user = authService.currentUser!;
      _nomController.text = user.nom;
      _prenomController.text = user.prenom;
      _telephoneController.text = user.telephone;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        // TODO: Upload image to Firebase Storage
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo sélectionnée: ${image.name}'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection de la photo: $e'),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      await authService.updateProfile(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        telephone: _telephoneController.text.trim(),
      );

      setState(() => _isEditing = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profil mis à jour avec succès'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: $e'),
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
          'Profil',
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Sauvegarder',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authService.currentUser!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Photo de profil et informations de base
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      // Photo de profil
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: AppTheme.elevatedShadow,
                            ),
                            child: DemoImages.buildProfileImage(
                              name: user.prenom,
                              size: 120,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Nom et rôle
                      Text(
                        '${user.prenom} ${user.nom}',
                        style: AppTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Badge de rôle
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getRoleColor(user.role)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getRoleIcon(user.role),
                              color: _getRoleColor(user.role),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getRoleLabel(user.role),
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: _getRoleColor(user.role),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        user.email,
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Formulaire d'édition
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations personnelles',
                          style: AppTheme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Prénom
                        TextFormField(
                          controller: _prenomController,
                          enabled: _isEditing,
                          decoration: AppTheme.textFieldDecoration.copyWith(
                            labelText: 'Prénom',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre prénom';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Nom
                        TextFormField(
                          controller: _nomController,
                          enabled: _isEditing,
                          decoration: AppTheme.textFieldDecoration.copyWith(
                            labelText: 'Nom',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre nom';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Téléphone
                        TextFormField(
                          controller: _telephoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          decoration: AppTheme.textFieldDecoration.copyWith(
                            labelText: 'Téléphone',
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppTheme.primaryBlue,
                        ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre numéro de téléphone';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Actions rapides
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions',
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Notifications
                      _buildActionTile(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        subtitle: 'Gérer vos notifications',
                        onTap: () => context.go('/notifications'),
                      ),
                      
                      // Administration (si admin)
                      if (user.isAdmin)
                        _buildActionTile(
                          icon: Icons.admin_panel_settings_rounded,
                          title: 'Administration',
                          subtitle: 'Gérer la plateforme',
                          onTap: () => context.go('/admin'),
                        ),
                      
                      // Déconnexion
                      _buildActionTile(
                        icon: Icons.logout_rounded,
                        title: 'Déconnexion',
                        subtitle: 'Se déconnecter de l\'application',
                        onTap: () async {
                          await authService.logout();
                          if (mounted) {
                            context.go('/login');
                          }
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGrey,
        backgroundColor: AppTheme.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/messages');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (isDestructive ? AppTheme.errorRed : AppTheme.primaryBlue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppTheme.errorRed : AppTheme.primaryBlue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppTheme.errorRed : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppTheme.mediumGrey,
      ),
      onTap: onTap,
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppTheme.errorRed;
      case 'ramasseur':
        return AppTheme.warningOrange;
      case 'user':
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'ramasseur':
        return Icons.work_rounded;
      case 'user':
      default:
        return Icons.person_rounded;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Administrateur';
      case 'ramasseur':
        return 'Ramasseur';
      case 'user':
      default:
        return 'Utilisateur';
    }
  }
}