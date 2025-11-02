import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/providers/professional_provider.dart';
import '../widgets/opinion_card.dart';

class ProfileProfesionalScreen extends ConsumerStatefulWidget {
  final String professionalId;
  const ProfileProfesionalScreen({super.key, required this.professionalId});

  @override
  ConsumerState<ProfileProfesionalScreen> createState() =>
      _ProfileProfesionalScreenState();
}

class _ProfileProfesionalScreenState
    extends ConsumerState<ProfileProfesionalScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(professionalProvider.notifier)
        .loadProfessionalProfile(widget.professionalId);
  }

  @override
  Widget build(BuildContext context) {
    final professional = ref.watch(professionalProvider);

    if (professional == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil Profesional')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(professional.fotoUrl),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(professional.nombre,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(professional.descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            const SizedBox(height: 20),
            const Text('Oficios:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
                spacing: 8,
                children: professional.oficios
                    .map((o) => Chip(label: Text(o)))
                    .toList()),
            const SizedBox(height: 20),
            Text('Trabajos realizados: ${professional.trabajosRealizados}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Contacto:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('📞 ${professional.telefono}'),
            Text('📧 ${professional.email}'),
            const SizedBox(height: 20),
            Text(
                'Opiniones recientes (⭐ ${professional.calificacionPromedio.toStringAsFixed(1)}):',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...professional.opiniones.map((o) => OpinionCard(
                  nombreCliente: o.nombreCliente,
                  comentario: o.comentario,
                  calificacion: o.calificacion,
                )),
          ],
        ),
      ),
    );
  }
}
