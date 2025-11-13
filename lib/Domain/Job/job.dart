// lib/domain/job.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    this.budgetManpower,
    this.budgetSpares,
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

  String get formattedDateEnd {
    if (dateEnd == null) {
      return 'Fecha no definida';
    }

    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateEnd!);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'status': status,
      'datePosted': Timestamp.fromDate(datePosted),
      'imageUrls': imageUrls,
      'clientId': clientId,
      'description': description,
      if (budgetManpower != null) 'budgetManpower': budgetManpower,
      if (budgetSpares != null) 'budgetSpares': budgetSpares,
      if (workerId != null) 'workerId': workerId,
      if (dateStart != null) 'dateStart': Timestamp.fromDate(dateStart!),
      if (dateEnd != null) 'dateEnd': Timestamp.fromDate(dateEnd!),
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
    };
  }

  factory Job.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    DateTime? getDateTime(dynamic field) {
      if (field == null) return null;
      if (field is Timestamp) {
        return field.toDate();
      }
      return null;
    }

    return Job(
      id: snapshot.id,
      title: data?['title'] ?? 'Sin título',
      status: data?['status'] ?? 'Desconocido',

      datePosted: getDateTime(data?['datePosted'])!,

      imageUrls: List<String>.from(data?['imageUrls'] ?? []),

      clientId: data?['clientId'] ?? '',
      description: data?['description'] ?? '',

      budgetManpower: data?['budgetManpower']?.toDouble(),
      budgetSpares: data?['budgetSpares']?.toDouble(),

      workerId: data?['workerId'],
      dateStart: getDateTime(data?['dateStart']),
      dateEnd: getDateTime(data?['dateEnd']),
      paymentMethod: data?['paymentMethod'],
    );
  }
}
