import 'package:flutter/material.dart';
import 'package:shopping_tangerang/features/auth/presentation/splash_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/login_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/register_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/verify_email_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/dashboard_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/profile_page.dart'; // ✅ tambahkan import ProfilePage
import 'auth_guard.dart';

class AppRouter {
  static const String splash      = '/';
  static const String login       = '/login';
  static const String register    = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard   = '/dashboard';
  static const String profile     = '/profile'; // ✅ route baru untuk profil

  static Map<String, WidgetBuilder> get routes => {
    splash:      (_) => const SplashPage(),
    login:       (_) => const LoginPage(),
    register:    (_) => const RegisterPage(),
    verifyEmail: (_) => const VerifyEmailPage(),
    dashboard:   (_) => const AuthGuard(child: DashboardPage()),
    profile:     (_) => const ProfilePage(), // ✅ tambahkan ke daftar routes
  };
}
