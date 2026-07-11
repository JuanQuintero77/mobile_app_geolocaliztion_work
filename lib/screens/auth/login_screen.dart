import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../home_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeShell()));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await AuthService.instance.login(email: _email.text.trim());
    await _goHome();
  }

  Future<void> _guest() async {
    setState(() => _loading = true);
    await AuthService.instance
        .login(email: 'invitado@cerca.app', name: 'Invitado');
    await _goHome();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.handshake_rounded,
                          size: 40, color: scheme.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Bienvenido a ${AppInfo.name}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Ingresa para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'Ingresa un correo válido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 4)
                        ? 'Mínimo 4 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Ingresar'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loading ? null : _guest,
                    child: const Text('Entrar como invitado'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta?'),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen())),
                        child: const Text('Regístrate'),
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
}