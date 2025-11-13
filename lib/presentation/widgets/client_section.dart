import 'package:changas_ya_app/presentation/providers/favorite_workers_provider.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClientSection extends ConsumerWidget {
  final String clientId;

  const ClientSection({
    super.key,
    required this.clientId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteWorkersProvider);
    final actions = ref.read(favoriteWorkersActionsProvider);

    final isFavorite = favoritesAsync.asData?.value
            .any((c) => c.uid== clientId) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cliente",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'details':
                    context.push('/profileProfessional/$clientId');
                    break;

                  case 'toggle_fav':
                    await actions.toggleFavorite(clientId, isFavorite);
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
        ProfileCard(profileId: clientId),
        const SizedBox(height: 20),
      ],
    );
  }
}
