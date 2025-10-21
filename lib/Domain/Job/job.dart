// lib/domain/job.dart

class Job {

  final String id;
  final String title;
  final String status;
  final DateTime datePosted;
  final List<String> imageUrls;

  final String clientId;
  final String? workerId;
  final String description;

  final double? budgetManpower;
  final double? budgetSpares;

  final DateTime? dateStart; 
  final DateTime? dateEnd; 

  final String? paymentMethod;

  Job({
    required this.id,
    required this.title,
    required this.status,
    required this.imageUrls,
    required this.description,
    required this.clientId, 
    required this.datePosted,
    required this.budgetManpower,
    required this.budgetSpares,
    this.workerId,
    this.dateStart,
    this.dateEnd,
    this.paymentMethod,
  });

  

  double get budgetTotal {
    final manpower = budgetManpower ?? 0.0;
    final spares = budgetSpares ?? 0.0;
    return manpower + spares;
  }
}