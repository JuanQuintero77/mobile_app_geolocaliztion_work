import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onExplore;
  final VoidCallback onOffer;
  const HomeScreen({super.key, required this.onExplore, required this.onOffer});

  static const _categories = <(IconData, String)>[
    (Icons.content_cut, 'Costura'),
    (Icons.electrical_services, 'Electricidad'),
    (Icons.carpenter, 'Carpintería'),
    (Icons.plumbing, 'Plomería'),
    (Icons.cut, 'Peluquería'),
    (Icons.bakery_dining, 'Panadería'),
    (Icons.cleaning_services, 'Aseo'),
    (Icons.more_horiz, 'Ver más'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = AuthService.instance.currentUser.value;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola, ${user?.name ?? 'invitado'} 👋',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('¿Qué necesitas hoy?',
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(
                    (user?.name.isNotEmpty ?? false)
                        ? user!.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onExplore,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Text('Buscar oficios cerca de ti',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¿Ofreces un servicio?',
                      style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Regístrate y deja que te encuentren en el mapa.',
                      style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.9))),
                  const SizedBox(height: 14),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.onPrimary,
                      foregroundColor: scheme.primary,
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: onOffer,
                    child: const Text('Ofrecer mis servicios'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Categorías',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              children: [
                for (final (icon, label) in _categories)
                  Column(
                    children: [
                      InkWell(
                        onTap: onExplore,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: scheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child:
                              Icon(icon, color: scheme.onSecondaryContainer),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}