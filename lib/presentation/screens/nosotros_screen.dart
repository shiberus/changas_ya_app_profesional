import 'package:flutter/material.dart';

class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Imagen del equipo o logo genérico (REVISAR)
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/images/equipo_generico.png'),
              ),
            ),
            const SizedBox(height: 24),

            // Nombre del equipo
            const Center(
              child: Text(
                'Equipo de Desarrollo - Changas Ya!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Descripción de la empresa/app
            const Text(
              'Somos un equipo de estudiantes del Instituto Tecnológico ORT '
              'dedicados a crear soluciones digitales que conectan clientes '
              'con profesionales de manera rápida y confiable. Nuestra misión '
              'es simplificar el proceso de búsqueda de servicios, brindando una '
              'plataforma eficiente y segura.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Integrantes
            const Text(
              'Integrantes del equipo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Juan Mateo Alonso de Armiño'),
            const Text('• Fernando Sánchez'),
            const Text('• Benjamín Francisco'),
            const Text('• Gonzalo Slullitel'),
            const Text('• Santiago Lopez Cane'),
            const Text('• Ezequiel Meister'),
            const SizedBox(height: 24),

            // Materias relacionadas
            const Text(
              'Materias relacionadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Proyecto Final'),
            const Text('• Analista de Sistemas'),
            const SizedBox(height: 24),

            // Información institucional
            const Text(
              'Información institucional:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Instituto Tecnológico ORT Argentina\n'
              'Carrera: Analista de Sistemas\n'
              'Año: 2025',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
