import 'package:changas_ya_app/presentation/providers/favorite_workers_provider.dart';
import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:changas_ya_app/presentation/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/opinion_card.dart';

class ProfileProfesionalScreen extends ConsumerWidget {
  final String profileId;
  const ProfileProfesionalScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(professionalFutureProvider(profileId));
    final averageRatingAsync = ref.watch(averageRatingProvider(profileId));
    final favoritesAsync = ref.watch(favoriteWorkersProvider);
    final actions = ref.read(favoriteWorkersActionsProvider);

    final isFavorite =
        favoritesAsync.asData?.value.any((p) => p.uid == profileId) ?? false;

    return profileAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Error al cargar perfil: $error'))),
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('Perfil no disponible')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil Profesional'),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () async {
                  await actions.toggleFavorite(profileId, isFavorite);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Eliminado de favoritos'
                            : 'Agregado a favoritos',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child:
                        (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    profile.isWorker ? 'Profesional' : 'Cliente',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Oficios:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: profile.trades
                      .map((o) => Chip(label: Text(o)))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contacto:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (profile.phone != null) Text('📞 ${profile.phone}'),
                Text('📧 ${profile.email}'),
                const SizedBox(height: 20),
                averageRatingAsync.when(
                  loading: () => const Text(
                    'Opiniones recientes (⭐ ...)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  error: (e, s) => const Text(
                    'Opiniones recientes (Error al cargar ⭐)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  data: (rating) => Text(
                    rating > 0
                        ? 'Opiniones recientes (⭐ ${rating.toStringAsFixed(1)}):'
                        : 'Opiniones recientes (sin calificaciones):',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                ...profile.opinions.map(
                  (o) => OpinionCard(
                    nombreCliente: 'Cliente',
                    comentario: o.comment,
                    calificacion: o.rating.toDouble(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
