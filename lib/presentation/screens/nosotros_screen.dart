import 'package:flutter/material.dart';

class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});

  static const List<String> integrantes = [
    'Juan Mateo Alonso de Armiño',
    'Fernando Sánchez',
    'Benjamín Francisco',
    'Gonzalo Slullitel',
    'Santiago Lopez Cane',
    'Ezequiel Meister',
  ];

  static const List<String> materias = [
    'Proyecto Final',
    'Analista de Sistemas',
  ];

  TextStyle get titleStyle => const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle get bodyStyle => const TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nosotros'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del equipo
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('lib/images/equipo_generico.png'),
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24),

            // Nombre del equipo
            Center(
              child: Text(
                'Equipo de Desarrollo - Changas Ya!',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Descripción de la empresa
            Text(
              'Somos un equipo de estudiantes del Instituto Tecnológico ORT '
              'dedicados a crear soluciones digitales que conectan clientes '
              'con profesionales de manera rápida y confiable. Nuestra misión '
              'es simplificar el proceso de búsqueda de servicios, brindando una '
              'plataforma eficiente y segura.',
              textAlign: TextAlign.justify,
              style: bodyStyle.copyWith(color: theme.textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 24),

            // Integrantes
            Text('Integrantes del equipo:', style: titleStyle),
            const SizedBox(height: 8),
            ...integrantes.map((i) => Text('• $i', style: bodyStyle.copyWith(color: theme.textTheme.bodyMedium?.color))),
            const SizedBox(height: 24),

            // Materias relacionadas
            Text('Materias relacionadas:', style: titleStyle),
            const SizedBox(height: 8),
            ...materias.map((m) => Text('• $m', style: bodyStyle.copyWith(color: theme.textTheme.bodyMedium?.color))),
            const SizedBox(height: 24),

            // Información institucional
            Text('Información institucional:', style: titleStyle),
            const SizedBox(height: 8),
            Text(
              'Instituto Tecnológico ORT Argentina\n'
              'Carrera: Analista de Sistemas\n'
              'Año: 2025',
              style: bodyStyle.copyWith(color: theme.textTheme.bodyMedium?.color),
            ),
          ],
        ),
      ),
    );
  }
}
