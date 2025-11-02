// domain/bid/bid.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Bid {
  final String id; 
  final String jobId;
  final String workerId;
  final double budgetManpower;
  final double budgetSpares;
  final double budgetTotal;
  final String message;
  final String status;
  final DateTime createdDate;

  const Bid({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.budgetManpower,
    required this.budgetSpares,
    required this.budgetTotal,
    required this.message,
    required this.status,
    required this.createdDate,
  });

  factory Bid.fromFirestore(Map<String, dynamic> data, String id) {
    // Conversion a doubles
    final manpower = (data['budgetManPower'] as num?)?.toDouble() ?? 0.0;
    final spares = (data['budgetSpares'] as num?)?.toDouble() ?? 0.0;
    
    final total = (manpower + spares);

    return Bid(
      id: id,
      jobId: data['jobId'] as String,
      workerId: data['workerId'] as String,
      budgetManpower: manpower,
      budgetSpares: spares,
      budgetTotal: total,
      message: data['message'] as String,
      status: data['status'] as String,
      createdDate: (data['createdDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'jobId': jobId,
      'workerId': workerId,
      'budgetManPower': budgetManpower,
      'budgetSpares': budgetSpares,
      'budgetTotal': budgetTotal,
      'message': message,
      'status': status,
      'createdDate': Timestamp.fromDate(createdDate), 
    };
  }
}