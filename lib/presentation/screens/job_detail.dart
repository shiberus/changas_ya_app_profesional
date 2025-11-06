import 'package:changas_ya_app/presentation/providers/job_detail_provider.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:changas_ya_app/presentation/widgets/worker_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:go_router/go_router.dart';

class JobDetail extends ConsumerWidget {
  static const name = 'Job Detail';
  final Job job;

  const JobDetail({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobId = job.id;
    final jobImages = job.imageUrls;

    ref.listen<String>(paymentMethodProvider(jobId), (prev, next) async {
      if (next.isNotEmpty && next != prev) {
        final db = FirebaseFirestore.instance;
        await db.collection('trabajos').doc(jobId).update({
          'paymentMethod': next,
        });
      }
    });

    final selectedRating = 0;
    // final selectedRating = ref.watch(ratingProvider(jobId));
    final selectedPayment = ref.watch(paymentMethodProvider(jobId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Trabajo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: jobImages.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(jobImages[index]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Descripción del trabajo",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(job.description),
            const SizedBox(height: 16),
            (job.workerId != null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WorkerSection(professionalId: job.workerId!),
                      Text(
                        "Medio de pago:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (var option in ['Efectivo', 'Débito', 'Crédito'])
                            ChoiceChip(
                              label: Text(option),
                              selected: selectedPayment == option,
                              onSelected: (_) {
                                ref.read(paymentMethodProvider(jobId).notifier,).state = option;
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text('Fecha de inicio: ${job.dateStart}'),
                      Text('Fecha de fin: ${job.dateEnd}'),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            final jobId = job.id;
                            context.pushNamed(
                              'bids', 
                              pathParameters: {'jobId': jobId}, 
                            );
                          },
                          child: const Text("Ver Postulaciones"),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
