import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/provider_service.dart';

class RegisterProviderScreen extends StatefulWidget {
  const RegisterProviderScreen({super.key});

  @override
  State<RegisterProviderScreen> createState() => _RegisterProviderScreenState();
}

class _RegisterProviderScreenState extends State<RegisterProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _service = ProviderService();

  static const _trades = [
    'Costurera', 'Electricista', 'Carpintería', 'Plomería',
    'Peluquería', 'Panadería', 'Cerrajería', 'Jardinería', 'Otro',
  ];
  String? _selectedTrade;

  double? _lat;
  double? _lng;
  bool _locating = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) _snack('Permiso de ubicación denegado.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      if (mounted) _snack('No se pudo obtener la ubicación: $e');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null || _lng == null) {
      _snack('Primero detecta tu ubicación.');
      return;
    }
    setState(() => _submitting = true);
    try {
      await _service.createProvider(
        name: _nameController.text.trim(),
        trade: _selectedTrade!,
        description: _descController.text.trim(),
        lat: _lat!,
        lng: _lng!,
      );
      if (!mounted) return;
      _snack('¡Registrado! Ya apareces en el mapa.');
      _formKey.currentState!.reset();
      _nameController.clear();
      _descController.clear();
      setState(() {
        _selectedTrade = null;
        _lat = null;
        _lng = null;
      });
    } catch (e) {
      if (mounted) _snack('No se pudo registrar: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = _lat != null && _lng != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Ofrecer mis servicios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre o negocio',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa un nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTrade,
                decoration: const InputDecoration(
                  labelText: 'Oficio',
                  border: OutlineInputBorder(),
                ),
                items: _trades
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedTrade = v),
                validator: (v) => v == null ? 'Selecciona un oficio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción de lo que ofreces',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Describe tu servicio'
                    : null,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(
                    hasLocation ? Icons.check_circle : Icons.location_off,
                    color: hasLocation ? Colors.green : null,
                  ),
                  title: Text(hasLocation
                      ? 'Ubicación detectada'
                      : 'Ubicación no detectada'),
                  subtitle: Text(hasLocation
                      ? '${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}'
                      : 'Toca "Detectar" para usar tu ubicación actual'),
                  trailing: _locating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : TextButton(
                          onPressed: _useCurrentLocation,
                          child: const Text('Detectar'),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Registrarme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}