import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/components/job_form.dart';
import 'package:changas_ya_app/presentation/providers/job_provider.dart';
import 'package:changas_ya_app/presentation/providers/navigation_provider.dart';

class CreateJobScreen extends ConsumerWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: JobForm(
          onSubmit: (formData) async {
            try {
              await ref.read(jobProvider.notifier).addJob(formData);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '¡Trabajo creado exitosamente!',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green[600],
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );

                ref.read(selectedTabIndexProvider.notifier).state = 0;
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Error: $e')),
                      ],
                    ),
                    backgroundColor: Colors.red[600],
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
