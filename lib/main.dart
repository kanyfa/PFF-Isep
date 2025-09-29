import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/annonce_service.dart';
import 'services/notification_service.dart';
import 'services/historique_service.dart';
import 'services/message_service.dart';
import 'services/admin_service.dart';
import 'services/user_service.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/annonces/declare_loss_screen.dart';
import 'screens/annonces/search_annonce_screen.dart';
import 'screens/annonces/annonce_details_screen.dart';
import 'screens/annonces/my_annonces_screen.dart';
import 'screens/annonces/found_documents_screen.dart';
import 'screens/annonces/annonce_history_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/about/about_app_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/annonce_moderation_screen.dart';
import 'screens/messages/messages_screen.dart';


import 'utils/logger.dart';void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.log('✅ Firebase initialisé avec succès');
  } catch (e) {
    AppLogger.log('❌ Erreur lors de l\'initialisation de Firebase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AnnonceService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => HistoriqueService()),
        ChangeNotifierProvider(create: (_) => MessageService()),
        ChangeNotifierProvider(create: (_) => AdminService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp.router(
        title: 'SenPapier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primaryBlue,
            brightness: Brightness.light,
          ),
          fontFamily: 'Inter',
          appBarTheme: AppBarTheme(
            backgroundColor: AppTheme.white,
            foregroundColor: AppTheme.darkGrey,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: AppTheme.darkGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: AppTheme.primaryBlue),
          ),
          scaffoldBackgroundColor: AppTheme.lightGrey,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppTheme.primaryButtonStyle,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: AppTheme.secondaryButtonStyle,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.lightGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.errorRed, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintStyle: TextStyle(
              color: AppTheme.mediumGrey,
              fontSize: 16,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppTheme.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppTheme.white,
            selectedItemColor: AppTheme.primaryBlue,
            unselectedItemColor: AppTheme.mediumGrey,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Page de présentation
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Page à propos (avant la connexion)
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutAppScreen(),
    ),
    
    // Routes d'authentification
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    
    // Routes principales
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/declare-loss',
      builder: (context, state) => const DeclareLossScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchAnnonceScreen(),
    ),
    GoRoute(
      path: '/my-annonces',
      builder: (context, state) => const MyAnnoncesScreen(),
    ),
    GoRoute(
      path: '/annonce/:id',
      builder: (context, state) {
        final annonceId = state.pathParameters['id']!;
        return AnnonceDetailsScreen(annonceId: annonceId);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/found-documents',
      builder: (context, state) => const FoundDocumentsScreen(),
    ),
    GoRoute(
      path: '/annonce-history',
      builder: (context, state) => const AnnonceHistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
      redirect: (context, state) {
        final auth = context.read<AuthService>();
        if (auth.currentUser == null || auth.currentUser!.isAdmin == false) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const UserManagementScreen(),
      redirect: (context, state) {
        final auth = context.read<AuthService>();
        if (auth.currentUser == null || auth.currentUser!.isAdmin == false) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/admin/annonces',
      builder: (context, state) => const AnnonceModerationScreen(),
      redirect: (context, state) {
        final auth = context.read<AuthService>();
        if (auth.currentUser == null || auth.currentUser!.isAdmin == false) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => const MessagesScreen(),
    ),
  ],
  redirect: (context, state) {
    final authService = context.read<AuthService>();
    final isLoggedIn = authService.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login' || 
                       state.matchedLocation == '/register';
    final isSplashRoute = state.matchedLocation == '/';
    final isAboutRoute = state.matchedLocation == '/about';

    // Si on est sur la page de présentation ou à propos, pas de redirection
    if (isSplashRoute || isAboutRoute) {
      return null;
    }

    // Si l'utilisateur n'est pas connecté et n'est pas sur une route d'auth
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // Si l'utilisateur est connecté et est sur une route d'auth
    if (isLoggedIn && isAuthRoute) {
      return '/home';
    }

    return null;
  },
);


