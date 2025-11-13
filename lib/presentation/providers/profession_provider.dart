import 'package:changas_ya_app/Domain/Profession/profession.dart';
import 'package:changas_ya_app/core/data/profession_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Repository provider
final professionRepositoryProvider = Provider<ProfessionRepository>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return ProfessionRepository(db);
});

// Future provider para traer las profesiones
final professionsProvider = FutureProvider<List<Profession>>((ref) async {
  final repo = ref.watch(professionRepositoryProvider);
  return repo.getAllProfessions();
});