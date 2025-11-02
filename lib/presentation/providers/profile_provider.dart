import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/core/data/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return ProfileRepository(db);
});

final professionalFutureProvider = FutureProvider.family<Profile?, String>((ref, profileId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchProfileById(profileId);
});