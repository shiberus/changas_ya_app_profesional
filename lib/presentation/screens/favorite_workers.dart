import 'package:changas_ya_app/presentation/providers/favorite_workers_provider.dart';
import 'package:changas_ya_app/presentation/widgets/worker_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteWorkers extends ConsumerWidget {
  const FavoriteWorkers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteWorkersAsync = ref.watch(favoriteWorkersProvider);

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
              return WorkerSection(professionalId: worker.uid);
            },
          );
        },
      ),
    );
  }
}
