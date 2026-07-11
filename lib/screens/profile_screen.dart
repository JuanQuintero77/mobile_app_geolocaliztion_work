import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    AuthService.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = AuthService.instance.currentUser.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                (user?.name.isNotEmpty ?? false)
                    ? user!.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(user?.name ?? 'Invitado',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(user?.email ?? '',
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Editar perfil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Mis servicios publicados'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Configuración'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: scheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('${AppInfo.name} · versión 0.1',
                style:
                    TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}