import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:flutter/material.dart';

class WorkerSection extends StatelessWidget {

  final String professionalId;

  const WorkerSection({
    super.key,
    required this.professionalId,
  });
 
  // Agregar logica
  final int harcodedRating = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text("Profesional", style: Theme.of(context).textTheme.titleMedium),
        ProfileCard(profileId: professionalId),
        const SizedBox(height: 20),
        Text("Calificar profesional:", style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return IconButton(
              icon: Icon(
                starIndex <= harcodedRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                 print("Botón de calificación presionado (Funcionalidad pendiente)");
              },
            );
          }),
        ),
      ],
    );
  }
}