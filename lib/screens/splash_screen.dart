import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final next = AuthService.instance.isLoggedIn
        ? const HomeShell()
        : const LoginScreen();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  color: scheme.onPrimary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(Icons.handshake_rounded,
                    size: 60, color: scheme.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(AppInfo.name,
                style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(AppInfo.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.85),
                      fontSize: 15)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: scheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}