import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_tangerang/providers/auth_provider.dart';
import 'package:shopping_tangerang/features/auth/presentation/login_page.dart';
import 'package:shopping_tangerang/features/auth/presentation/verify_email_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<MyAuthProvider>().status;

    return switch (status) {
      AuthStatus.authenticated    => child,                   // Lanjut
      AuthStatus.emailNotVerified => const VerifyEmailPage(), // Redirect
      _                           => const LoginPage(),       // Redirect login
    };
  }
}
