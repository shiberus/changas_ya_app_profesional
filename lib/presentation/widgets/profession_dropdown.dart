import 'package:changas_ya_app/Domain/Profession/profession.dart';
import 'package:changas_ya_app/presentation/providers/profession_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfessionDropdown extends ConsumerWidget {
  final void Function(Profession?)? onChanged;
  final Profession? value;

  const ProfessionDropdown({super.key, this.onChanged, this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfessions = ref.watch(professionsProvider);

    return asyncProfessions.when(
      data: (professions) {
        if (professions.isEmpty) {
          return const Text('No hay profesiones disponibles');
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Oficios relacionados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Profession>(
                decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecciona el oficio necesario',
                        prefixIcon: Icon(Icons.build_outlined),
                      ),
                value: value,
                items: professions
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p.nombre,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
