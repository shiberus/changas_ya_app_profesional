import 'dart:io';

import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  
  return authState.maybeWhen(
    data: (user) => user?.uid ?? 'invitado',
    orElse: () => 'invitado', 
  );
});

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);


class JobNotifier extends StateNotifier<List<Job>> {
  final String _currentClientId;
  final FirebaseFirestore _db;

  JobNotifier(this._currentClientId, this._db) : super([]) {
    if (_currentClientId.isNotEmpty && _currentClientId != 'invitado') {
      getPublishedJobsByClient();
    }
  }

  Future<void> getPublishedJobsByClient() async {
    try {
      if (_currentClientId == 'invitado') {
        state = [];
        return;
      }

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
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al asignar el trabajo $jobId al worker $workerId: $e');
    }
  }
  
  Future<void> addJob(Map<String, dynamic> jobData, List<File> images) async {
    try {
      if (_currentClientId == 'invitado') {
        throw Exception('Debes iniciar sesión para crear un trabajo');
      }

      // Generamos un id para despues guardar ahi y tenerlo de refe para las imagenes
      final jobRef = _db.collection('trabajos').doc();
      final jobId = jobRef.id;

      final List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        final file = images[i];

        final storageRef = FirebaseStorage.instance
          .ref()
          .child('trabajos/$_currentClientId/$jobId/image_$i.jpg');

        final uploadTask = await storageRef.putFile(file);

        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final completeJobData = {
        ...jobData,
        'clientId': _currentClientId,
        'imageUrls': imageUrls,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      await jobRef.set(completeJobData);

      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al crear trabajo: $e');
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

  Future<void> endJob(String jobId) async {
    try {
      final jobRef = _db.collection('trabajos').doc(jobId);
      await jobRef.update({
        'status': 'Finalizado',
        'dateEnd': DateTime.now()
      });
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al finalizar el trabajo $jobId');
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentUserIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  return JobNotifier(clientId, db);
});

final totalJobsProvider = FutureProvider.family<int, String>((ref, workerId) async {
  final jobNotifier = ref.read(jobProvider.notifier);
  return jobNotifier.countJobsByWorkerId(workerId);
});


final jobInitializerProvider = Provider<void>((ref) {
  ref.listen<String>(currentUserIdProvider, (previousId, newId) {
    if (previousId == 'invitado' && newId != 'invitado') {
      ref.invalidate(jobProvider);
    }
  });
});