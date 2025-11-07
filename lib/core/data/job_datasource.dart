import 'package:changas_ya_app/Domain/Job/job.dart';

List<Job> getMockJobsByClient(String clientId) {
  
  // Usaremos una fecha base para simular la antigüedad
  final now = DateTime.now();
  final String fakeClientId = 'tesst2-client-mock';
  return [
    // 1. TRABAJO EN MARCHA (Ejemplo de trabajo en progreso)
    Job(
      id: 'job-001',
      title: 'Reparación de Fuga en Tubería Principal',
      status: 'En marcha',
      imageUrls: [
        'https://picsum.photos/id/100/200/300',
        'https://picsum.photos/id/101/200/300',
      ],
      clientId: clientId, // Asignado al cliente simulado
      description: 'Fuga de agua importante en la pared de la cocina. Se necesita plomero urgente con experiencia en tuberías antiguas.',
      budgetManpower: 8000.00,
      budgetSpares: 3500.00,
      datePosted: now.subtract(const Duration(days: 5)),
      workerId: 'worker-101',
      dateStart: now.subtract(const Duration(days: 2)),
      paymentMethod: null,
    ),

    // 2. TRABAJO BUSCANDO PROFESIONAL (Ejemplo de publicación nueva)
    Job(
      id: 'job-002',
      title: 'Instalación de Aire Acondicionado',
      status: 'Buscando profesional',
      imageUrls: [
        'https://picsum.photos/id/102/200/300',
      ],
      clientId: fakeClientId,
      description: 'Instalar un equipo split 3500 frigorías en un segundo piso. El cliente provee el equipo. Se requiere certificado de matriculado.',
      budgetManpower: 6000.00,
      budgetSpares: null, // Presupuesto de repuestos nulo o cero
      datePosted: now.subtract(const Duration(hours: 10)),
      workerId: null, // Aún no tiene trabajador asignado
      dateStart: null,
      paymentMethod: null,
    ),

    // 3. TRABAJO FINALIZADO (Ejemplo de trabajo completado y pagado)
    Job(
      id: 'job-003',
      title: 'Pintura Exterior y Reparación de Humedad',
      status: 'Finalizado',
      imageUrls: [
        'https://picsum.photos/id/103/200/300',
        'https://picsum.photos/id/104/200/300',
        'https://picsum.photos/id/105/200/300',
      ],
      clientId: clientId,
      description: 'Pintura completa de fachada (2 pisos) y sellado de grietas por humedad.',
      budgetManpower: 25000.00,
      budgetSpares: 12000.00,
      datePosted: now.subtract(const Duration(days: 30)),
      workerId: 'worker-202',
      dateStart: now.subtract(const Duration(days: 25)),
      dateEnd: now.subtract(const Duration(days: 10)),
      paymentMethod: 'Débito',
    ),
  ];
}