import 'package:changas_ya_app/Domain/Rating/rating.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';
import 'package:changas_ya_app/presentation/providers/rating_form_provider.dart';
import 'package:changas_ya_app/presentation/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RateWorkerCard extends ConsumerWidget {
  final String professionalId;
  final String jobId;

  const RateWorkerCard({
    super.key,
    required this.professionalId,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(ratingFormProvider);
    final formNotifier = ref.read(ratingFormProvider.notifier);
    final currentUserId = ref.watch(currentUserIdProvider);
    final submitRating = ref.read(ratingSubmitProvider);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Calificar al profesional",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            // ⭐ Selector de estrellas
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    starIndex <= formState.score
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: () => formNotifier.setScore(starIndex),
                );
              }),
            ),

            const SizedBox(height: 10),

            // 📝 Campo de comentario
            TextField(
              onChanged: formNotifier.setComment,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Escribí tu opinión...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📩 Botón de enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: formState.isSubmitting
                    ? null
                    : () async {
                        if (formState.score == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Por favor seleccioná una calificación')),
                          );
                          return;
                        }

                        formNotifier.setSubmitting(true);

                        try {
                          final rating = Rating(
                            id: '',
                            reviewerId: currentUserId,
                            reviewedId: professionalId,
                            jobId: jobId,
                            score: formState.score,
                            reviewedType: 'worker',
                            comment: formState.comment
                          );

                          await submitRating(rating);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Opinión enviada con éxito!'),
                            ),
                          );

                          formNotifier.reset();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al enviar: $e')),
                          );
                        } finally {
                          formNotifier.setSubmitting(false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: formState.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Enviar Calificación"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
