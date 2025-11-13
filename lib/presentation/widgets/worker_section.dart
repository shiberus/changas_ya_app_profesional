import 'package:changas_ya_app/presentation/providers/favorite_workers_provider.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkerSection extends ConsumerWidget {
  final String professionalId;

  const WorkerSection({
    super.key,
    required this.professionalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteWorkersProvider);
    final actions = ref.read(favoriteWorkersActionsProvider);

    final isFavorite = favoritesAsync.asData?.value
            .any((p) => p.uid == professionalId) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Profesional",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'details':
                    context.push('/profileProfessional/$professionalId');
                    break;

                  case 'toggle_fav':
                    await actions.toggleFavorite(professionalId, isFavorite);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite
                            ? 'Eliminado de favoritos'
                            : 'Agregado a favoritos'),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'details', child: Text('Ver perfil')),
                PopupMenuItem(
                  value: 'toggle_fav',
                  child: Text(
                    isFavorite
                        ? 'Eliminar de favoritos'
                        : 'Agregar a favoritos',
                  ),
                ),
              ],
            ),
          ],
        ),
        ProfileCard(profileId: professionalId),
        const SizedBox(height: 20),
      ],
    );
  }
}
