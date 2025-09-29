import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'user';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final success = await authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        telephone: _telephoneController.text.trim(),
        role: _selectedRole,
      );

      if (success && mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'inscription: $e'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo et titre
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          child: const Icon(
                            Icons.person_add_rounded,
                            size: 48,
                            color: AppTheme.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Créer un compte',
                          style: AppTheme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rejoignez la communauté SenPapier',
                          style: AppTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Formulaire d'inscription
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: AppTheme.cardDecoration,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Informations personnelles',
                            style: AppTheme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          // Prénom
                          TextFormField(
                            controller: _prenomController,
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
                          
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: AppTheme.textFieldDecoration.copyWith(
                              labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppTheme.primaryBlue,
                        ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Email invalide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Téléphone avec indicateur du pays
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
                              // Champ téléphone
                              Expanded(
                                child: TextFormField(
                                  controller: _telephoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: AppTheme.textFieldDecoration.copyWith(
                                    labelText: 'Numéro de téléphone',
                                    hintText: '77 123 45 67',
                                    prefixIcon: const Icon(
                                      Icons.phone_outlined,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez saisir votre numéro';
                                    }
                                    if (value.length < 9) {
                                      return 'Numéro trop court';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Mot de passe
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: AppTheme.textFieldDecoration.copyWith(
                              labelText: 'Mot de passe',
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: AppTheme.primaryBlue,
                        ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppTheme.mediumGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre mot de passe';
                              }
                              if (value.length < 6) {
                                return 'Le mot de passe doit contenir au moins 6 caractères';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Confirmation mot de passe
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: AppTheme.textFieldDecoration.copyWith(
                              labelText: 'Confirmer le mot de passe',
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: AppTheme.primaryBlue,
                        ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppTheme.mediumGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez confirmer votre mot de passe';
                              }
                              if (value != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Sélection du rôle
                          Text(
                            'Type de compte',
                            style: AppTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          _buildRoleSelector(),
                          const SizedBox(height: 32),
                          
                          // Bouton d'inscription
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
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
                                  : Text(
                                      'Créer le compte',
                                      style: AppTheme.textTheme.titleMedium?.copyWith(
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Lien vers la connexion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Déjà un compte ? ',
                        style: AppTheme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          'Se connecter',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      children: [
        _buildRoleOption(
          value: 'user',
          title: 'Utilisateur',
          subtitle: 'Signaler et rechercher des documents',
          icon: Icons.person_rounded,
          color: AppTheme.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildRoleOption(
          value: 'ramasseur',
          title: 'Ramasseur',
          subtitle: 'Aider à retrouver les documents perdus',
          icon: Icons.work_rounded,
          color: AppTheme.warningOrange,
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == value;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppTheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
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
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}