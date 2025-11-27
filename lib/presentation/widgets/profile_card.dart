import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:changas_ya_app/presentation/widgets/rating_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileCard extends ConsumerWidget {
  final String profileId;


  const ProfileCard({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(professionalFutureProvider(profileId));

    return profile.when(
      loading: () => const Card(
        // Indicador de carga mientras se esperan los datos, circulo de carga
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => Card(
        // Mostrar error
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error al cargar perfil: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Perfil de cliente no disponible.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          );
        }


        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.00),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto del perfil
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                      ? NetworkImage(
                          profile.photoUrl!,
                        )
                      : null,
                  child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 30, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),

                // Informacion
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          RatingChip(profileId: profileId)
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
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
