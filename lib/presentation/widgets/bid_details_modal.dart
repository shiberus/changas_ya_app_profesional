import 'dart:io';

import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/presentation/providers/job_provider.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BidDetailsModal extends ConsumerWidget {
  final Bid bid;

  const BidDetailsModal({super.key, required this.bid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            "Detalles de la Propuesta",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ProfileCard(profileId: bid.workerId),
          const SizedBox(height: 16),
          Text("Presupuesto", style: Theme.of(context).textTheme.titleLarge),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mano de obra"),
              Text(bid.budgetManpower.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Repuestos"), Text(bid.budgetSpares.toString())],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total"),
              Text(
                bid.budgetTotal.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final jobNotifier = ref.read(jobProvider.notifier);

                  final success = await jobNotifier
                      .assignJob(
                        bid.jobId,
                        bid.workerId,
                        bid.budgetManpower,
                        bid.budgetSpares,
                      )
                      .then((_) => true)
                      .catchError(
                        (_) => false,
                      ); // Aca analizo que devuelva para settear el success


                  String message = success
                      ? 'Trabajo asignado con éxito!'
                      : 'Error: No se pudo asignar el trabajo.';

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));

                  if(success) {
                    context.go('/');
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Aceptar Propuesta"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
