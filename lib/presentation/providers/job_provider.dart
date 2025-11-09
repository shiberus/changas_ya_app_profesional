import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentClientIdProvider = StateProvider<String>(
  (ref) => 'test-client-mock',
);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

class JobNotifier extends StateNotifier<List<Job>> {
  final String _currentClientId;
  final FirebaseFirestore _db;

  JobNotifier(this._currentClientId, this._db) : super([]);

  Future<void> getPublishedJobsByClient() async {
    try {
      final jobsCollection = _db
          .collection('trabajos')
          .withConverter(
            fromFirestore: Job.fromFirestore,
            toFirestore: (Job job, _) => job.toFirestore(),
          );
      final query = jobsCollection.where(
        'clientId',
        isEqualTo: _currentClientId,
      );
      final snapshot = await query.get();
      final jobs = snapshot.docs.map((doc) => doc.data()).toList();
      state = jobs;
    } catch (e) {
      print('Error al cargar trabajos publicados desde Firebase: $e');
      state = [];
    }
  }

  Future<void> assignJob(String jobId, String workerId, double budgetManPower, double budgetSpares) async {
    try {
      final jobRef = _db.collection('trabajos').doc(jobId);

      await jobRef.update({
        'status': 'En marcha',
        'workerId': workerId,
        'budgetManPower': budgetManPower,
        'budgetSpares': budgetSpares,
      });
    } catch (e) {
      print('Error al asignar el trabajo $jobId al worker $workerId: $e');
    }
  }
  
  Future<void> addJob(Map<String, dynamic> jobData) async {
    try {
      final completeJobData = {...jobData, 'clientId': _currentClientId};

      await _db.collection('trabajos').add(completeJobData);
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al crear job: $e');
      rethrow;
    }
  }

  Future<int> countJobsByWorkerId(String workerId) async {
    try {
      final Query query = _db.collection('trabajos')
        .where('workerId', isEqualTo: workerId)
        .where('status', isEqualTo: 'Finalizado');
      final aggregateSnapshot = await query.count().get();
      final int? totalJobs = aggregateSnapshot.count; 
      return totalJobs ?? 0;
    } catch (e) {
      print("Error desconocido al contar trabajos: $e");
      return 0;
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentClientIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  return JobNotifier(clientId, db);
});

final totalJobsProvider = FutureProvider.family<int, String>((ref, workerId) async {
  final jobNotifier = ref.read(jobProvider.notifier);
  return jobNotifier.countJobsByWorkerId(workerId);
});