import 'package:changas_ya_app/presentation/providers/favorite_workers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/widgets/worker_section.dart';

class FavoriteWorkers extends ConsumerWidget {
  const FavoriteWorkers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteWorkersAsync = ref.watch(favoriteWorkersProvider);
    final actions = ref.read(favoriteWorkersActionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trabajadores Favoritos')),
      body: favoriteWorkersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (favoriteWorkers) {
          if (favoriteWorkers.isEmpty) {
            return const Center(child: Text('No tenés trabajadores favoritos.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favoriteWorkers.length,
            itemBuilder: (context, index) {
              final worker = favoriteWorkers[index];

              return Stack(
                children: [
                  WorkerSection(professionalId: worker.id),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'contact':
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Contactando a ${worker.nombre}...')),
                            );
                            break;

                          case 'delete':
                            await actions.removeFromFavorites(worker.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${worker.nombre} eliminado de favoritos')),
                            );
                            break;

                          case 'details':
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ver perfil de ${worker.nombre}')),
                            );
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'details', child: Text('Ver perfil')),
                        PopupMenuItem(value: 'contact', child: Text('Contactar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
