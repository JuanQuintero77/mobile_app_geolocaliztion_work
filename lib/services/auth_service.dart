import 'package:flutter/foundation.dart';

// Prototipo visual: NO valida credenciales ni llama a un backend.
// Se reemplazará por Firebase Auth más adelante.
class AppUser {
  final String name;
  final String email;
  const AppUser({required this.name, required this.email});
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final ValueNotifier<AppUser?> currentUser = ValueNotifier(null);
  bool get isLoggedIn => currentUser.value != null;

  Future<void> login({required String email, String? name}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simula red
    currentUser.value =
        AppUser(name: name ?? email.split('@').first, email: email);
  }

  void logout() => currentUser.value = null;
}