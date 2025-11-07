import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:changas_ya_app/presentation/widgets/rating_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleProfile extends ConsumerWidget {
  final String workerId;
  final double budgetTotal;

  const SimpleProfile({
    super.key,
    required this.workerId,
    required this.budgetTotal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(professionalFutureProvider(workerId));
    return profileAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, s) => const Text(
        "Error al cargar perfil",
        style: TextStyle(color: Colors.red),
      ),
      data: (profile) {
        if (profile == null) {
          return const Text("Profesional no encontrado.");
        }

        const double rating = 4.5;

        return Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: profile.photoUrl != null
                  ? NetworkImage(profile.photoUrl!)
                  : null,
              child: profile.photoUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    RatingChip(profileId: profile.uid),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Presupuesto: ${budgetTotal}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}